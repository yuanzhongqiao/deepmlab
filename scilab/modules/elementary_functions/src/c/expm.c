/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2006 - INRIA - Allan CORNET
 * Copyright (C) 2012 - Digiteo - Cedric Delamarre
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

#include <stdio.h>
#include <string.h>
#include "sci_malloc.h"
#include "expm.h"
#include "basic_functions.h"
#include "elementary_functions.h"
#include "matrix_left_division.h"
#include "matrix_multiplication.h"
#include "matrix_right_division.h"

extern int C2F(dexpm1)(int* ia, int* n, double* a, double* ea, int* iea, double* w, int* iw, int* ierr);

/*
C2F(dgemm)("n", "n", &iRows1, &iCols2, &iCols1, &dblOne, pReal1 , &iRows1 , pReal2, &iRows2, &dblZero, pReturnReal ,&iRows1);
if(iComplex1 == 1)
	C2F(dgemm)("n", "n", &iRows1, &iCols2, &iCols1, &dblOne, pImg1 , &iRows1 , pReal2, &iRows2, &dblZero, pReturnImg ,&iRows1);
if(iComplex2 == 1)
	C2F(dgemm)("n", "n", &iRows1, &iCols2, &iCols1, &dblOne, pReal1 , &iRows1 , pImg2, &iRows2, &dblZero, pReturnImg ,&iRows1);
*/

int dexpms2(double *_pdblReal, double *_pdblReturnReal, int _iLeadDim)
{
    int iRet = 0;
    int* iwork = (int*)MALLOC(sizeof(int) * (2 * _iLeadDim));
    double* dwork = (double*)MALLOC(sizeof(double) * (_iLeadDim * (2 * _iLeadDim + 2 * _iLeadDim + 5)));
    C2F(dexpm1)(&_iLeadDim, &_iLeadDim, _pdblReal, _pdblReturnReal, &_iLeadDim, dwork, iwork, &iRet);
    FREE(dwork);
    FREE(iwork);
    return iRet;
}

int zexpms2(double *_pdblReal, double *_pdblImg, double *_pdblReturnReal, double *_pdblReturnImg, int _iLeadDim)
{
    double dblRcond = 0;
    int iRet        = 0;
    int iMax        = 0;
    int iFlag       = 0;
    int iLoop1      = 0;
    int iSquare     = 0;
    int iOne        = 1;

    int iComplex    = 0;

    double dblExp	= 0;
    double dblS		= 0;
    double dblS2	= 0;
    double dblCst	= 0.5;

    double *pdblMatrixRealA		= NULL;//A'
    double *pdblMatrixRealX		= NULL;//X
    double *pdblMatrixRealD		= NULL;//D
    double *pdblMatrixRealcX	= NULL;//cX
    double *pdblMatrixRealcA	= NULL;//cX
    double *pdblMatrixRealEye	= NULL;//Eye
    double *pdblMatrixRealTemp	= NULL;//Temp
    double *pdblMatrixRealTemp2	= NULL;//Temp2

    double *pdblMatrixImgA		= NULL;//A'
    double *pdblMatrixImgX		= NULL;//X
    double *pdblMatrixImgD		= NULL;//D
    double *pdblMatrixImgcX		= NULL;//cX
    double *pdblMatrixImgcA		= NULL;//cX
    double *pdblMatrixImgEye	= NULL;//Eye
    double *pdblMatrixImgTemp	= NULL;//Temp
    double *pdblMatrixImgTemp2	= NULL;//Temp2

    if (_pdblImg != NULL)
    {
        iComplex = 1;
    }

    iSquare = _iLeadDim * _iLeadDim;

    pdblMatrixRealA			= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealX			= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealD			= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealcX		= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealcA		= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealEye		= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealTemp		= (double*)malloc(sizeof(double) * iSquare);
    pdblMatrixRealTemp2		= (double*)malloc(sizeof(double) * iSquare);

    if (iComplex)
    {
        pdblMatrixImgA			= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgX			= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgD			= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgcX			= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgcA			= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgEye		= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgTemp		= (double*)malloc(sizeof(double) * iSquare);
        pdblMatrixImgTemp2		= (double*)malloc(sizeof(double) * iSquare);

        memset(pdblMatrixImgEye, 0x00, sizeof(double) * iSquare);
    }


    // Scale A by power of 2 so that its norm is < 1/2 .
    dfrexps(dblGetMatrixInfiniteNorm(_pdblReal, _pdblImg, _iLeadDim, _iLeadDim), &dblExp);
    dblS	= Max(0, dblExp + 1);
    dblS2	= pow(2, dblS);

    //A = A./2^s
    if (iComplex)
    {
        iRightDivisionComplexMatrixByRealMatrix(
            _pdblReal,			_pdblImg	,		1,
            &dblS2,				0,
            pdblMatrixRealA,	pdblMatrixImgA,	1,	iSquare);
    }
    else
    {
        iRightDivisionRealMatrixByRealMatrix(
            _pdblReal,			1,
            &dblS2,				0,
            pdblMatrixRealA,	1,	iSquare);
    }

    // Pade approximation for exp(A)
    //X = A
    C2F(dcopy)(&iSquare, pdblMatrixRealA, &iOne, pdblMatrixRealX, &iOne );
    if (iComplex)
    {
        C2F(dcopy)(&iSquare, pdblMatrixImgA, &iOne, pdblMatrixImgX, &iOne );
    }


    deyes(pdblMatrixRealEye, _iLeadDim, _iLeadDim);


    //cA = A * c
    if (iComplex)
        iMultiRealScalarByComplexMatrix(
            dblCst,
            pdblMatrixRealA, pdblMatrixImgA, _iLeadDim, _iLeadDim,
            pdblMatrixRealcA, pdblMatrixImgcA);
    else
        iMultiRealScalarByRealMatrix(
            dblCst,
            pdblMatrixRealA, _iLeadDim, _iLeadDim,
            pdblMatrixRealcA);
    /*
    	C2F(dcopy)(&iSquare, pdblMatrixRealA, &iOne, pdblMatrixRealcA, &iOne);
    	C2F(dscal)(&iSquare, &dblCst, pdblMatrixRealcA, &iOne);
    */

    //E = Eye + cA
    vDadd(iSquare, pdblMatrixRealEye, pdblMatrixRealcA, 1, 1, _pdblReturnReal);
    if (iComplex)
    {
        vDadd(iSquare, pdblMatrixImgEye, pdblMatrixImgcA, 1, 1, _pdblReturnImg);
    }

    //D = Eye - cA
    vDless(iSquare, pdblMatrixRealEye, pdblMatrixRealcA, 1, 1, pdblMatrixRealD);
    if (iComplex)
    {
        vDless(iSquare, pdblMatrixImgEye, pdblMatrixImgcA, 1, 1, pdblMatrixImgD);
    }

    iMax	= 6;
    iFlag	= 1;

    for (iLoop1 = 2 ; iLoop1 <= iMax ; iLoop1++)
    {
        dblCst	= dblCst * (iMax - iLoop1 + 1 ) / (iLoop1 * (2 * iMax - iLoop1 + 1));

        //Temp = X
        C2F(dcopy)(&iSquare, pdblMatrixRealX, &iOne, pdblMatrixRealTemp, &iOne);
        if (iComplex)
        {
            C2F(dcopy)(&iSquare, pdblMatrixImgX, &iOne, pdblMatrixImgTemp, &iOne);
        }
        /*		for(iIndex1 = 0 ; iIndex1 < iSquare ; iIndex1++)
        			pdblMatrixRealTemp[iIndex1]	= pdblMatrixRealX[iIndex1];
        */
        //X = A * Temp;
        if (iComplex)
        {
            iMultiComplexMatrixByComplexMatrix(
                pdblMatrixRealA, pdblMatrixImgA, _iLeadDim, _iLeadDim,
                pdblMatrixRealTemp, pdblMatrixImgTemp, _iLeadDim, _iLeadDim,
                pdblMatrixRealX, pdblMatrixImgX);
        }
        else
        {
            iMultiRealMatrixByRealMatrix(
                pdblMatrixRealA, _iLeadDim, _iLeadDim,
                pdblMatrixRealTemp, _iLeadDim, _iLeadDim,
                pdblMatrixRealX);
        }
        /*		C2F(dgemm)("n", "n", &_iLeadDim, &_iLeadDim, &_iLeadDim, &dblOne,
        			pdblMatrixRealA, &_iLeadDim ,
        			pdblMatrixRealTemp, &_iLeadDim, &dblZero,
        			pdblMatrixRealX ,&_iLeadDim);
        */
        //cX = c * X
        if (iComplex)
            iMultiRealScalarByComplexMatrix(
                dblCst,
                pdblMatrixRealX, pdblMatrixImgX, _iLeadDim, _iLeadDim,
                pdblMatrixRealcX, pdblMatrixImgcX);
        else
            iMultiRealScalarByRealMatrix(
                dblCst,
                pdblMatrixRealX, _iLeadDim, _iLeadDim,
                pdblMatrixRealcX);
        /*		C2F(dcopy)(&iSquare, pdblMatrixRealX, &iOne, pdblMatrixRealcX, &iOne);
        		C2F(dscal)(&iSquare, &dblCst, pdblMatrixRealcX, &iOne);
        */

        //E = E + cX
        vDadd(iSquare, _pdblReturnReal, pdblMatrixRealcX, 1, 1, _pdblReturnReal);
        if (iComplex)
        {
            vDadd(iSquare, _pdblReturnImg, pdblMatrixImgcX, 1, 1, _pdblReturnImg);
        }


        if (iFlag == 1) //D = D + cX
        {
            vDadd(iSquare, pdblMatrixRealD, pdblMatrixRealcX, 1, 1, pdblMatrixRealD);
            if (iComplex)
            {
                vDadd(iSquare, pdblMatrixImgD, pdblMatrixImgcX, 1, 1, pdblMatrixImgD);
            }
        }
        else //D = D - cX
        {
            vDless(iSquare, pdblMatrixRealD, pdblMatrixRealcX, 1, 1, pdblMatrixRealD);
            if (iComplex)
            {
                vDless(iSquare, pdblMatrixImgD, pdblMatrixImgcX, 1, 1, pdblMatrixImgD);
            }
        }

        //Toggle iFlag
        iFlag = !iFlag;
    }

    //Temp = E
    C2F(dcopy)(&iSquare, _pdblReturnReal, &iOne, pdblMatrixRealTemp, &iOne);
    if (iComplex)
    {
        C2F(dcopy)(&iSquare, _pdblReturnImg, &iOne, pdblMatrixImgTemp, &iOne);
        /*	for(iIndex1 = 0 ; iIndex1 < iSquare ; iIndex1++)
        		pdblMatrixRealTemp[iIndex1]	= _pdblReturnReal[iIndex1];
        */
    }

    //E = D\E
    if (iComplex)
    {
        iRet = iLeftDivisionOfComplexMatrix(
                   pdblMatrixRealD,	pdblMatrixImgD,		_iLeadDim, _iLeadDim,
                   pdblMatrixRealTemp,	pdblMatrixImgTemp,	_iLeadDim, _iLeadDim,
                   _pdblReturnReal,	_pdblReturnImg,		_iLeadDim, _iLeadDim, &dblRcond);
    }
    else
    {
        iRet = iLeftDivisionOfRealMatrix(
                   pdblMatrixRealD,	_iLeadDim, _iLeadDim,
                   pdblMatrixRealTemp,	_iLeadDim, _iLeadDim,
                   _pdblReturnReal,	_iLeadDim, _iLeadDim, &dblRcond);
    }

    if (iRet < 0)
    {
        switch (iRet)
        {
            case -1 :
                //Scilab 6
                //sprintf(C2F(cha1).buf, "%1.4E", dblRcond);
                //Msgs(5,1);
                break;
            case -2 :
                //Scilab 6
                //Msgs(9, (int)dblRcond);
                break;
            default :
                break;
        }
    }
    // Undo scaling by repeated squaring
    for (iLoop1 = 0 ; iLoop1 < dblS ; iLoop1++)
    {
        //Temp = E
        C2F(dcopy)(&iSquare, _pdblReturnReal, &iOne, pdblMatrixRealTemp, &iOne);
        //Temp2 = E
        C2F(dcopy)(&iSquare, _pdblReturnReal, &iOne, pdblMatrixRealTemp2, &iOne);
        if (iComplex)
        {
            //Temp = E
            C2F(dcopy)(&iSquare, _pdblReturnImg, &iOne, pdblMatrixImgTemp, &iOne);
            //Temp2 = E
            C2F(dcopy)(&iSquare, _pdblReturnImg, &iOne, pdblMatrixImgTemp2, &iOne);
        }


        /*		for(iIndex1 = 0 ; iIndex1 < iSquare ; iIndex1++)
        			pdblMatrixRealTemp[iIndex1]		= _pdblReturnReal[iIndex1];
        */
        /*		for(iIndex1 = 0 ; iIndex1 < iSquare ; iIndex1++)
        			pdblMatrixRealTemp2[iIndex1]	= _pdblReturnReal[iIndex1];
        */
        // E = E*E
        if (iComplex)
            iMultiComplexMatrixByComplexMatrix(
                pdblMatrixRealTemp,		pdblMatrixImgTemp,	_iLeadDim, _iLeadDim,
                pdblMatrixRealTemp2,	pdblMatrixImgTemp2,	_iLeadDim, _iLeadDim,
                _pdblReturnReal,		_pdblReturnImg);
        else
            iMultiRealMatrixByRealMatrix(
                pdblMatrixRealTemp,		_iLeadDim, _iLeadDim,
                pdblMatrixRealTemp2,	_iLeadDim, _iLeadDim,
                _pdblReturnReal);
        /*
        		C2F(dgemm)("n", "n", &_iLeadDim, &_iLeadDim, &_iLeadDim, &dblOne,
        			pdblMatrixRealTemp,		&_iLeadDim ,
        			pdblMatrixRealTemp2,	&_iLeadDim, &dblZero,
        			_pdblReturnReal ,		&_iLeadDim);
        */
    }

    free(pdblMatrixRealA);
    free(pdblMatrixRealX);
    free(pdblMatrixRealD);
    free(pdblMatrixRealcX);
    free(pdblMatrixRealcA);
    free(pdblMatrixRealEye);
    free(pdblMatrixRealTemp);
    free(pdblMatrixRealTemp2);

    if (iComplex)
    {
        free(pdblMatrixImgA);
        free(pdblMatrixImgX);
        free(pdblMatrixImgD);
        free(pdblMatrixImgcX);
        free(pdblMatrixImgcA);
        free(pdblMatrixImgEye);
        free(pdblMatrixImgTemp);
        free(pdblMatrixImgTemp2);
    }

    return 0;
}

double dblGetMatrixInfiniteNorm(double *_pdblReal, double *_pdblImg, int _iRows, int _iCols)
{
    int iIndex1 = 0, iIndex2 = 0;
    double dblTemp = 0;
    double dblRef = 0;

    if (_pdblImg == NULL)
    {
        for (iIndex1 = 0 ; iIndex1 < _iRows ; iIndex1++)
        {
            dblTemp = 0;
            for (iIndex2 = 0 ; iIndex2 < _iCols ; iIndex2++)
            {
                dblTemp += _pdblReal[iIndex1 + iIndex2 * _iRows];
            }
            if (dblTemp > dblRef)
            {
                dblRef = dblTemp;
            }
        }
    }
    else
    {
        for (iIndex1 = 0 ; iIndex1 < _iRows ; iIndex1++)
        {
            dblTemp = 0;
            for (iIndex2 = 0 ; iIndex2 < _iCols ; iIndex2++)
            {
                dblTemp += dpythags(_pdblReal[iIndex1 + iIndex2 * _iRows], _pdblImg[iIndex1 + iIndex2 * _iRows]);
            }
            if (dblTemp > dblRef)
            {
                dblRef = dblTemp;
            }
        }
    }
    return dblRef;
}
