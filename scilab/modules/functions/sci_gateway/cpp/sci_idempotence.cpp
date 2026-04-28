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

#include <cstdio>
#include "context.hxx"
#include "functions_gw.hxx"
#include "string.hxx"
#include "parser.hxx"
#include "threadmanagement.hxx"
#include "printvisitor.hxx"

extern "C"
{
#include "Scierror.h"
#include "sciprint.h"
#include "localization.h"
#include "expandPathVariable.h"
}

/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_idempotence(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 1)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d expected.\n"), "idempotence", 1);
        return types::Function::Error;
    }

    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A String expected.\n"), "whereis", 1);
        return types::Function::Error;
    }

    types::String* pS = in[0]->getAs<types::String>();
    Parser parser;
    int iErrCount = 0;
    int iOkCount = 0;

    for (int i = 0; i < pS->getSize(); ++i)
    {
        // parse 1
        ThreadManagement::LockParser();
        wchar_t* path = expandPathVariableW(pS->get()[i]);
        parser.parseFile(path, L"idempotence");
        FREE(path);
        if (parser.getExitStatus() != Parser::Succeded)
        {
            sciprint("Unable to parse %ls.\n", pS->get()[i]);
            //delete parser.getTree();
            ThreadManagement::UnlockParser();
            iErrCount++;
            continue;
        }

        std::wostringstream ostr1;
        //--pretty-print 1
        ast::PrintVisitor print1(ostr1);
        parser.getTree()->accept(print1);
        delete parser.getTree();
        ThreadManagement::UnlockParser();

        //parse 2
        ThreadManagement::LockParser();
        parser.parse(ostr1.str().c_str());
        if (parser.getExitStatus() != Parser::Succeded)
        {
            sciprint("Unable to parse the second time %ls.\n", pS->get()[i]);
            //delete parser.getTree();
            ThreadManagement::UnlockParser();
            iErrCount++;
            continue;
        }

        //--pretty-print 2
        std::wostringstream ostr2;
        ast::PrintVisitor print2(ostr2);
        parser.getTree()->accept(print2);
        delete parser.getTree();
        ThreadManagement::UnlockParser();

        if (ostr1.str() != ostr2.str())
        {
            sciprint("Idempotence check failed on file %ls.\n", pS->get()[i]);
            sciprint("step 1: \n%ls\n", ostr1.str().c_str());
            sciprint("step 2: \n%ls\n", ostr2.str().c_str());
            iErrCount++;
            continue;
        }
        iOkCount++;
    }

    sciprint("Ok : %d || Failed : %d\n", iOkCount, iErrCount);
    if (iErrCount != 0) 
    {
        Scierror(999, _("%s: Failed on %d tests.\n"), "idempotence", iErrCount);
        return types::Function::Error;
    }

    return types::Function::OK;
}