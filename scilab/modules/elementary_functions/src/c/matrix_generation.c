/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2008 - DIGITEO - Antoine ELIAS
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
#include "basic_functions.h"
#include <string.h>
#include "stdio.h"

void pascal_matrix(int _iSize, int k, double *_pData)
{
    int iOne        = 1;
    double dblOne   = 1.0;
    int size        = _iSize * _iSize;
    int iIndex1     = 0;

    if (k == 0)
    {
        C2F(dset)(&size, &dblOne, _pData, &iOne);

        for (iIndex1 = _iSize + 1; iIndex1 < size; iIndex1++)
        {
            if ((iIndex1 % _iSize) != 0) 
            {
                _pData[iIndex1] = _pData[iIndex1 - 1] + _pData[iIndex1 - _iSize];
            }
        }
    } 
    else
    {
        memset(_pData, 0x00, sizeof(double) * _iSize * _iSize);
        C2F(dset)(&_iSize, &dblOne, _pData, &iOne);

        for (iIndex1 = _iSize + 1; iIndex1 < size; iIndex1++)
        {
            if ((iIndex1 % (_iSize + 1)) <= ((size - iIndex1)/_iSize)) 
            {
                _pData[iIndex1] = _pData[iIndex1 - 1] - _pData[iIndex1 - _iSize - 1];
            }
        }
    }
}

void frank_matrix(int _iSize, double *_pData)
{
    int iIndex1		= 0;
    int iIndex2		= 0;
    double dblVal	= _iSize;

    memset(_pData, 0x00, sizeof(double) * _iSize * _iSize);
    _pData[0]		= dblVal;

    if (_iSize == 1)
    {
        return;
    }

    for (iIndex1 = 1 ; iIndex1 < _iSize ; iIndex1++)
    {
        dblVal = _iSize - iIndex1;
        _pData[(iIndex1 - 1) * _iSize + iIndex1] = dblVal;
        for (iIndex2 = 0 ; iIndex2 <= iIndex1 ; iIndex2++)
        {
            _pData[iIndex1 * _iSize + iIndex2] = dblVal;
        }
    }
}

void invhilb_matrix(int _iSize, double *_pData)
{
    int iIndex1		= 0;
    int iIndex2		= 0;
    double dblVal	= _iSize;
    double dblTemp	= 0;

    for (iIndex1 = 0 ; iIndex1 < _iSize ; iIndex1++)
    {
        if (iIndex1 != 0)
        {
            dblVal = ((_iSize - iIndex1) * dblVal * (_iSize + iIndex1)) / pow(iIndex1, 2);
        }
        dblTemp = dblVal * dblVal;

        _pData[iIndex1 * _iSize + iIndex1]	= dblTemp / ( 2 * iIndex1 + 1);
        if (iIndex1 == _iSize - 1)
        {
            break;
        }
        for (iIndex2 = iIndex1 + 1 ; iIndex2 < _iSize ; iIndex2++)
        {
            dblTemp = -((_iSize - iIndex2) * dblTemp * (_iSize + iIndex2)) / pow(iIndex2, 2);
            _pData[iIndex1 * _iSize + iIndex2] = dblTemp / (iIndex1 + iIndex2 + 1);
            _pData[iIndex2 * _iSize + iIndex1] = _pData[iIndex1 * _iSize + iIndex2];
        }
    }
}

void hilb_matrix(int _iSize, double *_pData)
{
    int iIndex1		= 0;
    int iIndex2		= 0;
    double dblTemp	= 1;

    memset(_pData, 0x00, sizeof(double) * _iSize * _iSize);
    for (iIndex1 = 0; iIndex1 < _iSize; iIndex1++)
    {
        for (iIndex2 = 0; iIndex2 < _iSize; iIndex2++)
        {
            _pData[iIndex1 * _iSize + iIndex2] = (dblTemp / (iIndex1 + iIndex2 + 1));
        }
    }
}

void magic_matrix(int _iSize, double *_pData)
{
    int iNewSize	= 0;
    int iIndex1		= 0;
    int iIndex2		= 0;
    int iUn			= 1;
    int iTemp1		= 0;
    int iTemp2		= 0;

    if (_iSize % 4 != 0)
    {
        int iRow	= 0;
        int iCol	= 0;
        if (_iSize % 2 == 0)
        {
            iNewSize = _iSize / 2;
        }
        if (_iSize % 2 != 0)
        {
            iNewSize = _iSize;
        }

        //odd order or upper corner of even order

        iRow		= 0;
        iCol		= iNewSize / 2;
        memset(_pData, 0x00, sizeof(double) * _iSize * _iSize);
        for (iIndex1 = 0 ; iIndex1 < iNewSize * iNewSize ; iIndex1++)
        {
            int iRowTemp	= 0;
            int iColTemp	= 0;

            _pData[iRow + iCol * _iSize] = iIndex1 + 1;
            iRowTemp		= iRow - 1;
            iColTemp		= iCol + 1;

            if (iRowTemp < 0)
            {
                iRowTemp	= iNewSize - 1;
            }
            if (iColTemp >= iNewSize)
            {
                iColTemp	= 0;
            }

            if (_pData[iRowTemp + iColTemp * _iSize] != 0)
            {
                iRowTemp	= iRow + 1;
                iColTemp	= iCol;
            }
            iRow		= iRowTemp;
            iCol		= iColTemp;
        }
        if (_iSize % 2 != 0)
        {
            return;
        }

        //rest of even order
        for (iIndex1 = 0 ; iIndex1 < iNewSize ; iIndex1++)
        {
            for (iIndex2 = 0 ; iIndex2 < iNewSize ; iIndex2++)
            {
                int iRow = iIndex1 + iNewSize;
                int iCol = iIndex2 + iNewSize;

                _pData[iIndex1 + iCol * _iSize] = _pData[iIndex1 + iIndex2 * _iSize] + 2 * iNewSize * iNewSize;
                _pData[iRow + iIndex2 * _iSize] = _pData[iIndex1 + iIndex2 * _iSize] + 3 * iNewSize * iNewSize;
                _pData[iRow + iCol * _iSize]	= _pData[iIndex1 + iIndex2 * _iSize] + iNewSize * iNewSize;
            }
        }
        if ((iNewSize - 1) / 2 == 0)
        {
            return;
        }
        for (iIndex1 = 0 ; iIndex1 < (iNewSize - 1) / 2 ; iIndex1++)
        {
            C2F(dswap)(&iNewSize, &_pData[iIndex1 * _iSize], &iUn, &_pData[iNewSize + iIndex1 * _iSize], &iUn);
        }

        iTemp1	= (iNewSize + 1) / 2 - 1;
        iTemp2	= iTemp1 + iNewSize;
        C2F(dswap)(&iUn, &_pData[iTemp1], &iUn, &_pData[iTemp2], &iUn);
        C2F(dswap)(&iUn, &_pData[iTemp1 * _iSize + iTemp1], &iUn, &_pData[iTemp1 * _iSize + iTemp2], &iUn);
        iTemp1 = _iSize - (iNewSize - 3) / 2;
        if (iTemp1 > _iSize)
        {
            return;
        }
        for (iIndex1 = iTemp1 ; iIndex1 < _iSize ; iIndex1++)
        {
            C2F(dswap)(&iNewSize, &_pData[iIndex1 * _iSize], &iUn, &_pData[iNewSize + iIndex1 * _iSize], &iUn);
        }
    }
    else
    {
        int iVal = 1;
        for (iIndex1 = 0 ; iIndex1 < _iSize ; iIndex1++)
        {
            for (iIndex2 = 0 ; iIndex2 < _iSize ; iIndex2++)
            {
                _pData[iIndex2 * _iSize + iIndex1] = iVal;
                if (((iIndex1 + 1) % 4) / 2 == ((iIndex2 + 1) % 4) / 2)
                {
                    _pData[iIndex2 * _iSize + iIndex1] = _iSize * _iSize + 1 - iVal;
                }
                iVal++;
            }
        }
    }
}

void wilkinson_matrix(int _iSize, double *_pData)
{
    int iIndex1		= 0;
    double dblVal	= 0;
    double N = _iSize;

    memset(_pData, 0x00, sizeof(double) * _iSize * _iSize);

    if (_iSize == 1)
    {
        return;
    }

    for (iIndex1 = 0 ; iIndex1 < _iSize ; iIndex1++)
    {
        dblVal = dabss(-(N - 1)/2 + iIndex1);
        _pData[iIndex1 * _iSize + iIndex1] = dblVal;
        if (iIndex1 * _iSize + iIndex1 + 1 < _iSize * _iSize)
        {
            _pData[iIndex1 * _iSize + iIndex1 + 1] = 1;
        }
        if (iIndex1 * _iSize + iIndex1 - 1 > 0)
        {
            _pData[iIndex1 * _iSize + iIndex1 - 1] = 1;
        }
    }
}

void hankel_matrix(int _iSizeC, int _iSizeR, double *_C, double *_R, double *_pData)
{
    int iIndex1		= 0;
    int N = _iSizeC + (_iSizeR - 1);

    double* _pDataX = (double*)malloc(sizeof(double) * N);
    if (!_C || !_R)
    {
        memset(_pDataX, 0x00, sizeof(double) * N);
    }
    if (_C)
    {
        memcpy(_pDataX, _C, _iSizeC * sizeof(double));
    }
    if (_R)
    {
        memcpy(_pDataX +_iSizeC, _R + 1, (_iSizeR - 1) * sizeof(double));    
    }

    for (iIndex1 = 0; iIndex1 < _iSizeR; iIndex1++)
    {
        memcpy(_pData + iIndex1 * _iSizeC, _pDataX + iIndex1, _iSizeC * sizeof(double));
    }
    free(_pDataX);
}

void circul_matrix(int _iSize, double *_pIn,  double *_pData)
{
    int iOne        = 1;

    if (_iSize == 1)
    {
        _pData[0] = 1;
        return;
    }

    C2F(dcopy)(&_iSize, _pIn, &iOne, _pData, &_iSize);
  
    for (int iIndex1 = 1; iIndex1 < _iSize; iIndex1++)
    {
        int idx = _iSize - iIndex1;
        C2F(dcopy)(&idx, _pIn, &iOne, _pData + (_iSize * iIndex1 + iIndex1), &_iSize);
        C2F(dcopy)(&iIndex1, _pIn + idx, &iOne, _pData + iIndex1, &_iSize);
    }
}

void cauchy_matrix(int _iSize, double *_pInX, double *_pInXI, double *_pInY, double *_pInYI, double *_pData, double *_pDataImg)
{
    if (_pInXI == NULL && _pInYI == NULL) // real case
    {
        for (int iIndex1 = 0; iIndex1 < _iSize; iIndex1++)
        {
            double pdblY = _pInY[iIndex1];
            for (int iIndex2 = 0; iIndex2 < _iSize; iIndex2++)
            {
                _pData[iIndex1 * _iSize + iIndex2] = 1 / (_pInX[iIndex2] + pdblY);
            }
        }
        return;
    }

    double *XITemp = _pInXI;
    int totalSize = _iSize *_iSize;
    if (XITemp == NULL)
    {
        XITemp = (double *)malloc(totalSize * sizeof(double));
        memset(XITemp, 0x00, totalSize * sizeof(double));
    }

    double *YITemp = _pInYI;
    if (YITemp == NULL)
    {
        YITemp = (double *)malloc(totalSize * sizeof(double));
        memset(YITemp, 0x00, totalSize * sizeof(double));
    }
    
    for (int iIndex1 = 0; iIndex1 < _iSize; iIndex1++)
    {
        for (int iIndex2 = 0; iIndex2 < _iSize; iIndex2++)
        {
            double a = _pInX[iIndex2] + _pInY[iIndex1];
            double b = XITemp[iIndex2] + YITemp[iIndex1];

            if (a == 0 && b != 0)
            {
                _pDataImg[iIndex1 * _iSize + iIndex2] = 1 / b;
                _pData[iIndex1 * _iSize + iIndex2] = 0;
            }
            else if (a != 0 && b == 0)
            {
                _pData[iIndex1 * _iSize + iIndex2] = 1 / a;
                _pDataImg[iIndex1 * _iSize + iIndex2] = 0;
            }
            else
            {
                double d = pow(a, 2) + pow(b, 2);
                _pData[iIndex1 * _iSize + iIndex2] = a / d;
                _pDataImg[iIndex1 * _iSize + iIndex2] = -b / d;
            }        
        }
    }

    if (_pInXI == NULL)
    {
        free(XITemp);
    }

    if (_pInYI == NULL)
    {
        free(YITemp);
    }
}

void ris_matrix(int _iSize, double *_pData)
{
    if (_iSize == 1)
    {
        _pData[0] = 1;
        return;
    }

    for (int i = 0; i < _iSize; i++)
    {
        for (int j = 0; j < _iSize; j++)
        {
            _pData[i * _iSize + j] = 0.5/(_iSize - (i + 1) - (j + 1) + 1.5);
        }
    }
}

void minij_moler_matrix(int _iSize, double dblV, double *_pData)
{
    if (_iSize == 1)
    {
        _pData[0] = 1;
        return;
    }

    double dblVal = 1.0;
    for (int i = 0; i < _iSize; i++)
    {
        _pData[i * _iSize + i] = dblVal;
        double dblD = dblVal - dblV;
        for (int j = i+1; j < _iSize; j++)
        {
            _pData[i * _iSize + j] = dblD;
            _pData[j * _iSize + i] = dblD;
        }
        dblVal++;
    }
}

