/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2006 - INRIA - Allan CORNET
* Copyright (C) 2009 - DIGITEO - Allan CORNET
* Copyright (C) 2010 - DIGITEO - Antoine ELIAS
* Copyright (C) 2011 - DIGITEO - Cedric DELAMARRE
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
#include "fileio_gw.hxx"
#include "string.hxx"
#include "mlist.hxx"
#include "function.hxx"
#include "double.hxx"
#include "scanf_utils.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "scanf_functions.h"
}

types::Function::ReturnValue sci_msscanf(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    int size                    = (int)in.size();
    int iNiter                  = 1;
    wchar_t* wcsFormat          = NULL;
    types::String* pStrRead     = NULL;

    int args        = 0;
    int nrow        = 0;
    int ncol        = 0;
    int retval      = 0;
    int retval_s    = 0;
    int rowcount    = -1;
    rec_entry buf[MAXSCAN];
    entry *data = NULL;
    sfdir type[MAXSCAN]   = {NONE};
    sfdir type_s[MAXSCAN] = {NONE};

    if (size < 2 || size > 3)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "msscanf", 2, 3);
        return types::Function::Error;
    }

    if (size == 3)
    {
        if (in[0]->isDouble() == false || in[0]->getAs<types::Double>()->isScalar() == false || in[0]->getAs<types::Double>()->isComplex())
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A Real expected.\n"), "msscanf", 1);
            return types::Function::Error;
        }
        iNiter = static_cast<int>(in[0]->getAs<types::Double>()->get(0));
    }

    if (in[size - 2]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A Strings expected.\n"), "msscanf", size - 1);
        return types::Function::Error;
    }

    if (in[size - 1]->isString() == false || in[size - 1]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A String expected.\n"), "msscanf", size);
        return types::Function::Error;
    }

    pStrRead  = in[size - 2]->getAs<types::String>();
    if (iNiter == -1)
    {
        iNiter = pStrRead->getRows();
    }
    else if (iNiter > pStrRead->getRows())
    {
        Scierror(999, _("%s: An error occurred: Not enough entries.\n"), "msscanf");
        return types::Function::Error;
    }

    wcsFormat = in[size - 1]->getAs<types::String>()->get(0);
    nrow = iNiter;
    while (++rowcount < iNiter)
    {
        if ((iNiter >= 0) && (rowcount >= iNiter))
        {
            break;
        }
        int err = do_xxscanf(L"sscanf", (FILE *)0, wcsFormat, &args, pStrRead->get(rowcount), &retval, buf, type);
        if (err == DO_XXPRINTF_MISMATCH)
        {
            break;
        }
        if (err < 0)
        {
            return types::Function::Error;
        }
        err = Store_Scan(&nrow, &ncol, type_s, type, &retval, &retval_s, buf, &data, rowcount, args);
        if (err < 0)
        {
            switch (err)
            {
                case DO_XXPRINTF_MISMATCH:
                    Free_Scan(rowcount, ncol, type_s, &data);
                    Scierror(999, _("%s: Data mismatch.\n"), "msscanf");
                    return types::Function::Error;

                case DO_XXPRINTF_MEM_LACK:
                    Free_Scan(rowcount, ncol, type_s, &data);
                    Scierror(999, _("%s: No more memory.\n"), "msscanf");
                    return types::Function::Error;
            }
        }
    }

    std::vector<types::InternalType*> vIT;
    unsigned int uiFormatUsed = scanfToInternalTypes(data, type_s, rowcount, ncol, vIT);
    Free_Scan(rowcount, ncol, type_s, &data);
    InternalTypesToOutput(vIT, _iRetCount, retval, uiFormatUsed, out);

    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/
