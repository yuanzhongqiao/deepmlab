/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2010 - DIGITEO - Vincent COUVERT
 * Copyright (C) 2010 - DIGITEO - Yann COLLETTE
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "api_scilab.h"
#include "CreateMatlabVariable.h"
#include "sci_malloc.h"
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"

int CreateBooleanVariable(void* pvApiCtx, int iVar, int integerType, matvar_t* matVariable, int* parent, int item_position)
{
    int nbRow = 0, nbCol = 0;
    int *piDims = NULL;
    int * intPtr = NULL;
    double * dblPtr = NULL;
    int K = 0;
    SciErr sciErr;

    if (matVariable->rank == 2) /* 2-D array */
    {
        nbRow = (int)matVariable->dims[0];
        nbCol = (int)matVariable->dims[1];

        if (nbRow * nbCol != 0)
        {
            if ((intPtr = (int*) MALLOC(sizeof(int) * nbRow * nbCol)) == NULL)
            {
                Scierror(999, _("%s: No more memory.\n"), "CreateBooleanVariable");
                return FALSE;
            }

            for (K = 0; K < nbRow * nbCol; K++)
            {
                switch (integerType)
                {
                    case MAT_C_UINT8:
                        intPtr[K] = ((unsigned char*)matVariable->data)[K];
                        break;
                    case MAT_C_UINT16:
                        intPtr[K] = ((unsigned short*)matVariable->data)[K];
                        break;
                    case MAT_C_UINT32:
                        intPtr[K] = ((unsigned int*)matVariable->data)[K];
                        break;
                }

            }

            if (parent == NULL)
            {
                sciErr = createMatrixOfBoolean(pvApiCtx, iVar, nbRow, nbCol, intPtr);
                if (sciErr.iErr)
                {
                    printError(&sciErr, 0);
                    FREE(intPtr);
                    return 0;
                }
            }
            else
            {
                sciErr = createMatrixOfBooleanInList(pvApiCtx, iVar, parent, item_position, nbRow, nbCol, intPtr);
                if (sciErr.iErr)
                {
                    printError(&sciErr, 0);
                    FREE(intPtr);
                    return 0;
                }
            }

            FREE(intPtr);
        }
        else
        {
            if ((dblPtr = (double *)CALLOC(nbRow * nbCol, sizeof(double))) == NULL)
            {
                Scierror(999, _("%s: No more memory.\n"), "CreateBooleanVariable");
                return FALSE;
            }

            for (K = 0; K < nbRow * nbCol; K++)
            {
                dblPtr[K] = ((unsigned char*)matVariable->data)[K];
            }

            if (parent == NULL)
            {
                sciErr = createMatrixOfDouble(pvApiCtx, iVar, nbRow, nbCol, dblPtr);
                if (sciErr.iErr)
                {
                    printError(&sciErr, 0);
                    FREE(dblPtr);
                    return 0;
                }
            }
            else
            {
                sciErr = createMatrixOfDoubleInList(pvApiCtx, iVar, parent, item_position, nbRow, nbCol, dblPtr);
                if (sciErr.iErr)
                {
                    printError(&sciErr, 0);
                    FREE(dblPtr);
                    return 0;
                }
            }

            FREE(dblPtr);
        }
    }
    else /* Multi-dimension array -> Scilab HyperMatrix */
    {
        piDims = (int*) MALLOC(matVariable->rank * sizeof(int));
        if (piDims == NULL)
        {
            Scierror(999, _("%s: No more memory.\n"), "CreateBooleanVariable");
            return FALSE;
        }
        for (K = 0; K < matVariable->rank; K++)
        {
            piDims[K] = (int)matVariable->dims[K];
        }

        CreateHyperMatrixVariable(pvApiCtx, iVar, matVariable->class_type, NULL, &matVariable->rank, piDims, matVariable, parent, item_position);

        FREE(piDims);
    }

    return TRUE;
}

