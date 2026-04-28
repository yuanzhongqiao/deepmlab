/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#ifndef __SPAWNCOMMAND_HXX__
#define __SPAWNCOMMAND_HXX__

#include "dynlib_io.h"
#include "string.hxx"

IO_IMPEXP int spawncommand(const std::wstring& _pstCommand, int _iOutputs, types::String** _pStrOut = nullptr, types::String** _pStrErr = nullptr, int iEcho = 0);

#endif
