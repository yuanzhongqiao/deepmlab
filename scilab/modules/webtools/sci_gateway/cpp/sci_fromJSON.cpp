/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Antoine ELIAS
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
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
#include "webtools_gw.hxx"
#include "function.hxx"
#include "json.hxx"
#include "string.hxx"
#include "UTF8.hxx"

extern "C"
{
    #include "localization.h"
    #include "Scierror.h"
}

static const char fname[] = "fromJSON";
types::Function::ReturnValue sci_fromJSON(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(999, _("%s: Wrong number of input arguments: %d to %d expected.\n"), fname, 1, 2);
        return types::Function::Error;
    }

    if(in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: string expected.\n"), fname, 1);
        return types::Function::Error;
    }

    types::String* pStr = in[0]->getAs<types::String>();
    std::string json = "";
    for(int i = 0; i < pStr->getSize(); i++)
    {
        json += scilab::UTF8::toUTF8(pStr->get(i));
    }

    if(in.size() == 2)
    {
        if(in[1]->isString() == false || in[1]->getAs<types::String>()->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A scalar string expected.\n"), fname, 2);
            return types::Function::Error;
        }

        std::wstring tmp = in[1]->getAs<types::String>()->get(0);
        if (tmp != L"file")
        {
            Scierror(999, _("%s: Wrong value for input argument #%d: \"file\" expected.\n"), fname, 2);
            return types::Function::Error;
        }

        std::string filename = json;
        std::ifstream infile(filename);
        if (infile.fail())
        {
            Scierror(999, _("%s: Cannot open file %s.\n"), fname, filename.c_str());
            return types::Function::Error;
        }

        json.clear();
        json.reserve(infile.tellg());
        infile.seekg(0, std::ios::beg);

        json.assign((std::istreambuf_iterator<char>(infile)),
            std::istreambuf_iterator<char>());
    }

    std::string err;
    types::InternalType* var = fromJSON(json, err);
    if (var == nullptr)
    {
        Scierror(999, _("%s: %s\n"), fname, err.c_str());
        return types::Function::Error;
    }

    out.push_back(var);
    return types::Function::OK;
}
