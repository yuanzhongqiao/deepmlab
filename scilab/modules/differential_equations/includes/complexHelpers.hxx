//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _COMPLEXHELPERS_HXX_
#define _COMPLEXHELPERS_HXX_

#include "dynlib_differential_equations.h"

#include "double.hxx"
#include "sparse.hxx"

extern "C"
{
    void C2F(dset)(int*, double*, double*, int*);
    void C2F(dcopy)(int*, const double*, const int*, double*, const int*);
    void C2F(dscal)(int*, const double*, double*, const int*);
    void C2F(dlacpy)(char*, int*, int*, double*, int*, double*, int*);
    void C2F(daxpy)(int*, double*, double*, int*, double*, int*);
    double C2F(ddot)(int*, double*, int*, double*, int*);
}
#include <sunmatrix/sunmatrix_band.h>   /* access to band SUNmatrix       */
#include <sunmatrix/sunmatrix_dense.h>  /* access to dense SUNmatrix       */
#include <sunmatrix/sunmatrix_sparse.h> /* access to band SUNmatrix       */
#include <Eigen/Sparse>

DIFFERENTIAL_EQUATIONS_IMPEXP void copyRealImgToComplexVector(double* pdblReal, double* pdblImg, double* pdblComplexVector, int iSize, bool bComplex);
DIFFERENTIAL_EQUATIONS_IMPEXP void copyComplexVectorToRealImg(double* pdblRealState, types::Double *pDbl, int iPos, int iSize);
DIFFERENTIAL_EQUATIONS_IMPEXP void copyComplexVectorToDouble(double* pdblRealState, double* pdblReal, double* pdblImg, int iSize, bool bComplex);
DIFFERENTIAL_EQUATIONS_IMPEXP void copyMatrixToSUNMatrix(types::InternalType* pI, SUNMatrix SUNMat_J, int iDim, bool bComplex);

#endif
