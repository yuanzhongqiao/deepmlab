/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

/*--------------------------------------------------------------------------*/
#ifndef __DYNLIB_WEBTOOLS_GW_H__
#define __DYNLIB_WEBTOOLS_GW_H__

#ifdef _MSC_VER
#ifdef WEBTOOLS_GW_EXPORTS
#define WEBTOOLS_GW_IMPEXP __declspec(dllexport)
#else
#define WEBTOOLS_GW_IMPEXP __declspec(dllimport)
#endif
#else
#define WEBTOOLS_GW_IMPEXP
#endif

#endif /* __DYNLIB_WEBTOOLS_GW_H__ */
/*--------------------------------------------------------------------------*/
