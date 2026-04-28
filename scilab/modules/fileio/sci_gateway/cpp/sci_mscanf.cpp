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
#include "scilabWrite.hxx"
#include "function.hxx"
#include "double.hxx"
#include "string.hxx"
#include "configvariable.hxx"
#include "threadmanagement.hxx"
#include "scanf_utils.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
#include "prompt.h"
#include "scanf_functions.h"
#include "sci_malloc.h"
#include "scilabRead.h"
}

types::Function::ReturnValue sci_mscanf(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    int size                    = (int)in.size();
    int iNiter                  = 1;
    wchar_t* wcsFormat          = NULL;
    wchar_t* wcsRead            = NULL;

    int args        = 0;
    int nrow        = 0;
    int ncol        = 0;
    int retval      = 0;
    int retval_s    = 0;
    int rowcount    = -1;
    rec_entry buf[MAXSCAN];
    entry *data = NULL;
    sfdir type[MAXSCAN] = {NONE};
    sfdir type_s[MAXSCAN] = {NONE};

    if (size < 1 || size > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "mscanf", 1, 2);
        return types::Function::Error;
    }

    if (size == 2)
    {
        if (in[0]->isDouble() == false || in[0]->getAs<types::Double>()->isScalar() == false || in[0]->getAs<types::Double>()->isComplex())
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A Real expected.\n"), "mscanf", 1);
            return types::Function::Error;
        }
        iNiter = static_cast<int>(in[0]->getAs<types::Double>()->get(0));
        if (iNiter < 0)
        {
            iNiter = 1;
        }
    }

    if (in[size - 1]->isString() == false || in[size - 1]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A String expected.\n"), "mscanf", size);
        return types::Function::Error;
    }

    // dont print a new line before getting user console input
    bool bPrintCompact = ConfigVariable::isPrintCompact();
    ConfigVariable::setPrintCompact(true);

    wcsFormat = in[size - 1]->getAs<types::String>()->get(0);
    nrow = iNiter;
    while (++rowcount < iNiter)
    {
        if ((iNiter >= 0) && (rowcount >= iNiter))
        {
            break;
        }

        // get data
        // The console thread must not parse the next console input.
        ConfigVariable::setScilabCommand(0);

        // remove the prompt using invisible charactere on GUI.
        // this prompt will be used once, then reset to the default prompt.
        if (ConfigVariable::getPauseLevel() == 0)
        {
            // Unicode - Zero Width Space
            SetTemporaryPrompt("\xE2\x80\x8B");
        }

        // Get the console input filled by the console thread.
        char* pcConsoleReadStr = ConfigVariable::getConsoleReadStr();
        ThreadManagement::SendConsoleExecDoneSignal();
        while (pcConsoleReadStr == NULL)
        {
            pcConsoleReadStr = ConfigVariable::getConsoleReadStr();
        }

        wcsRead = to_wide_string(pcConsoleReadStr);
        FREE(pcConsoleReadStr);
        int err = do_xxscanf(L"sscanf", (FILE *)0, wcsFormat, &args, wcsRead, &retval, buf, type);
        FREE(wcsRead);
        if (err < 0)
        {
            ConfigVariable::setPrintCompact(bPrintCompact);
            return types::Function::Error;
        }
        err = Store_Scan(&nrow, &ncol, type_s, type, &retval, &retval_s, buf, &data, rowcount, args);
        if (err < 0)
        {
            switch (err)
            {
                case DO_XXPRINTF_MISMATCH:
                    Free_Scan(rowcount, ncol, type_s, &data);
                    ConfigVariable::setPrintCompact(bPrintCompact);
                    Scierror(999, _("%s: Data mismatch.\n"), "mscanf");
                    return types::Function::Error;

                case DO_XXPRINTF_MEM_LACK:
                    Free_Scan(rowcount, ncol, type_s, &data);
                    ConfigVariable::setPrintCompact(bPrintCompact);
                    Scierror(999, _("%s: No more memory.\n"), "mscanf");
                    return types::Function::Error;
            }
        }
    }

    ConfigVariable::setPrintCompact(bPrintCompact);

    std::vector<types::InternalType*> vIT;
    unsigned int uiFormatUsed = scanfToInternalTypes(data, type_s, rowcount, ncol, vIT);
    Free_Scan(rowcount, ncol, type_s, &data);
    InternalTypesToOutput(vIT, _iRetCount, retval, uiFormatUsed, out);

    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/
