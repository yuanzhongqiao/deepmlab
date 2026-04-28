/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2007 - INRIA - Allan CORNET
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
/*--------------------------------------------------------------------------*/
#ifndef __XERHLT_H__
#define __XERHLT_H__

#include "machine.h" /* C2F */
#include "dynlib_elementary_functions.h"

/**
* halt solver execution
* @param messg a message
* @param l length of messg
*/
ELEMENTARY_FUNCTIONS_IMPEXP void C2F(xerhlt) (char *messg, unsigned long l);

#endif /* __XERHLT_H__ */
/*--------------------------------------------------------------------------*/
