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
/* file: setGetHashTable.h                                                */
/* desc : define two hash table to be used in sci_set and sci_get         */
/*        These hash table are based on the Scilab hashTable              */
/*------------------------------------------------------------------------*/

#ifndef _SET_GET_HASHTABLE_H_
#define _SET_GET_HASHTABLE_H_

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif


/*--------------------------------------------------------------------------*/
/**
 * Prototype of functions used to get a specific property of an handle.
 * The char* is the UID of the object to get the property from
 * The return value is 0 if the call was successful and -1 otherwise.
 */
typedef void* (*getPropertyFunc)(void*, int);

/**
* Prototype of functions used to set a specific property of an handle.
* The char* is the UID of the object to get the property from
* The return value is SET_PROPERTY_SUCCEED if the call was successful and a redraw is needed
* SET_PROPERTY_UNCHANGED if nothing was actually changed and SET_PROPERTY_ERROR if
* an error occurred.
*/
typedef int (*setPropertyFunc)(void*, int, void*, int, int, int);

typedef struct
{
    const char* key;
    setPropertyFunc func;
} SetPropertyEntry;

typedef struct
{
    const char* key;
    getPropertyFunc func;
} GetPropertyEntry;
/*--------------------------------------------------------------------------*/
getPropertyFunc searchGetHashtable(const char * key);
setPropertyFunc searchSetHashtable(const char * key);

const SetPropertyEntry* getSetPropertyEntries(size_t* count);
const GetPropertyEntry* getGetPropertyEntries(size_t* count);

#ifdef __cplusplus
} // extern "C"
#endif


#endif /* _SET_GET_HASHTABLE_H_ */
