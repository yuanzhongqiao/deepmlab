/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2006 - INRIA - Allan CORNET
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

#ifndef __GW_IO_H__
#define __GW_IO_H__
/*--------------------------------------------------------------------------*/
#include "machine.h"
#include "dynlib_io.h"
#include "c_gateway_prototype.h"

/*--------------------------------------------------------------------------*/
//Scilab 6
int sci_getenv(char *fname, void* pvApiCtx);
int sci_setenv(char *fname, void* pvApiCtx);

C_GATEWAY_PROTOTYPE(sci_getio);
/*--------------------------------------------------------------------------*/
#endif /* __GW_IO_H__ */
/*--------------------------------------------------------------------------*/

