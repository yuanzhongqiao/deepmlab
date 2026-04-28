/*  Scicos
*
*  Copyright (C) 2015 - Scilab Enterprises - Paul Bignier
*  Copyright (C) INRIA - METALAU Project <scicos@inria.fr>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
*
* See the file ./license.txt
*/
/*--------------------------------------------------------------------------*/
#include <vector>
#include <algorithm>
#include <cstring>

#include "var2vec.hxx"
#include "vec2var.hxx"

#include "callable.hxx"
#include "configvariable.hxx"
#include "double.hxx"
#include "function.hxx"
#include "internal.hxx"
#include "list.hxx"
#include "scilabWrite.hxx"

extern "C"
{
#include "machine.h"
#include "sciblk2.h"
#include "import.h" /* getscicosvarsfromimport */
#include "scicos.h" /* set_block_error(), get_block_number() */
#include "Scierror.h"
#include "scicos_internal.h" /* COSDEBUG_struct */
}

static double toDouble(const int i)
{
    return static_cast<double>(i);
};

static void setErrAndFree(types::typed_list out)
{
    // Set the block error to an internal error
    set_block_error(-5);
    for (size_t i = 0; i < out.size(); ++i)
    {
        out[i]->killMe();
    }
};

static std::string reportError(const char* err)
{
    // resolve current block
    int kfun = get_block_number();

    // resolve uid
    char emptyChar = '0';
    char* uid = &emptyChar;
    char** allUID = nullptr;
    int n_uid = 1, m_uid = 1;
    if(getscicosvarsfromimport("uid", (void**) &allUID, &n_uid, &m_uid) && n_uid >= kfun)
    {
        uid = allUID[kfun - 1];
    }

    std::string message;
    message.resize(BUFSIZ);
    snprintf((char *) message.data(), BUFSIZ - 1, err, kfun, uid);
    return message;
};

/*--------------------------------------------------------------------------*/
void sciblk2(int* flag, int* nevprt, double* t, double xd[], double x[], int* nx, double z[], int* nz, double tvec[], int* ntvec, double rpar[], int* nrpar,
             int ipar[], int* nipar, double* inptr[], int insz[], int* nin, double* outptr[], int outsz[], int* nout, void* scsptr)
{
    types::typed_list in(8), out;

    types::Double* Flag = new types::Double(*flag);
    in[0] = Flag;

    types::Double* Nevprt = new types::Double(*nevprt);
    in[1] = Nevprt;

    types::Double* T = new types::Double(*t);
    in[2] = T;

    types::Double* X = new types::Double(*nx, 1);
    memcpy(X->get(), x, *nx * sizeof(double));
    in[3] = X;

    types::Double* Z = nullptr;
    if (*nz == 0)
    {
        Z = types::Double::Empty();
    }
    else
    {
        Z = new types::Double(*nz, 1);
        memcpy(Z->get(), z, *nz * sizeof(double));
    }
    in[4] = Z;

    types::Double* Rpar = new types::Double(*nrpar, 1);
    memcpy(Rpar->get(), rpar, *nrpar * sizeof(double));
    in[5] = Rpar;

    // Treating 'ipar' differently because it is an int tab, unlike the other double ones
    types::Double* Ipar = new types::Double(*nipar, 1);
    std::transform(ipar, ipar + *nipar, Ipar->get(), toDouble);
    in[6] = Ipar;

    types::List* Nin = new types::List();
    for (int i = 0; i < *nin; ++i)
    {
        int nu = insz[i];
        int nu2 = insz[*nin + i];
        types::Double* U = new types::Double(nu, nu2);
        memcpy(U->get(), inptr[i], nu * nu2 * sizeof(double));
        Nin->append(U);
    }
    in[7] = Nin;

    /***********************
    * Call Scilab function *
    ***********************/
    types::Callable* pCall = reinterpret_cast<types::Callable*>(scsptr);

    if(!ConfigVariable::increaseRecursion())
        throw ast::RecursionException();

    // add line and function name in where
    ConfigVariable::where_begin(1, pCall);

    types::optional_list opt;
    types::Callable::ReturnValue Ret;

    try
    {
        Ret = pCall->call(in, opt, 5, out);
        ConfigVariable::where_end();
        ConfigVariable::decreaseRecursion();

        if (Ret != types::Function::OK)
        {
            set_block_error(-1);
            return;
        }
    }
    catch (const ast::InternalError &ie)
    {
        if (C2F(cosdebug).cosd >= 1)
        {
            std::wostringstream ostr;
            ConfigVariable::whereErrorToString(ostr);
            ostr << ConfigVariable::getLastErrorMessage();

            bool oldSilentError = ConfigVariable::isSilentError();
            ConfigVariable::setSilentError(false);
            scilabErrorW(ostr.str().c_str());
            ConfigVariable::setSilentError(oldSilentError);
            ConfigVariable::resetWhereError();
        }

        ConfigVariable::where_end();
        ConfigVariable::decreaseRecursion();

        set_block_error(-1);
        throw;
    }

    if (out.size() != 5)
    {
        set_block_error(-1);
        throw ast::InternalError(reportError(_("User-defined function of Block #%d - \"%s\" did not output 5 values.\n")));
        return;
    }

    if (*flag == 0)
    {
        /*  x'  computation */
        if (!out[0]->isDouble())
        {
            setErrAndFree(out);
            Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output xd as first output argument.\n")).c_str());
            return;
        }
        types::Double* XDout = out[0]->getAs<types::Double>();
        memcpy(xd, XDout->get(), std::min(*nx, XDout->getSize()) * sizeof(double));
    }

    if (*flag == 0)
    {
        /*  x'  computation */
        if (!out[0]->isDouble())
        {
            setErrAndFree(out);
            Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output xd as first output argument.\n")).c_str());
            return;
        }
        types::Double* XDout = out[0]->getAs<types::Double>();
        memcpy(xd, XDout->get(), std::min(*nx, XDout->getSize()) * sizeof(double));
    }

    if (*flag == 3)
    {
        /* output event */
        if (!out[1]->isDouble())
        {
            setErrAndFree(out);
            Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output event as second output argument.\n")).c_str());
            return;
        }
        types::Double* Tout = out[1]->getAs<types::Double>();
        memcpy(tvec, Tout->get(), std::min(*ntvec, Tout->getSize()) * sizeof(double));
    }

    /* all flags even though they might not be needed */
    if (!out[2]->isDouble())
    {
        setErrAndFree(out);
        Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output discrete states as third output argument.\n")).c_str());
        return;
    }
    types::Double* Zout = out[2]->getAs<types::Double>();
    memcpy(z, Zout->get(), std::min(*nz, Zout->getSize()) * sizeof(double));

    if (!out[3]->isDouble())
    {
        setErrAndFree(out);
        Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output continuous states as fourth output argument.\n")).c_str());
        return;
    }
    types::Double* Xout = out[3]->getAs<types::Double>();
    memcpy(x, Xout->get(), std::min(*nx, Xout->getSize()) * sizeof(double));

    /* match outputs (even if not present) */
    if (!out[4]->isList())
    {
        setErrAndFree(out);
        Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output values as fifth output argument.\n")).c_str());
        return;
    }
    types::List* Yout = out[4]->getAs<types::List>();
    for (int k = 0; k < std::min(*nout, Yout->getSize()); ++k)
    {
        if (!Yout->get(k)->isDouble())
        {
            setErrAndFree(out);
            Scierror(888, reportError(_("User-defined function of Block #%d - \"%s\" did not output double values(%%d) as fifth output argument.\n")).c_str(), k);
            return;
        }
        types::Double* KthElement = Yout->get(k)->getAs<types::Double>();
        double* y = (double*) outptr[k];
        int ny = outsz[k];
        int ny2 = outsz[*nout + k];
        memcpy(y, KthElement->get(), std::min(ny * ny2, KthElement->getSize()) * sizeof(double));
    }

    // clean all 
    for (size_t i = 0; i < out.size(); ++i)
    {
        out[i]->killMe();
    }
}
