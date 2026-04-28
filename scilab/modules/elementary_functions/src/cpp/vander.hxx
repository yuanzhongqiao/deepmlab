/*
*  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*  Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
*
* For more information, see the COPYING file which you should have received
* along with this program.
*
*/

#ifndef __VANDER_H__
#define __VANDER_H__

#include "double.hxx"

extern "C"
{
#include "dynlib_elementary_functions.h"
}

ELEMENTARY_FUNCTIONS_IMPEXP int vander(types::Double* pIn,  int N, types::Double* pOut);

#endif /* __VANDER_H__ */
