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
#include "filemanager.hxx"
#include "double.hxx"
#include "function.hxx"
#include "scanf_utils.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
#include "mgetl.h"
#include "scanf_functions.h"
#include "StringConvert.h"
#include "mtell.h"
#include "mseek.h"
}

types::Function::ReturnValue sci_mfscanf(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    int iFile = -1; //default file : last opened file
    int size = (int)in.size();
    int iNiter = 1;
    wchar_t* wcsFormat = NULL;

    int args        = 0;
    int nrow        = 0;
    int ncol        = 0;
    int retval      = 0;
    int retval_s    = 0;
    int rowcount    = 0;
    rec_entry buf[MAXSCAN] = {0};
    entry *data = NULL;
    sfdir type[MAXSCAN] = {NONE};
    sfdir type_s[MAXSCAN] = {NONE};

    for (int i = 0; i < MAXSCAN; ++i)
    {
        memset(&buf[i], 0x00, sizeof(rec_entry));
        type[i] = NONE;
        type_s[i] = NONE;
    }

    if (size < 2 || size > 3)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "mfscanf", 2, 3);
        return types::Function::Error;
    }

    if (size == 3)
    {
        if (in[0]->isDouble() == false || in[0]->getAs<types::Double>()->isScalar() == false || in[0]->getAs<types::Double>()->isComplex())
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A Real expected.\n"), "mfscanf", 1);
            return types::Function::Error;
        }
        iNiter = static_cast<int>(in[0]->getAs<types::Double>()->get(0));
    }

    if (in[size - 2]->isDouble() == false || in[size - 2]->getAs<types::Double>()->isScalar() == false || in[size - 2]->getAs<types::Double>()->isComplex())
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A Real expected.\n"), "mfscanf", size - 1);
        return types::Function::Error;
    }

    if (in[size - 1]->isString() == false || in[size - 1]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A String expected.\n"), "mfscanf", size);
        return types::Function::Error;
    }

    iFile = static_cast<int>(in[size - 2]->getAs<types::Double>()->get(0));
    switch (iFile)
    {
        case 0: // stderr
        case 6: // stdout
            Scierror(999, _("%s: Wrong file descriptor: %d.\n"), "mfscanf", iFile);
            return types::Function::Error;
        default :
            break;
    }

    wcsFormat = in[size - 1]->getAs<types::String>()->get(0);
    StringConvertW(wcsFormat);

    types::File* pFile = FileManager::getFile(iFile);
    if (pFile == NULL)
    {
        Scierror(999, _("%s: Cannot read file %d.\n"), "mfscanf", iFile);
        return types::Function::Error;
    }

    // file opened with fortran open function
    if (pFile->getFileType() == 1)
    {
        Scierror(999, _("%s: Wrong file descriptor: %d.\n"), "mfscanf", iFile);
        return types::Function::Error;
    }

    FILE* fDesc = pFile->getFiledesc();
    nrow = iNiter;
    while ((iNiter == -1) || (rowcount < iNiter))
    {
        // get current position in file
        int iCurrentPos = static_cast<int>(mtell(iFile));

        // get data
        int err = do_xxscanf(L"mfscanf", fDesc, wcsFormat, &args, NULL, &retval, buf, type);
        if (err == DO_XXPRINTF_MISMATCH)
        {
            break;
        }
        if (err < 0)
        {
            return types::Function::Error;
        }

        err = Store_Scan(&nrow, &ncol, type_s, type, &retval, &retval_s, buf, &data, rowcount, args);
        if (err == DO_XXPRINTF_MEM_LACK)
        {
            Free_Scan(rowcount, ncol, type_s, &data);
            Scierror(999, _("%s: No more memory.\n"), "mfscanf");
            return types::Function::Error;
        }
        else if (err == DO_XXPRINTF_MISMATCH)
        {
            // go back to the last position
            // only if this line is not empty
            if (args)
            {
                mseek(iFile, iCurrentPos, SEEK_SET);
            }

            for (int i = 0; i < MAXSCAN; ++i)
            {
                if (type[i] == NONE)
                {
                    break;
                }

                if (type[i] == SF_S || type[i] == SF_C)
                {
                    FREE(buf[i].c);
                    buf[i].c = NULL;
                }
            }
            break;
        }

        rowcount++;

        // EOF reached
        if (retval == -1)
        {
            FREE(buf->c);
            break;
        }
    }

    std::vector<types::InternalType*> vIT;
    unsigned int uiFormatUsed = scanfToInternalTypes(data, type_s, rowcount, ncol, vIT);
    Free_Scan(rowcount, ncol, type_s, &data);
    InternalTypesToOutput(vIT, _iRetCount, retval_s, uiFormatUsed, out);

    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/

