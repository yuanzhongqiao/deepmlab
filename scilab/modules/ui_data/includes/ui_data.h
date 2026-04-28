/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2011 - DIGITEO - Calixte DENIZET
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

/*------------------------------------------------------------------------*/
#ifndef __UI_DATA_C_H__
#define __UI_DATA_C_H__
/*------------------------------------------------------------------------*/
#ifdef __cplusplus
extern "C" {
#endif

/*
 * See https://c-faq.com/ansi/constmismatch.html and https://isocpp.org/wiki/faq/const-correctness
 * ISO Sec. 6.1.2.6, Sec. 6.3.16.1, Sec. 6.5.3
 */
#ifdef __cplusplus
#define CONST_PTR const
#else
#define CONST_PTR 
#endif

/*------------------------------------------------------------------------*/
void putScilabVariable(const char * name, char CONST_PTR* CONST_PTR* lines, int rows, int cols);
char * getUnnamedVariable();
/*------------------------------------------------------------------------*/
#ifdef __cplusplus
}
#endif
/*------------------------------------------------------------------------*/
#endif /* __UI_DATA_C_H__ */
/*------------------------------------------------------------------------*/
