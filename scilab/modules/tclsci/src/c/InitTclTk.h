/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2005 - INRIA - Allan CORNET
 * Copyright (C) 2007-2008 - INRIA - Sylvestre LEDRU
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

#ifndef __INITTCLTK__
#define __INITTCLTK__

/*#include "TCL_Global.h"*/
#include "BOOL.h"

/**
 * Initialize TCL/TK
 * @return if started (TRUE) or not (FALSE)
 */
BOOL initTCLTK(void);

/**
 * @TODO add comment
 *
 * @return <ReturnValue>
 */
int OpenTCLsci(void);

/**
 * TODO : comment
 * @return
 */
BOOL CloseTCLsci(void);

/**
 * Set if tcl/tk is started or not
 * @param isTkSet if enable or not
 */
void setTkStarted(BOOL isTkSet);

/**
 * Get tcl/tk status
 * @return says if TCL/TK is started (TRUE) or not (FALSE)
 */
BOOL isTkStarted(void);

/**
 * Set if Scilab tcl loop is alive or not
 * @param isTclSet if enable or not
 */
void setTclLoopAlive(BOOL isTclLoopAlive);

/**
 * Get Scilab tcl loop status
 * @return says if Scilab TCL loop is alive (TRUE) or not (FALSE)
 */
BOOL isTclLoopAlive(void);

#endif /* __INITTCLTK__ */
/*--------------------------------------------------------------------------*/
