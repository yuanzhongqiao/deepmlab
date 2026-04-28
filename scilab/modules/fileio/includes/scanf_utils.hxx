/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#ifndef __SCANF_UTILS_HXX__
#define __SCANF_UTILS_HXX__

#include "internal.hxx"

extern "C"
{
#include "do_xxscanf.h"
}

unsigned int scanfToInternalTypes(entry* data, sfdir* type_s, int iSize, int iCol, std::vector<types::InternalType*>& vIT);
void InternalTypesToOutput(std::vector<types::InternalType*>& vIT, int iRetCount, int retval, unsigned int uiFormatUsed, types::typed_list &out);

#endif /* __SCANF_UTILS_HXX__ */
