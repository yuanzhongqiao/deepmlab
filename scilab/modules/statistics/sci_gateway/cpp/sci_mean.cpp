/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
/*--------------------------------------------------------------------------*/
#include <limits>

#include "double.hxx"
#include "function.hxx"
#include "overload.hxx"
#include "statistics_gw.hxx"
#include "string.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
#include "sci_malloc.h"
#include "sciprint.h"
}
/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_mean(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    int rhs = static_cast<int>(in.size());
    if (rhs < 1 || rhs > 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "mean", 1, 2);
        return types::Function::Error;
    }

    if (in[0]->isDouble() == false)
    {
        return Overload::generateNameAndCall(L"mean", in, _iRetCount, out);
    }

    types::Double* d = in[0]->getAs<types::Double>();
    int dim = d->getDims();
    int* dims = d->getDimsArray();

    int orient = -1;
    if (rhs == 2)
    {
        if (in[1]->isString() == false && in[1]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"), "mean", 2, "\"r\", \"c\", \"m\"");
            return types::Function::Error;
        }

        if (in[1]->isString())
        {
            wchar_t* o = in[1]->getAs<types::String>()->get()[0];
            switch (o[0])
            {
                case L'*':
                    orient = -1;
                    rhs = 1;
                    break;
                case L'r':
                    orient = 1;
                    break;
                case L'c':
                    orient = 2;
                    break;
                case L'm':
                {
                    for (int i = 0; i < dim; ++i)
                    {
                        if (dims[i] > 1)
                        {
                            orient = i + 1;
                            break;
                        }
                    }

                    if (orient == -1)
                    {
                        rhs = 1;
                    }
                    break;
                }
            }
        }
        else
        {
            orient = (int)in[1]->getAs<types::Double>()->get()[0];
        }

        if (orient > dim)
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"), "mean", 2, "\"r\", \"c\", \"m\"");
            return types::Function::Error;
        }
    }

    if (rhs == 1)
    {
        if (d->getSize() == 0)
        {
            out.push_back(new types::Double(std::numeric_limits<double>::quiet_NaN()));
            return types::Function::OK;
        }

        types::typed_list in2 = {in[0]};


        if (Overload::call(L"sum", in2, 1, out) != types::Function::OK)
        {
            return types::Function::Error;
        }

        types::Double* pout = out[0]->getAs<types::Double>();
        pout->get()[0] /= d->getSize();
        if (pout->isComplex())
        {
            pout->getImg()[0] /= d->getSize();
        }

    }
    else //rhs == 2
    {
        types::typed_list in2 = {in[0]};
        in2.push_back(new types::Double((double)orient));
        if (Overload::call(L"sum", in2, 1, out) != types::Function::OK)
        {
            return types::Function::Error;
        }

        types::Double* pout = out[0]->getAs<types::Double>();
        for (int i = 0; i < pout->getSize(); ++i)
        {
            pout->get()[i] /= dims[orient - 1];
            if (pout->isComplex())
            {
                pout->getImg()[i] /= dims[orient - 1];
            }
        }
    }

    return types::Function::OK;
}
