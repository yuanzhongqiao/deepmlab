//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "differential_equations_gw.hxx"

#include "function.hxx"
#include "double.hxx"
#include "string.hxx"
#include "list.hxx"
#include "mlist.hxx"
#include "pointer.hxx"
#include "OdeManager.hxx"
#include "complexHelpers.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
#include "sci_malloc.h"
extern void C2F(dgemv)(const char *trans, int *m, int *n,
                          const double *alpha, const double *a, int *lda,
                          const double *x, int *inc_x, const double *beta,
                          double *y, int *inc_y);
}

types::Function::ReturnValue sci_percent_odeSolution_clear(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    OdeManager *manager = NULL;
    char errorMsg[256];

    if (in.size() == 1)
    {
        if (in[0]->isMList())
        {
            types::InternalType *pI;
            types::MList *pObj = in[0]->getAs<types::MList>();
            if (pObj->extract(L"manager", pI) && pI->isPointer())
            {
                manager = static_cast<OdeManager *>(pI->getAs<types::Pointer>()->get());
                if (manager != NULL)
                {
                    delete manager;
                }
            }
        }
        else
        {
            sprintf(errorMsg, _("%s: Wrong type for argument #1.\n"), "%_odeSoutionc_clear");
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        sprintf(errorMsg, _("%s: Wrong number of input arguments.\n"), "%_odeSoutionc_clear");
        throw ast::InternalError(errorMsg);
    }

    return types::Function::OK;
}

types::Function::ReturnValue sci_percent_odeSolution_e(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    OdeManager *manager = NULL;
    types::Double *pDblYOut = NULL;
    types::Double *pDblYDOut = NULL;
    types::Double *pDblIndex = NULL;
    types::InternalType *pIn = NULL;

    double dblOne = 1.0;
    double dblZero = 0.0;
    double pdblVect[13];
    double pdblVectDer[13];
    double *pdblYOut;
    double *pdblYOutImg;
    double *pdblYDOut = nullptr;
    double *pdblYDOutImg = nullptr;
    int iNEq;
    int iNRealEq;
    int iNEqOut;
    bool bIsComplex;

    int iOne = 1;
    char pcharN[] = "N";

    if (in.size() >= 2)
    {
        if (in[in.size() - 1]->isMList())
        {
            types::InternalType *pI;
            types::MList *pObj = in[in.size() - 1]->getAs<types::MList>();
            if (pObj->extract(L"manager", pI) && pI->isPointer())
            {
                manager = static_cast<OdeManager *>(pI->getAs<types::Pointer>()->get());
                iNEq = manager->getNEq();
                iNRealEq = manager->getNRealEq();
                iNEqOut = iNEq;
                bIsComplex = manager->isComplex();
                in.pop_back();

                if (in.size() == 2)
                {
                    pIn = in[1];
                    if (in[1]->isImplicitList())
                    {
                        types::ImplicitList *pIL = in[1]->getAs<types::ImplicitList>();
                        if (pIL->isComputable())
                        {
                            pIn = pIL->extractFullMatrix();
                        }
                    }

                    if (pIn->isDouble() && pIn->getAs<types::Double>()->isComplex() == false)
                    {
                        pDblIndex = pIn->getAs<types::Double>();
                        for (int i = 0; i < pDblIndex->getSize(); i++)
                        {
                            if (pDblIndex->get(i) != std::floor(pDblIndex->get(i)) || pDblIndex->get(i) < 1 || pDblIndex->get(i) > iNEq)
                            {
                                Scierror(999, _("%s: Wrong value for input argument #%d: must be an integer between %d and %d.\n"), "%_odeSolution_e", 2, 1, iNEq);
                                return types::Function::Error;
                            }
                        }
                        iNEqOut = pDblIndex->getSize();
                    }
                    else
                    {
                        Scierror(999, _("%s: Wrong value for input argument #%d: must be an integer between %d and %d.\n"), "%_odeSolution_e", 2, 1, iNEq);
                        return types::Function::Error;
                    }
                }

                pIn = in[0];
                if (in[0]->isImplicitList())
                {
                    types::ImplicitList *pIL = in[0]->getAs<types::ImplicitList>();
                    if (pIL->isComputable())
                    {
                        pIn = pIL->extractFullMatrix();
                    }
                }

                if (pIn->isDouble() && pIn->getAs<types::Double>()->isComplex() == false)
                {
                    types::Double *pDblUserTSpan = pIn->getAs<types::Double>();
                    types::Double* pDblUserTOut = manager->getTOut();
                    double *pdblUserTSpan = pDblUserTSpan->get();
                    double *pdblTout = pDblUserTOut->get();
                    int iSizeUserTSpan = pDblUserTSpan->getSize();
                    int iSizeTout = pDblUserTOut->getSize();

                    if (*std::min_element(pdblUserTSpan, pdblUserTSpan + iSizeUserTSpan) < pdblTout[0]
                            || *std::max_element(pdblUserTSpan, pdblUserTSpan + iSizeUserTSpan) > pdblTout[iSizeTout - 1])
                    {
                        pDblUserTOut->killMe();
                        Scierror(999, _("%s: solution cannot be evaluated outside the interval [%g,%g].\n"), "%_odeSolution_e", pdblTout[0], pdblTout[iSizeTout - 1]);
                        return types::Function::Error;
                    }

                    if (iSizeTout > 1) // non degenerate case
                    {
                        pDblYOut = manager->createYOut(manager->getY0(), iNEqOut, iSizeUserTSpan, in.size() == 2);
                        // utility vecrot
                        double *pdblTemp = new double[iNRealEq];
                        
                        pdblYOut = pDblYOut->get();
                        pdblYOutImg = pDblYOut->getImg();
                        if (_iRetCount == 2) // derivative requested
                        {
                            pDblYDOut = manager->createYOut(manager->getY0(), iNEqOut, iSizeUserTSpan, in.size() == 2);
                            pdblYDOut = pDblYDOut->get();
                            pdblYDOutImg = pDblYDOut->getImg();
                        }
                        std::vector<double> dblSolverTime = manager->getCurrTimeVector();
                        std::vector<int> piIndexBasis = manager->getInterpBasisIndex();
                        int iBasisRows = manager->getInterpBasis()->getRows();
                        for (int i = 0; i < iSizeUserTSpan; i++)
                        {
                            //  locate user time values within method steps

                            double dblTUser = pDblUserTSpan->get(i);
                            double *pdblTime = std::lower_bound(pdblTout + 1, pdblTout + iSizeTout, dblTUser);
                            int iIndex = pdblTime - pdblTout;

                            // here (pdblTime[0] - pdblTime[-1]) and dblSolverTime[iIndex] - pdblTime[-1] differ when
                            // when pdblTime[0] is time of an event (we need actual solver step which is always larger).

                            int iBasisDimension =  manager->getBasisDimensionAtIndex(iIndex);

                            //  evaluation of interpolating polynomial is done by a matrix/vector multiplication.
                            // pdblBasis points to the matrix
                            // e.g. for CVODE columns of this matrix are the Nordsieck vectors

                            double *pdblBasis = manager->getBasisAtIndex(iIndex);

                            double dblt0 = dblSolverTime[iIndex]; // dblSolverTime starts at first successful step (not t0)
                            double dblStep = dblt0 - pdblTime[-1];

                            // get the vectors (one for y the second for y')
                            // e.g. for CVODE pdblVect = {1,s,s^2,...,s^q} where q is method order
                            manager->getInterpVectors(pdblBasis, iBasisDimension, iIndex, dblt0, dblTUser, dblStep, pdblVect, pdblVectDer);

                            if (in.size() == 1)
                            {
                                // Compute all components
                                if (pdblYOutImg == NULL)
                                {
                                    C2F(dgemv)(pcharN, &iNEq, &iBasisDimension, &dblOne, pdblBasis, &iBasisRows, pdblVect, &iOne, &dblZero, pdblYOut, &iOne);
                                }
                                else
                                {
                                    C2F(dgemv)(pcharN, &iNRealEq, &iBasisDimension, &dblOne, pdblBasis, &iBasisRows, pdblVect, &iOne, &dblZero, pdblTemp, &iOne);
                                    // the result of the product is a (re,im) interlaced vector, so deinterlace:
                                    copyComplexVectorToDouble(pdblTemp, pdblYOut, pdblYOutImg, iNEq, bIsComplex);
                                    pdblYOutImg += iNEqOut;
                                }
                                pdblYOut += iNEqOut;
                            }
                            else
                            {
                                // Compute only selected components
                                if (pdblYOutImg == NULL)
                                {
                                    for (int j = 0; j < iNEqOut; j++)
                                    {
                                        double *pdblStartRow = pdblBasis + (int)(pDblIndex->get(j) - 1);
                                        pdblYOut[j] = C2F(ddot)(&iBasisDimension, pdblStartRow, &iBasisRows, pdblVect, &iOne);
                                    }
                                }
                                else
                                {
                                    for (int j = 0; j < iNEqOut; j++)
                                    {
                                        // there is 2 lines for each component because of (re,im) interlacing
                                        double *pdblStartRow = pdblBasis + 2*(int)(pDblIndex->get(j) - 1);
                                        pdblYOut[j] = C2F(ddot)(&iBasisDimension, pdblStartRow, &iBasisRows, pdblVect, &iOne);
                                        pdblYOutImg[j] = C2F(ddot)(&iBasisDimension, pdblStartRow+1, &iBasisRows, pdblVect, &iOne);
                                    }
                                }
                                pdblYOut += iNEqOut;
                            }

                            if (_iRetCount == 2)
                            {
                                // Derivative of the solution has been requested
                                // Like above, the evaluation of interpolating polynomial is done by a matrix/vector multiplication.
                                // for CVODE pdblVectDer = {0,1,2*s,...,q*s^(q-1)} where q is method order
                                if (in.size() == 1)
                                {
                                    // Compute all components
                                    if (pdblYDOut != nullptr && pdblYDOutImg == nullptr)
                                    {
                                        C2F(dgemv)(pcharN, &iNEq, &iBasisDimension, &dblOne, pdblBasis, &iBasisRows, pdblVectDer, &iOne, &dblZero, pdblYDOut, &iOne);
                                    }
                                    else if(pdblYDOut != nullptr && pdblYDOutImg != nullptr)
                                    {
                                        C2F(dgemv)(pcharN, &iNRealEq, &iBasisDimension, &dblOne, pdblBasis, &iBasisRows, pdblVectDer, &iOne, &dblZero, pdblTemp, &iOne);
                                        // the result of the product is a (re,im) interlaced vector, so deinterlace:
                                        copyComplexVectorToDouble(pdblTemp, pdblYDOut, pdblYDOutImg, iNEqOut, bIsComplex);
                                        pdblYOutImg += iNEqOut;
                                    }
                                    pdblYDOut += iNEqOut;
                                }
                                else
                                {
                                    // Compute only selected components
                                    if (pdblYDOut != nullptr && pdblYDOutImg == nullptr)
                                    {
                                        for (int j = 0; j < iNEqOut; j++)
                                        {
                                            double *pdblStartRow = pdblBasis + (int)(pDblIndex->get(j) - 1);
                                            pdblYDOut[j] = C2F(ddot)(&iBasisDimension, pdblStartRow, &iBasisRows, pdblVectDer, &iOne);
                                        }
                                    }
                                    else if (pdblYDOut != nullptr && pdblYDOutImg != nullptr)
                                    {
                                        for (int j = 0; j < iNEqOut; j++)
                                        {
                                            // there is 2 lines for each component because of (re,im) interlacing
                                            double *pdblStartRow = pdblBasis + 2*(int)(pDblIndex->get(j) - 1);
                                            pdblYDOut[j] = C2F(ddot)(&iBasisDimension, pdblStartRow, &iBasisRows, pdblVectDer, &iOne);
                                            pdblYDOutImg[j] = C2F(ddot)(&iBasisDimension, pdblStartRow+1, &iBasisRows, pdblVectDer, &iOne);
                                        }
                                        pdblYDOutImg += iNEqOut;
                                    }
                                    pdblYDOut += iNEqOut;
                                }
                            }
                        }
                        delete[] pdblTemp;
                    }
                    else
                    {
                        // degenerate case, yield Y0 and eventualy f(T0,Y0)
                        if (in.size() == 1)
                        {
                            pDblYOut = manager->getY0()->clone();
                        }
                        else
                        {
                            // return only selected components
                            types::Double *pDblY0 = manager->getY0();
                            pDblYOut = new types::Double(iNEqOut, 1, pDblY0->isComplex());
                            for (int j = 0; j < iNEqOut; j++)
                            {
                                pDblYOut->set(j, pDblY0->get((int)(pDblIndex->get(j) - 1)));
                                if (pDblYOut->isComplex())
                                {
                                    pDblYOut->setImg(j, pDblY0->getImg((int)(pDblIndex->get(j) - 1)));
                                }
                            }
                        }
                        if (_iRetCount == 2)
                        {
                            // if (in.size() == 1)
                            // {
                            //     manager->computeFunction(pdblUserTSpan[0], manager->getY0()->get(), NULL, OdeManager::RHS, pdblYDOut);
                            // }
                            // else
                            // { // return only selected components
                            //     double *pdblF0 = new double(iNEq);
                            //     manager->computeFunction(pdblUserTSpan[0], manager->getY0()->get(), NULL, OdeManager::RHS, pdblF0);
                            //     for (int j=0; j < iNEqOut; j++)
                            //     {
                            //         pdblYDOut[j] = pdblF0[(int)(pDblIndex->get(j)-1)];
                            //     }
                            //     delete pdblF0;
                            // }
                            pDblYDOut = types::Double::Empty();
                        }
                    }

                    out.push_back(pDblYOut);
                    if (_iRetCount == 2)
                    {
                        out.push_back(pDblYDOut);
                    }
                    pDblUserTOut->killMe();
                }
                else
                {
                    Scierror(999, _("%s: Wrong type for input argument #%d: A real matrix expected.\n"), "_odeSolution_e", 1);
                    return types::Function::Error;
                }

                return types::Function::OK;
            }
            else
            {
                Scierror(999, _("%s: Wrong type for argument #1.\n"), "%_odeSolution_e");
                return types::Function::Error;
            }
        }
        else
        {
            Scierror(999, _("%s: Wrong type for argument #1.\n"), "%_odeSolution_e");
            return types::Function::Error;
        }
    }
    else
    {
        Scierror(999, _("%s: Wrong number of input arguments.\n"), "%_odeSolution_e");
        return types::Function::Error;
    }
    return types::Function::OK;
}
