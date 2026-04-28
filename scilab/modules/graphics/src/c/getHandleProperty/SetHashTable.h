/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2006 - INRIA - Jean-Baptiste Silvy
 * Copyright (C) 2011 - DIGITEO - Bruno JOFRET
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
/* file: SetHashTable.h                                                   */
/* desc : implementation of the scilab hashtable for the set procedure    */
/*------------------------------------------------------------------------*/

#ifndef _SET_HASH_TABLE_H_
#define _SET_HASH_TABLE_H_

#include "dynlib_graphics.h"

/**
 * call the function which the property propertyName of object pObj
 * @return  0 if successful
 *         -1 if an error occurred in the get function
 *          1 if the property was not found
 */
GRAPHICS_IMPEXP int callSetProperty(void* _pvCtx, int iObjUID, void* _pvData, int valueType, int nbRow, int nbCol, const char * propertyName);

#endif /* _SET_HASH_TABLE_H_ */
