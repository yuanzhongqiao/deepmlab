/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#ifndef __GATEWAY_TOOLS__
#define __GATEWAY_TOOLS__

#include "sciCurl.hxx"

int checkCommonOpt(SciCurl& curl, types::optional_list& opt, const char* fname);
int setPreferences(SciCurl& curl, const char* fname);

#endif /* !__GATEWAY_TOOLS__ */
