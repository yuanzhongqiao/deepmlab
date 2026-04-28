/*
*  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*  Copyright (C) 2008-2008 - DIGITEO - Antoine ELIAS
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
#ifndef __TYPES_MULTIPLICATION_HXX__
#define __TYPES_MULTIPLICATION_HXX__

#include "generic_operations.hxx"
#include "double.hxx"
#include "polynom.hxx"
#include "sparse.hxx"

void fillIntMulFunction();
typedef types::InternalType* (*intmul_function)(types::InternalType*, types::InternalType*);

#define DECLARE_INTMUL_PROTO(x) template<class T, class U, class O> \
types::InternalType* x(T* _pL, U* _pR)
DECLARE_INTMUL_PROTO(intmul_M_M);
DECLARE_INTMUL_PROTO(intmul_S_S);
DECLARE_INTMUL_PROTO(intmul_M_S);
DECLARE_INTMUL_PROTO(intmul_S_M);


int MultiplyDoubleByDouble(types::Double* _pDouble1, types::Double* _pDouble2, types::Double** _pDoubleOut);
int MultiplyDoubleByPoly(types::Double* _pDouble, types::Polynom* _pPoly, types::Polynom** _pPolyOut);
int MultiplyPolyByDouble(types::Polynom* _pPoly, types::Double* _pDouble, types::Polynom **_pPolyOut);
int MultiplyPolyByPoly(types::Polynom* _pPoly1, types::Polynom* _pPoly2, types::Polynom** _pPolyOut);

int MultiplySparseBySparse(types::Sparse* _pSparse1, types::Sparse* _pSparse2, types::Sparse** _pSparseOut);
int MultiplyDoubleBySparse(types::Double* _pDouble, types::Sparse *_pSparse, types::GenericType** _pDoubleOut);
int MultiplySparseByDouble(types::Sparse *_pSparse, types::Double*_pDouble, types::GenericType** _pDoubleOut);

#endif /* __TYPES_MULTIPLICATION_HXX__ */
