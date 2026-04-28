/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Antoine ELIAS
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
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

#include <fstream>
#include <cwctype>

#include "webtools_gw.hxx"
#include "function.hxx"
#include "string.hxx"
#include "double.hxx"
#include "UTF8.hxx"
#include "json.hxx"

extern "C"
{
    #include "localization.h"
    #include "Scierror.h"
}

static const char fname[] = "toJSON";
types::Function::ReturnValue sci_toJSON(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    int indent = -1;
    std::wstring file = L"";
    bool allowNanAndInf = false;

    if (in.size() < 1 || in.size() > 3)
    {
        Scierror(999, _("%s: Wrong number of input arguments: %d to %d expected.\n"), fname, 1, 3);
        return types::Function::Error;
    }

    if(in.size() == 2)
    {
        //must be a scalar double or single string
        if(in[1]->isDouble() && in[1]->getAs<types::Double>()->isScalar())
        {
            indent = (int)in[1]->getAs<types::Double>()->get(0);
        }
        else if(in[1]->isString() && in[1]->getAs<types::String>()->isScalar())
        {
            file = in[1]->getAs<types::String>()->get(0);
        }
        else
        {
            Scierror(999, "%s: Wrong type for input argument #%d: double or string expected.\n", fname, 2);
            return types::Function::Error;
        }
    }
    else if(in.size() == 3)
    {
        // toJSON(var, file, indent)
        int indent_input = 2;
        int file_input = 1;
        if(in[1]->isDouble())
        {
            // toJSON(var, indent, file)
            indent_input = 1;
            file_input = 2;
        }

        //must be a scalar double
        if(in[indent_input]->isDouble() == false || in[indent_input]->getAs<types::Double>()->isScalar() == false)
        {
            Scierror(999, "%s: Wrong type for input argument #%d: A real scalar expected.\n", fname, indent_input + 1);
            return types::Function::Error;
        }

        indent = (int)in[indent_input]->getAs<types::Double>()->get(0);

        //must be a single string
        if(in[file_input]->isString() == false || in[file_input]->getAs<types::String>()->isScalar() == false)
        {
            Scierror(999, "%s: Wrong type for input argument #%d: single string expected.\n", fname, file_input + 1);
            return types::Function::Error;
        }

        file = in[file_input]->getAs<types::String>()->get(0);
    }

    for (const auto& o : opt)
    {
        std::wstring field = o.first;
        std::transform(field.begin(), field.end(), field.begin(), [](wchar_t c){ return std::towlower(c); });
        if (field == L"convertinfandnan")
        {
            if(o.second->isBool() == false || o.second->getAs<types::Bool>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar boolean expected.\n"), fname, "convertInfAndNaN");
                return types::Function::Error;
            }
            allowNanAndInf = !(bool)o.second->getAs<types::Bool>()->get(0);
        }
        else
        {
            Scierror(999, _("%s: Wrong optional argument: '%s' not allowed.\n"), fname, scilab::UTF8::toUTF8(o.first).c_str());
            return types::Function::Error;
        }
    }

    std::string err;
    std::string json_str = toJSON(in[0], err, indent, allowNanAndInf);
    if(err.empty() == false)
    {
        Scierror(999, _("%s: JSON convertion failed.\n%s\n"), fname, err.c_str());
        return types::Function::Error;
    }

    if (file.empty() == false)
    {
        std::string _filename = scilab::UTF8::toUTF8(file);
        std::ofstream outfile(_filename);
        outfile << json_str.c_str();
        outfile.close();
    }
    else
    {
        types::String* pOut = new types::String(json_str.c_str());
        out.push_back(pOut);
    }

    return types::Function::OK;
}
