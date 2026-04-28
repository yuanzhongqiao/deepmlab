/*
*  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*  Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*  Copyright (C) 2016 - Scilab Enterprises - Antoine ELIAS
*  Copyright (C) 2012 - 2016 - Scilab Enterprises
*
*/

#include "json.hxx"
#include "fromJSON.hxx"
#include "toJSON.hxx"

// convertion API C to API C++
std::string toJSON(scilabEnv env, scilabVar var, int indent)
{
    return toJSON((types::InternalType*)var, indent);
}

std::string toJSON(types::InternalType* it, int indent)
{
    std::string err;
    return toJSON(it, err, indent);
}

scilabVar fromJSON(scilabEnv env, const std::string& s)
{
    return (scilabVar)fromJSON(s);
}

types::InternalType* fromJSON(const std::string& s)
{
    std::string err;
    return fromJSON(s, err);
}
