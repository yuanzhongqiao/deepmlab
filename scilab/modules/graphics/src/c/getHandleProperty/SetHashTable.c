/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2006 - INRIA - Jean-Baptiste Silvy
 * Copyright (C) 2007 - INRIA - Vincent Couvert
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
/* file: SetHashTable.c                                                   */
/* desc : implementation of the scilab hashtable for the set procedure    */
/*------------------------------------------------------------------------*/
#include <string.h>
#include "SetHashTable.h"
#include "GetHashTable.h"
#include "setHandleProperty.h"
#include "Scierror.h"
#include "localization.h"
#include "getDictionarySetProperties.h"
#include "sci_malloc.h"
#include "os_string.h"
#include "BOOL.h"

#include "setGetHashTable.h"

/*--------------------------------------------------------------------------*/
int callSetProperty(void* _pvCtx, int iObjUID, void* _pvData, int valueType, int nbRow, int nbCol, const char *propertyName)
{
    setPropertyFunc accessor = searchSetHashtable(propertyName);

    if (accessor == NULL)
    {
        if (searchGetHashtable(propertyName) == NULL)
        {
            Scierror(999, _("Unknown property: %s.\n"), propertyName);            
        }
        else
        {
            Scierror(999, _("Read-only property: %s.\n"), propertyName);                        
        }
        return SET_PROPERTY_ERROR;
    }
    return accessor(_pvCtx, iObjUID, _pvData, valueType, nbRow, nbCol);
}
/*--------------------------------------------------------------------------*/
char **getDictionarySetProperties(int *sizearray)
{
    char **dictionary = NULL;
    size_t propertyCount = 0;
    const SetPropertyEntry* entries = getSetPropertyEntries(&propertyCount);

    *sizearray = 0;
    dictionary = (char **)MALLOC(sizeof(char *) * propertyCount);
    if (dictionary)
    {
        int i = 0;

        *sizearray = (int)propertyCount;
        for (i = 0; i < (int)propertyCount ; i++)
        {
            dictionary[i] = os_strdup(entries[i].key);
        }
    }
    return dictionary;
}

/*--------------------------------------------------------------------------*/
