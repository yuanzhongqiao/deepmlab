/*  Scicos
*
*  Copyright (C) 2015 - Scilab Enterprises - Antoine ELIAS
*  Copyright (C) DIGITEO - 2009 - Allan CORNET
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
#include "double.hxx"
#include "int.hxx"
#include "internal.hxx"
#include "list.hxx"
#include "string.hxx"
#include "tlist.hxx"

extern "C"
{
#include "import.h"
}

#include "createblklist.hxx"
/*--------------------------------------------------------------------------*/
static types::InternalType* allocsci(void* data, const int rows, const int cols, const int type)
{
    switch (type)
    {
        case SCSREAL_N:
        {
            types::Double* var = new types::Double(rows, cols);
            return var;
        }
        case SCSCOMPLEX_N:
        {
            types::Double* var = new types::Double(rows, cols, true);
            return var;
        }
        case SCSINT8_N:
        {
            types::Int8* var = new types::Int8(rows, cols);
            return var;
        }
        case SCSINT16_N:
        {
            types::Int16* var = new types::Int16(rows, cols);
            return var;
        }
        case SCSINT32_N:
        {
            types::Int32* var = new types::Int32(rows, cols);
            return var;
        }
        case SCSUINT8_N:
        {
            types::UInt8* var = new types::UInt8(rows, cols);
            return var;
        }
        case SCSUINT16_N:
        {
            types::UInt16* var = new types::UInt16(rows, cols);
            return var;
        }
        case SCSUINT32_N:
        {
            types::UInt32* var = new types::UInt32(rows, cols);
            return var;
        }
        default: // case SCSUNKNOW_N: pass the data by pointers from Scilab, don't allocate !
        {
            return nullptr;
        }
    }
};
/*--------------------------------------------------------------------------*/
template<typename scilabType, types::InternalType::ScilabType scilabTypename, typename cType>
types::InternalType* vartosci(types::InternalType* pIT, cType* data, const int rows, const int cols)
{
    scilabType* var;
    // empty matrix specific case
    if (rows == 0 || cols == 0)
    {
        if (pIT->isDouble() && pIT->getAs<types::Double>()->getSize() == 0)
            return pIT;
        return types::Double::Empty();
    }
    // regular case
    if (pIT->getType() != scilabTypename)
    {
        var = new scilabType(rows, cols);
    }
    else
    {
        var = pIT->getAs<scilabType>();
    }
    if ((rows * cols) != var->getSize())
    {
        var = (scilabType*) var->resize(rows, cols);
    }
    return var->set((cType*) data);
};
/*--------------------------------------------------------------------------*/
static types::InternalType* vartosci(types::InternalType* pIT, void* data, const int rows, const int cols, const int type)
{
    int size = rows * cols;
    switch (type)
    {
        case SCSREAL_N:
        {
            return vartosci<types::Double, types::InternalType::ScilabDouble>(pIT, (double*) data, rows, cols);
        }
        case SCSCOMPLEX_N:
        {
            types::Double* var = (types::Double*) vartosci<types::Double, types::InternalType::ScilabDouble>(pIT, (double*) data, rows, cols);
            return var->setImg(((double*) data) + size);
        }
        case SCSINT8_N:
        {
            return vartosci<types::Int8, types::InternalType::ScilabInt8>(pIT, (char*) data, rows, cols);
        }
        case SCSINT16_N:
        {
            return vartosci<types::Int16, types::InternalType::ScilabInt16>(pIT, (short*) data, rows, cols);
        }
        case SCSINT32_N:
        {
            return vartosci<types::Int32, types::InternalType::ScilabInt32>(pIT, (int*) data, rows, cols);
        }
        case SCSUINT8_N:
        {
            return vartosci<types::UInt8, types::InternalType::ScilabUInt8>(pIT, (unsigned char*) data, rows, cols);
        }
        case SCSUINT16_N:
        {
            return vartosci<types::UInt16, types::InternalType::ScilabUInt16>(pIT, (unsigned short*) data, rows, cols);
        }
        case SCSUINT32_N:
        {
            return vartosci<types::UInt32, types::InternalType::ScilabUInt32>(pIT, (unsigned int*) data, rows, cols);
        }
        default: // case SCSUNKNOW_N: pass the data by pointers from Scilab
        {
            auto pIT = (types::InternalType*) data;
            return pIT;
        }
    }
}
/*--------------------------------------------------------------------------*/
static types::InternalType* vartosci(void* data, const int rows, const int cols, const int type)
{
    return vartosci(allocsci(data, rows, cols, type), data, rows, cols, type);
}
/*--------------------------------------------------------------------------*/
types::List* createblklist(const scicos_block* const Blocks, const int flag_imp, const int /*funtyp*/)
{
    const int fieldCount = 41;
    int size = 0;

    /* set string of first element of scilab Blocks tlist */
    static const char* str_blklst[] = {"scicos_block", "nevprt", "funpt", "type",
                                       "scsptr", "nz", "z", "noz",
                                       "ozsz", "oztyp", "oz", "nx",
                                       "x", "xd", "res", "nin",
                                       "insz", "inptr", "nout", "outsz",
                                       "outptr", "nevout", "evout", "nrpar",
                                       "rpar", "nipar", "ipar", "nopar",
                                       "oparsz", "opartyp", "opar", "ng",
                                       "g", "ztyp", "jroot", "label",
                                       "work", "nmode", "mode", "xprop",
                                       "uid"
                                      };

    int* xptr = nullptr; /* to retrieve xptr by import and zcptr of scicos_blocks */
    double* x = nullptr; /* ptr for x, xd and g for scicos_blocks                 */
    int* zcptr = nullptr;
    double* g = nullptr;

    if (flag_imp >= 0)
    {
        int nv, mv; /* length of data                             */
        //int ng;             /* to store number of zero cross              */
        void* ptr; /* ptr for data comming from import structure */

        /* retrieve ng by import structure */
        char Ng[] = "ng";
        getscicosvarsfromimport(Ng, &ptr, &nv, &mv);
        //ng = ((int*)ptr)[0];

        /*retrieve xptr by import structure*/
        char Xptr[] = "xptr";
        getscicosvarsfromimport(Xptr, &ptr, &nv, &mv);
        xptr = (int*)ptr;

        /*retrieve zcptr by import structure*/
        char Zcptr[] = "zcptr";
        getscicosvarsfromimport(Zcptr, &ptr, &nv, &mv);
        zcptr = (int*)ptr;

        /*retrieve x and xd by import structure*/
        char X[] = "x";
        getscicosvarsfromimport(X, &ptr, &nv, &mv);
        x = (double*)ptr;

        /*retrieve g by import structure*/
        char G[] = "g";
        getscicosvarsfromimport(G, &ptr, &nv, &mv);
        g = (double*)ptr;
    }

    types::TList* m = new types::TList();

    /* 1 - scicos_block */
    types::String* s = new types::String(1, fieldCount);
    for (int i = 0; i < fieldCount; ++i)
    {
        s->set(i, str_blklst[i]);
    }

    m->append(s);

    /* 2 - nevprt */
    m->append(new types::Double(static_cast<double>(Blocks->nevprt)));

    /* 3 - funpt */
    //cast function ptr to double*
    if (sizeof(voidg) >= sizeof(double))
    {
        // store N double values as the function pointer value
        size = sizeof(voidg) / sizeof(double);
    }
    else
    {
        // push at least one double
        size = 1;
    }

    types::Double* funpt = new types::Double(size, 1);
    double* d = funpt->get();
    for (int i = 0; i < size; ++i)
    {
        d[i] = (double)((long long)Blocks->funpt);
    }

    m->append(funpt);

    /* 4 - type */
    m->append(new types::Double(static_cast<double>(Blocks->type)));

    /* 5 - scsptr is used to store will store this data structure - set it to an empty double */
    m->append(types::Double::Empty());

    /* 6 - nz */
    m->append(new types::Double(static_cast<double>(Blocks->nz)));

    /* 7 - z */
    m->append(vartosci(Blocks->z, Blocks->nz, 1, SCSREAL_N));

    /* 8 - noz */
    m->append(new types::Double(static_cast<double>(Blocks->noz)));

    /* 9 - ozsz */
    types::Double* ozsz = new types::Double(Blocks->noz, 1);
    d = ozsz->get();
    for (int i = 0; i < Blocks->noz; ++i)
    {
        d[i] = static_cast<double>(Blocks->ozsz[i]);
    }

    m->append(ozsz);

    /* 10 - oztyp */
    types::Double* oztyp = new types::Double(Blocks->noz, 1);
    d = oztyp->get();
    for (int i = 0; i < Blocks->noz; ++i)
    {
        d[i] = static_cast<double>(Blocks->oztyp[i]);
    }

    m->append(oztyp);

    /* 11 - ozptr */
    types::List* ozptr;

    // special case, some values are embeded into a Scilab list ; unwrap them
    if (Blocks->noz == 1 && Blocks->oztyp[0] == SCSUNKNOW_N)
    {
        ozptr = (types::List*) vartosci(Blocks->ozptr[0], Blocks->ozsz[0], Blocks->ozsz[1], Blocks->oztyp[0]);
    }
    else
    {
        ozptr = new types::List();
        for (int k = 0; k < Blocks->noz; k++)
        {
            const int rows = Blocks->ozsz[k];               /* retrieve number of rows */
            const int cols = Blocks->ozsz[Blocks->noz + k]; /* retrieve number of cols */
            const int type = Blocks->oztyp[k];              /* retrieve type */

            ozptr->append(vartosci(Blocks->ozptr[k], rows, cols, type));
        }
    }

    m->append(ozptr);

    /* 12 - nx */
    m->append(new types::Double(static_cast<double>(Blocks->nx)));

    /* 13 - x */
    if (flag_imp >= 0)
    {
        m->append(vartosci(&x[xptr[flag_imp] - 1], Blocks->nx, 1, SCSREAL_N));
    }
    else
    {
        m->append(vartosci(Blocks->x, Blocks->nx, 1, SCSREAL_N));
    }

    /* 14 - xd */
    // xd is not available yet
    m->append(types::Double::Empty());

    /* 15 - res */
    // res is not available yet
    m->append(types::Double::Empty());

    /* 16 - nin */
    m->append(new types::Double(static_cast<double>(Blocks->nin)));

    /* 17 - insz */
    types::Double* insz = new types::Double(3 * Blocks->nin, 1);
    d = insz->get();
    for (int i = 0; i < 3 * Blocks->nin; ++i)
    {
        d[i] = static_cast<double>(Blocks->insz[i]);
    }

    m->append(insz);

    /* 18 - inptr */
    types::List* inptr = new types::List();
    for (int k = 0; k < Blocks->nin; k++)
    {
        const int rows = Blocks->insz[k];                   /* retrieve number of rows */
        const int cols = Blocks->insz[Blocks->nin + k];     /* retrieve number of cols */
        const int type = Blocks->insz[2 * Blocks->nin + k]; /* retrieve type */
        inptr->append(vartosci(Blocks->inptr[k], rows, cols, type));
    }

    m->append(inptr);

    /* 19 - nout */
    m->append(new types::Double(static_cast<double>(Blocks->nout)));

    /* 20 - outsz */
    types::Double* outsz = new types::Double(3 * Blocks->nout, 1);
    d = outsz->get();
    for (int i = 0; i < 3 * Blocks->nout; ++i)
    {
        d[i] = static_cast<double>(Blocks->outsz[i]);
    }

    m->append(outsz);
    /* 21 - outptr */
    types::List* outptr = new types::List();
    for (int k = 0; k < Blocks->nout; k++)
    {
        const int rows = Blocks->outsz[k];                    /* retrieve number of rows */
        const int cols = Blocks->outsz[Blocks->nout + k];     /* retrieve number of cols */
        const int type = Blocks->outsz[2 * Blocks->nout + k]; /* retrieve type */
        outptr->append(vartosci(Blocks->outptr[k], rows, cols, type));
    }

    m->append(outptr);

    /* 22 - nevout */
    m->append(new types::Double(static_cast<double>(Blocks->nevout)));

    /* 23 - evout */
    m->append(vartosci(Blocks->evout, Blocks->nevout, 1, SCSREAL_N));

    /* 24 - nrpar */
    m->append(new types::Double(static_cast<double>(Blocks->nrpar)));

    /* 25 - rpar */
    m->append(vartosci(Blocks->rpar, Blocks->nrpar, 1, SCSREAL_N));

    /* 26 - nipar */
    m->append(new types::Double(static_cast<double>(Blocks->nipar)));

    /* 27 - ipar */
    types::Double* ipar = new types::Double(Blocks->nipar, 1);
    d = ipar->get();
    for (int i = 0; i < Blocks->nipar; ++i)
    {
        d[i] = static_cast<double>(Blocks->ipar[i]);
    }

    m->append(ipar);

    /* 28 - nopar */
    m->append(new types::Double(static_cast<double>(Blocks->nopar)));

    /* 29 - oparsz */
    types::Double* oparsz = new types::Double(Blocks->nopar, 1);
    d = oparsz->get();
    for (int i = 0; i < Blocks->nopar; ++i)
    {
        d[i] = static_cast<double>(Blocks->oparsz[i]);
    }

    m->append(oparsz);

    /* 30 - opartyp */
    types::Double* opartyp = new types::Double(Blocks->nopar, 1);
    d = opartyp->get();
    for (int i = 0; i < Blocks->nopar; ++i)
    {
        d[i] = static_cast<double>(Blocks->opartyp[i]);
    }

    m->append(opartyp);

    /* 31 - opar */
    types::List* opar;

    // special case, some values are embeded into a Scilab list ; unwrap them
    if (Blocks->nopar == 1 && Blocks->opartyp[0] == SCSUNKNOW_N)
    {
        opar = (types::List*) vartosci(Blocks->oparptr[0], Blocks->oparsz[0], Blocks->oparsz[1], Blocks->opartyp[0]);
    }
    else
    {
        opar = new types::List();
        for (int k = 0; k < Blocks->nopar; k++)
        {
            const int rows = Blocks->oparsz[k];               /* retrieve number of rows */
            const int cols = Blocks->oparsz[Blocks->nopar + k]; /* retrieve number of cols */
            const int type = Blocks->opartyp[k];              /* retrieve type */

            opar->append(vartosci(Blocks->oparptr[k], rows, cols, type));
        }
    }

    m->append(opar);

    /* 32 - ng */
    m->append(new types::Double(static_cast<double>(Blocks->ng)));

    /* 33 - g */
    if (flag_imp >= 0)
    {
        m->append(vartosci(&g[zcptr[flag_imp] - 1], Blocks->ng, 1, SCSREAL_N));
    }
    else
    {
        m->append(vartosci(Blocks->g, Blocks->ng, 1, SCSREAL_N));
    }

    /* 34 - ztyp */
    m->append(new types::Double(static_cast<double>(Blocks->ztyp)));

    /* 35 - jroot */
    types::Double* jroot = new types::Double(Blocks->ng, 1);
    d = jroot->get();
    for (int i = 0; i < Blocks->ng; ++i)
    {
        d[i] = static_cast<double>(Blocks->jroot[i]);
    }

    m->append(jroot);

    /* 36 - label */
    m->append(new types::String(Blocks->label));

    /* 37 - work*/
    //store address as double
    m->append(new types::Double((double)((long long)Blocks->work)));

    /* 38 - nmode*/
    m->append(new types::Double(static_cast<double>(Blocks->nmode)));

    /* 39 - mode */
    types::Double* mode = new types::Double(Blocks->nmode, 1);
    d = mode->get();
    for (int i = 0; i < Blocks->nmode; ++i)
    {
        d[i] = static_cast<double>(Blocks->mode[i]);
    }

    m->append(mode);

    /* 40 - xprop */
    types::Double* xprop = new types::Double(Blocks->nx, 1);
    d = xprop->get();
    for (int i = 0; i < Blocks->nx; ++i)
    {
        d[i] = static_cast<double>(Blocks->xprop[i]);
    }

    m->append(xprop);

    /* 41 - uid */
    if (Blocks->uid)
    {
        m->append(new types::String(Blocks->uid));
    }
    else
    {
        m->append(new types::String(L""));
    }

    return m;
}
/*--------------------------------------------------------------------------*/
types::List* refreshblklist(types::List* m, const scicos_block* const Blocks, const int flag_imp, const int /*funtyp*/, const int flag)
{
    // ensure that `m` contains the needed elements; if not discard the sync
    if (m->getSize() < 41)
    {
        return m;
    }

    int* xptr = nullptr; /* to retrieve xptr by import and zcptr of scicos_blocks */
    double* x = nullptr; /* ptr for x, xd and g for scicos_blocks                 */
    double* xd = nullptr;
    int* zcptr = nullptr;
    double* g = nullptr;

    if (flag_imp >= 0)
    {
        int nv, mv; /* length of data                             */
        int nblk;   /* to store number of blocks                  */
        //int ng;             /* to store number of zero cross              */
        void* ptr; /* ptr for data comming from import structure */

        /*retrieve nblk by import structure*/
        char Nblk[] = "nblk";
        getscicosvarsfromimport(Nblk, &ptr, &nv, &mv);
        nblk = ((int*)ptr)[0];

        /* retrieve ng by import structure */
        char Ng[] = "ng";
        getscicosvarsfromimport(Ng, &ptr, &nv, &mv);
        //ng = ((int*)ptr)[0];

        /*retrieve xptr by import structure*/
        char Xptr[] = "xptr";
        getscicosvarsfromimport(Xptr, &ptr, &nv, &mv);
        xptr = (int*)ptr;

        /*retrieve zcptr by import structure*/
        char Zcptr[] = "zcptr";
        getscicosvarsfromimport(Zcptr, &ptr, &nv, &mv);
        zcptr = (int*)ptr;

        /*retrieve x and xd by import structure*/
        char X[] = "x";
        getscicosvarsfromimport(X, &ptr, &nv, &mv);
        x = (double*)ptr;
        xd = &x[xptr[nblk] - 1];

        /*retrieve g by import structure*/
        char G[] = "g";
        getscicosvarsfromimport(G, &ptr, &nv, &mv);
        g = (double*)ptr;
    }

    /* 7 - z */
    m->set(6, vartosci(m->get(6), Blocks->z, Blocks->nz, 1, SCSREAL_N));

    /* 11 - ozptr */
    if (m->get(10)->isList())
    {
        types::List* ozptr = m->get(10)->getAs<types::List>();

        // special case, some values are embeded into a Scilab list ; wrap them
        if (Blocks->noz == 1 && Blocks->oztyp[0] == SCSUNKNOW_N)
        {
            ozptr = (types::List*) vartosci(ozptr, Blocks->ozptr[0], Blocks->ozsz[0], Blocks->ozsz[1], Blocks->oztyp[0]);
            m->set(10, ozptr);
        }
        else
        {
            for (int k = 0; k < Blocks->noz; k++)
            {
                const int rows = Blocks->ozsz[k];               /* retrieve number of rows */
                const int cols = Blocks->ozsz[Blocks->noz + k]; /* retrieve number of cols */
                const int type = Blocks->oztyp[k];              /* retrieve type */
                ozptr->set(k, vartosci(ozptr->get(k), Blocks->ozptr[k], rows, cols, type));
            }
            m->set(10, ozptr);
        }
    }

    /* 13 - x */
    if (flag_imp >= 0)
    {
        m->set(12, vartosci(m->get(12), &x[xptr[flag_imp] - 1], Blocks->nx, 1, SCSREAL_N));
    }
    else
    {
        m->set(12, vartosci(m->get(12), Blocks->x, Blocks->nx, 1, SCSREAL_N));
    }

    /* 14 - xd */
    // xd is only available on continuous state update, refresh it only in that case.
    if (flag == 0)
    {
        if (flag_imp >= 0)
        {
            m->set(13, vartosci(m->get(13), &xd[xptr[flag_imp] - 1], Blocks->nx, 1, SCSREAL_N));
        }
        else
        {
            m->set(13, vartosci(m->get(13), Blocks->xd, Blocks->nx, 1, SCSREAL_N));
        }
    }

    /* 15 - res */
    // res is only available on continuous state update, refresh it only in that case.
    if (flag == 0)
    {
        m->set(14, vartosci(m->get(14), Blocks->res, Blocks->nx, 1, SCSREAL_N));
    }

    /* 18 - inptr */
    if (m->get(17)->isList())
    {
        types::List* inptr = m->get(17)->getAs<types::List>();
        for (int k = 0; k < Blocks->nin; k++)
        {
            const int rows = Blocks->insz[k];                   /* retrieve number of rows */
            const int cols = Blocks->insz[Blocks->nin + k];     /* retrieve number of cols */
            const int type = Blocks->insz[2 * Blocks->nin + k]; /* retrieve type */
            inptr->set(k, vartosci(inptr->get(k), Blocks->inptr[k], rows, cols, type));
        }
        m->set(17, inptr);
    }

    /* 21 - outptr */
    if (m->get(20)->isList())
    {
        types::List* outptr = m->get(20)->getAs<types::List>();
        for (int k = 0; k < Blocks->nout; k++)
        {
            const int rows = Blocks->outsz[k];                    /* retrieve number of rows */
            const int cols = Blocks->outsz[Blocks->nout + k];     /* retrieve number of cols */
            const int type = Blocks->outsz[2 * Blocks->nout + k]; /* retrieve type */
            outptr->set(k, vartosci(outptr->get(k), Blocks->outptr[k], rows, cols, type));
        }
        m->set(20, outptr);
    }

    /* 23 - evout */
    m->set(22, vartosci(m->get(22), Blocks->evout, Blocks->nevout, 1, SCSREAL_N));

    /* 33 - g */
    if (flag_imp >= 0)
    {
        m->set(32, vartosci(m->get(32), &g[zcptr[flag_imp] - 1], Blocks->ng, 1, SCSREAL_N));
    }
    else
    {
        m->set(32, vartosci(m->get(32), Blocks->g, Blocks->ng, 1, SCSREAL_N));
    }

    /* 35 - jroot */
    m->set(34, vartosci(m->get(34), Blocks->jroot, Blocks->ng, 1, SCSREAL_N));

    /* 39 - mode */
    m->set(38, vartosci(m->get(38), Blocks->mode, Blocks->nmode, 1, SCSREAL_N));

    /* 40 - xprop */
    if (flag == 4 || flag == 7)
    {
        m->set(39, vartosci(m->get(39), Blocks->xprop, Blocks->nx, 1, SCSREAL_N));
    }

    return m;
}
/*--------------------------------------------------------------------------*/
