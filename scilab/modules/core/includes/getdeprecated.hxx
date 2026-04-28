/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
 */

#ifndef __GETDEPRECATED_HXX__
#define __GETDEPRECATED_HXX__

extern "C"
{
#include "dynlib_core.h"
}

CORE_IMPEXP std::unordered_map<std::wstring, std::wstring> getDeprecated();
CORE_IMPEXP std::unordered_map<std::wstring, std::wstring> getDeleted();

#endif /* __GETDEPRECATED_HXX__ */
