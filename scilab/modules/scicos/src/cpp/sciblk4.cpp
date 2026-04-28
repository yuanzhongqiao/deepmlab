/*  Scicos
*
*  Copyright (C) 2015 - Scilab Enterprises - Antoine ELIAS
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
#include <cstring>
#include <cstdio>

#include "internal.hxx"
#include "callable.hxx"
#include "list.hxx"
#include "tlist.hxx"
#include "double.hxx"
#include "int.hxx"
#include "function.hxx"
#include "scilabWrite.hxx"

extern "C"
{
#include "sciblk4.h"
#include "scicos.h"
#include "import.h"
#include "scicos_internal.h" /* COSDEBUG_struct */
}

#include "createblklist.hxx"

/*--------------------------------------------------------------------------*/
template <typename T>
bool sci2var(T* p, void* dest, const int row, const int col)
{
    const int size = p->getSize();
    typename T::type* srcR = p->get();

    if (row != p->getRows())
    {
        return false;
    }

    if (col != p->getCols())
    {
        return false;
    }

    if (p->isComplex())
    {
        typename T::type* srcI = p->getImg();
        if (dest == nullptr)
        {
            return false;
        }

        typename T::type* destR = (typename T::type*)dest;
        typename T::type* destI = destR + size;
        for (int i = 0; i < size; ++i)
        {
            destR[i] = srcR[i];
            destI[i] = srcI[i];
        }
    }
    else
    {
        if (dest == nullptr)
        {
            return false;
        }

        typename T::type* destR = (typename T::type*)dest;
        for (int i = 0; i < size; ++i)
        {
            destR[i] = srcR[i];
        }
    }

    return true;
}

/*--------------------------------------------------------------------------*/
static bool sci2var(types::InternalType* p, void* dest, const int desttype, const int row, const int col)
{
    switch (p->getType())
    {
        case types::InternalType::ScilabDouble:
        {
            if (p->getAs<types::Double>()->isComplex() && desttype == SCSCOMPLEX_N)
            {
                return sci2var(p->getAs<types::Double>(), dest, row, col);
            }

            if (p->getAs<types::Double>()->isComplex() == false && desttype == SCSREAL_N)
            {
                return sci2var(p->getAs<types::Double>(), dest, row, col);
            }
            return false;
        }
        case types::InternalType::ScilabInt8:
        {
            if (desttype == SCSINT8_N)
            {
                return sci2var(p->getAs<types::Int8>(), dest, row, col);
            }
            return false;
        }
        case types::InternalType::ScilabInt16:
        {
            if (desttype == SCSINT16_N)
            {
                return sci2var(p->getAs<types::Int16>(), dest, row, col);
            }
            return false;
        }
        case types::InternalType::ScilabInt32:
        {
            if (desttype == SCSINT32_N)
            {
                return sci2var(p->getAs<types::Int32>(), dest, row, col);
            }
            return false;
        }
        case types::InternalType::ScilabUInt8:
        {
            if (desttype == SCSUINT8_N)
            {
                return sci2var(p->getAs<types::UInt8>(), dest, row, col);
            }
            return false;
        }
        case types::InternalType::ScilabUInt16:
        {
            if (desttype == SCSUINT16_N)
            {
                return sci2var(p->getAs<types::UInt16>(), dest, row, col);
            }
            return false;
        }
        case types::InternalType::ScilabUInt32:
        {
            if (desttype == SCSUINT32_N)
            {
                return sci2var(p->getAs<types::UInt32>(), dest, row, col);
            }
            return false;
        }
        default:
            return false;
    }

    return false;
}

/*--------------------------------------------------------------------------*/
static bool getDoubleArray(types::InternalType* p, double* dest, const int destLen)
{
    if (p == nullptr)
    {
        return false;
    }

    if (p->isDouble())
    {
        types::Double* d = p->getAs<types::Double>();
        const int size = d->getSize();
        if (size == 0)
        {
            return true;
        }

        if (dest == nullptr)
        {
            return false;
        }

        memcpy(dest, d->get(), sizeof(double) * std::min(size, destLen));
        return true;
    }

    return false;
}

/*--------------------------------------------------------------------------*/
static bool getDoubleArrayAsInt(types::InternalType* p, int* dest, const int destLen)
{
    if (p == nullptr)
    {
        return false;
    }

    if (p->isDouble())
    {
        types::Double* d = p->getAs<types::Double>();
        const int size = d->getSize();
        if (size == 0)
        {
            return true;
        }

        double* dbl = d->get();
        for (int i = 0; i < std::min(size, destLen); ++i)
        {
            dest[i] = static_cast<int>(dbl[i]);
        }
        return true;
    }

    return false;
}
/*--------------------------------------------------------------------------*/
// copy p content to dest
template<typename T>
static bool copy(T* dest, T* src)
{   
    if (dest->getRef() > 1)
        return false;

    for (int i = 0; i < src->getSize(); ++i)
        dest->set(i, src->get(i));
    return true;
};
/*--------------------------------------------------------------------------*/
static bool getOpaquePointer(types::InternalType* p, void** dest)
{
    if (p == nullptr)
    {
        return false;
    }

    types::InternalType* pITDest = *(types::InternalType**) dest;
    if (p == pITDest)
    {
        // no copy needed
        return true;
    }

    auto pType = p->getType();
    auto destType = pITDest->getType();
    if (pType != destType)
    {
        return false;
    }

    switch(pType)
    {
        case types::InternalType::ScilabDouble:
            return copy<>(pITDest->getAs<types::Double>(), p->getAs<types::Double>());
        case types::InternalType::ScilabInt8:
            return copy<>(pITDest->getAs<types::Int8>(), p->getAs<types::Int8>());
        case types::InternalType::ScilabInt16:
            return copy<>(pITDest->getAs<types::Int16>(), p->getAs<types::Int16>());
        case types::InternalType::ScilabInt32:
            return copy<>(pITDest->getAs<types::Int32>(), p->getAs<types::Int32>());
        case types::InternalType::ScilabUInt8:
            return copy<>(pITDest->getAs<types::UInt8>(), p->getAs<types::UInt8>());
        case types::InternalType::ScilabUInt16:
            return copy<>(pITDest->getAs<types::UInt16>(), p->getAs<types::UInt16>());
        case types::InternalType::ScilabUInt32:
            return copy<>(pITDest->getAs<types::UInt32>(), p->getAs<types::UInt32>());
        case types::InternalType::ScilabList:
            return copy<>(pITDest->getAs<types::List>(), p->getAs<types::List>());
        default:
            return false;
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
void sciblk4(scicos_block* blk, const int flag)
{
    int ierr = 0;
    /* Retrieve block number */
    const int kfun = get_block_number();

    /* Retrieve 'funtyp' by import structure */
    int* ptr = nullptr;
    int nv = 0, mv = 0;
    char buf[] = "funtyp";
    ierr = getscicosvarsfromimport(buf, (void**)&ptr, &nv, &mv);
    if (ierr == 0)
    {
        set_block_error(-1);
        return;
    }
    const int* const funtyp = (int *)ptr;

    types::typed_list in, out;
    types::optional_list opt;

    /*****************************
    * Create Scilab tlist Blocks *
    *****************************/
    types::List* pITin = nullptr;
    types::List** work = (types::List**) blk->work;
    if (work != nullptr && *work != nullptr && blk->scsptr == nullptr)
    {
        // re-use the TList allocated on a previous call when not a debug block
        pITin = *work;
        pITin->DecreaseRef();
        pITin = refreshblklist(pITin, blk, -1, funtyp[kfun - 1], flag);
    }
    else
    {
        // Initialization of a TList from block structure
        pITin = createblklist(blk, -1, funtyp[kfun - 1]);
        if (pITin == nullptr)
        {
            set_block_error(-1);
            return;
        }
    }
    
    in.push_back(pITin);
    /* * flag * */
    in.push_back(new types::Double(flag));

    /***********************
    * Call Scilab function *
    ***********************/
    types::Callable* pCall = reinterpret_cast<types::Callable*>(blk->scsptr);

    ConfigVariable::where_begin(1, pCall);
    types::Callable::ReturnValue Ret;

    try
    {
        Ret = pCall->call(in, opt, 1, out);
        ConfigVariable::where_end();
        ConfigVariable::decreaseRecursion();

        if (Ret != types::Callable::OK)
        {
            set_block_error(-1);
            return;
        }
    }
    catch (const ast::InternalError &)
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
    
    if (out.size() != 1)
    {
        set_block_error(-1);
        throw ast::InternalError(reportError(_("User-defined function of Block #%d - \"%s\" did not output 5 values.\n")));
        return;
    }

    types::InternalType* pITout = out[0];
    if (pITout->isTList() == false)
    {
        set_block_error(-1);
    }
    auto t = pITout->getAs<types::TList>();
    
    switch (flag)
    {
        /**************************
        * update continuous state
        **************************/
        case 0:
        {
            if (blk->nx != 0)
            {
                /* 14 - xd */
                if (getDoubleArray(t->getField(L"xd"), blk->xd, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }

                if ((funtyp[kfun - 1] == 10004) || (funtyp[kfun - 1] == 10005))
                {
                    /* 15 - res */
                    if (getDoubleArray(t->getField(L"res"), blk->res, blk->nx) == false)
                    {
                        set_block_error(-1);
                        goto sciblk4_exit_free_data;
                    }
                }
            }
            break;
        }
        /**********************
        * update output state
        **********************/
        case 1:
        {
            /* 21 - outptr */
            if (blk->nout > 0)
            {
                types::InternalType* pIT = t->getField(L"outptr");
                if (pIT && pIT->isList())
                {
                    types::List* lout = pIT->getAs<types::List>();
                    if (blk->nout == lout->getSize())
                    {
                        for (int i = 0; i < blk->nout; ++i)
                        {
                            //update data
                            int row = blk->outsz[i];
                            int col = blk->outsz[i + blk->nout];
                            int type = blk->outsz[i + blk->nout * 2];
                            if (sci2var(lout->get(i), blk->outptr[i], type, row, col) == false)
                            {
                                set_block_error(-1);
                                goto sciblk4_exit_free_data;
                            }
                        }
                    }
                }
            }
            break;
        }
        case 2:
        {
            /* 7 - z */
            if (blk->nz != 0)
            {
                if (getDoubleArray(t->getField(L"z"), blk->z, blk->nz) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            /* 11 - oz */
            if (blk->noz != 0)
            {
                if (getOpaquePointer(t->getField(L"oz"), blk->ozptr) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            if (blk->nx != 0)
            {
                /* 13 - x */
                if (getDoubleArray(t->getField(L"x"), blk->x, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }

                /* 14 - xd */
                if (getDoubleArray(t->getField(L"xd"), blk->xd, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            break;
        }

        /***************************
        * update event output state
        ***************************/
        case 3:
        {
            /* 23 - evout */
            if (getDoubleArray(t->getField(L"evout"), blk->evout, blk->nevout) == false)
            {
                set_block_error(-1);
                goto sciblk4_exit_free_data;
            }
            break;
        }
        /**********************
        * state initialisation
        **********************/
        case 4:
        {
            /* 7 - z */
            if (blk->nz != 0)
            {
                if (getDoubleArray(t->getField(L"z"), blk->z, blk->nz) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            /* 11 - oz */
            if (blk->noz != 0)
            {
                if (getOpaquePointer(t->getField(L"oz"), blk->ozptr) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            if (blk->nx != 0)
            {
                /* 13 - x */
                if (getDoubleArray(t->getField(L"x"), blk->x, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }

                /* 14 - xd */
                if (getDoubleArray(t->getField(L"xd"), blk->xd, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            break;
        }

        case 5:
        {
            /* 7 - z */
            if (blk->nz != 0)
            {
                if (getDoubleArray(t->getField(L"z"), blk->z, blk->nz) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            /* 11 - oz */
            if (blk->noz != 0)
            {
                if (getOpaquePointer(t->getField(L"oz"), blk->ozptr) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            /* 21 - outptr */
            if (blk->nout > 0)
            {
                types::InternalType* pIT = t->getField(L"outptr");
                if (pIT && pIT->isList())
                {
                    types::List* lout = pIT->getAs<types::List>();
                    if (blk->nout == lout->getSize())
                    {
                        for (int i = 0; i < blk->nout; ++i)
                        {
                            //update data
                            const int row = blk->outsz[i];
                            const int col = blk->outsz[i + blk->nout];
                            const int type = blk->outsz[i + blk->nout * 2];
                            if (sci2var(lout->get(i), blk->outptr[i], type, row, col) == false)
                            {
                                set_block_error(-1);
                                goto sciblk4_exit_free_data;
                            }
                        }
                    }
                }
            }
            break;
        }

        /*****************************
        * output state initialisation
        *****************************/
        case 6:
        {
            /* 7 - z */
            if (blk->nz != 0)
            {
                if (getDoubleArray(t->getField(L"z"), blk->z, blk->nz) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            /* 11 - oz */
            if (blk->noz != 0)
            {
                if (getOpaquePointer(t->getField(L"oz"), blk->ozptr) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            if (blk->nx != 0)
            {
                /* 13 - x */
                if (getDoubleArray(t->getField(L"x"), blk->x, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }

                /* 14 - xd */
                if (getDoubleArray(t->getField(L"xd"), blk->xd, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }

            /* 21 - outptr */
            if (blk->nout > 0)
            {
                types::InternalType* pIT = t->getField(L"outptr");
                if (pIT && pIT->isList())
                {
                    types::List* lout = pIT->getAs<types::List>();
                    if (blk->nout == lout->getSize())
                    {
                        for (int i = 0; i < blk->nout; ++i)
                        {
                            //update data
                            const int row = blk->outsz[i];
                            const int col = blk->outsz[i + blk->nout];
                            const int type = blk->outsz[i + blk->nout * 2];
                            if (sci2var(lout->get(i), blk->outptr[i], type, row, col) == false)
                            {
                                set_block_error(-1);
                                goto sciblk4_exit_free_data;
                            }
                        }
                    }
                }
            }
            break;
        }

        /*******************************************
        * define property of continuous time states
        * (algebraic or differential states)
        *******************************************/
        case 7:
        {
            if (blk->nx != 0)
            {
                /* 40 - xprop */
                if (getDoubleArrayAsInt(t->getField(L"xprop"), blk->xprop, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }
            break;
        }

        /****************************
        * zero crossing computation
        ****************************/
        case 9:
        {
            /* 33 - g */
            if (getDoubleArray(t->getField(L"g"), blk->g, blk->ng) == false)
            {
                set_block_error(-1);
                goto sciblk4_exit_free_data;
            }

            if (get_phase_simulation() == 1)
            {
                /* 39 - mode */
                if (getDoubleArrayAsInt(t->getField(L"mode"), blk->mode, blk->nmode) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }
            break;
        }
        /**********************
        * Jacobian computation
        **********************/
        case 10:
        {
            if ((funtyp[kfun - 1] == 10004) || (funtyp[kfun - 1] == 10005))
            {
                /* 15 - res */
                if (getDoubleArray(t->getField(L"res"), blk->res, blk->nx) == false)
                {
                    set_block_error(-1);
                    goto sciblk4_exit_free_data;
                }
            }
            break;
        }
    }

    // store internal TList after the blk struct refresh
    // Note: on call_debug_scicos, the TList is always constructed/deleted
    if (work != nullptr && flag != 5 && blk->scsptr == nullptr)
    {
        t->IncreaseRef();
        *work = t;
    }

sciblk4_exit_free_data:
    pITout->killMe();
    if (pITout != pITin)
        pITin->killMe();
    return;
}
/*--------------------------------------------------------------------------*/
