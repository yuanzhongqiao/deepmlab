/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2010-2010 - DIGITEO - ELIAS Antoine
 *  Copyright (C) 2014 - Scilab Enterprises - Cedric Delamarre
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

#include "output_stream_gw.hxx"
#include "function.hxx"
#include "scilabWrite.hxx"
#include "types_tools.hxx"
#include "visitor_common.hxx"
#include "configvariable.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
}

types::Function::ReturnValue sci_disp(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    if (in.empty())
    {
        Scierror(999, _("%s: Wrong number of input arguments: At least %d expected.\n"), "disp", 1);
        return types::Function::Error;
    }

    for (auto it : in)
    {
        std::wostringstream ostr;
 
        if (ConfigVariable::isPrintCompact() == false)
        {
            ostr << std::endl;
        }
        
        //show more information that only data
        std::vector<std::wstring> whitelist = {L"handle", L"struct", L"sparse", L"boolean sparse", L"XMLDoc", L"_EObj", L"lss", L"zpk"};

        std::wstring type = it->getTypeStr();
        if (std::find(whitelist.begin(), whitelist.end(), type) != whitelist.end())
        {
            std::wstring wStrOutline = printTypeDimsInfo(it);
            if (wStrOutline != L"")
            {
                ostr << L"  " << wStrOutline.c_str() << std::endl;
                if (ConfigVariable::isPrintCompact() == false)
                {
                    ostr << std::endl;
                }
            }
        }

        scilabForcedWriteW(ostr.str().c_str());
        if (VariableToString(it, SPACES_LIST) == types::Function::Error)
        {
            return types::Function::Error;
        }
    }

    return types::Function::OK;
}
