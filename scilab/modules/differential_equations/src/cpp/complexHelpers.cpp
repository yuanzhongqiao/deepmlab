/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2021 - 2023 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "complexHelpers.hxx"

void copyRealImgToComplexVector(double *pdblReal, double *pdblImg, double *pdblComplexVector, int iSize, bool bComplex)
{
    int iTwo = 2;
    int iOne = 1;
    double ZERO = 0.;

    if (bComplex)
    {
        C2F(dcopy)(&iSize, pdblReal, &iOne, pdblComplexVector, &iTwo);
        if (pdblImg != NULL)
        {
            C2F(dcopy)(&iSize, pdblImg, &iOne, pdblComplexVector+1, &iTwo);
        }
        else
        {
            C2F(dset)(&iSize, &ZERO, pdblComplexVector+1, &iTwo);
        }
    }
    else
    {
        C2F(dcopy)(&iSize, pdblReal, &iOne, pdblComplexVector, &iOne);
    }
}

void copyComplexVectorToRealImg(double *pdblRealState, types::Double *pDbl, int iPos, int iRealSize)
{
    int iTwo = 2;
    int iOne = 1;
    int iSize = pDbl->isComplex() ? iRealSize/2 : iRealSize;
    int iShift = iPos*iSize;
    if  (pDbl->isComplex())
    {
        C2F(dcopy)(&iSize, pdblRealState, &iTwo, pDbl->getReal()+iShift, &iOne);
        C2F(dcopy)(&iSize, pdblRealState+1, &iTwo, pDbl->getImg()+iShift, &iOne);
    }
    else
    {
        C2F(dcopy)(&iSize, pdblRealState, &iOne, pDbl->getReal()+iShift, &iOne);
    }
}

void copyComplexVectorToDouble(double *pdblRealState, double *pdblReal, double *pdblImg, int iSize, bool bComplex)
{
    int iTwo = 2;
    int iOne = 1;
    if  (bComplex)
    {
        C2F(dcopy)(&iSize, pdblRealState, &iTwo, pdblReal, &iOne);
        C2F(dcopy)(&iSize, pdblRealState+1, &iTwo, pdblImg, &iOne);
    }
    else
    {
        C2F(dcopy)(&iSize, pdblRealState, &iOne, pdblReal, &iOne);
    }
}

void copyMatrixToSUNMatrix(types::InternalType *pI, SUNMatrix SUNMat_J, int iDim, bool bComplex)
{
    char errorMsg[256] = "";
    int iRealDim = 2*iDim;
    // Handle copy in SUNMatrix object
    if (pI->isDouble() && SUNMatGetID(SUNMat_J) == SUNMATRIX_DENSE)
    {
        types::Double *pDblIn = pI->getAs<types::Double>();
        double *pdblReal = pDblIn->get();
        if (bComplex)
        {
            double *pdblImg = pDblIn->getImg();
            double *pdblJ = SM_DATA_D(SUNMat_J);
            // Actual internal matrix is composed of blocks
            //  | Re(a_ij) -Im(a_ij) |
            //  | Im(a_ij)  Re(a_ij) |
            // where A can be F'(z) or mass matrix.
            // Note: F'(z) or mass can be real even if solution is complex
            if (pdblImg != NULL)
            {
                for (int j=0; j<iDim; j++)
                {
                    for (int i=0; i<iDim; i++)
                    {
                        pdblJ[0] = pdblReal[0];
                        pdblJ[1] = pdblImg[0];
                        pdblJ[iRealDim] = -pdblImg[0];
                        pdblJ[iRealDim+1] = pdblReal[0];
                        pdblJ += 2;
                        pdblReal++;
                        pdblImg++;
                    }
                    pdblJ += iRealDim;
                }
            }
            else
            {
                for (int j=0; j<iDim; j++)
                {
                    for (int i=0; i<iDim; i++)
                    {
                        pdblJ[0] = pdblReal[0];
                        pdblJ[1] = 0.0;
                        pdblJ[iRealDim] = 0.0;
                        pdblJ[iRealDim+1] = pdblReal[0];
                        pdblJ += 2;
                        pdblReal++;
                    }
                    pdblJ += iRealDim;
                }
            }
        }
        else
        {
            std::copy(pdblReal, pdblReal+pDblIn->getSize(), SM_DATA_D(SUNMat_J));
        }
    }
    else if (pI->isDouble() && SUNMatGetID(SUNMat_J) == SUNMATRIX_BAND)
    {
        types::Double *pDblIn = pI->getAs<types::Double>();
        int iRows = pDblIn->getRows(); // should be SM_UBAND_B(SUNMat_J)+SM_LBAND_B(SUNMat_J)+1
        double *pdblReal = pDblIn->get();
        if (bComplex)
        {
            double *pdblImg = pDblIn->getImg();
            double *pdblJeven = NULL;
            double *pdblJodd = NULL;
            if (pdblImg != NULL)
            {
                for (int j=0; j < iDim; j++)
                {
                    pdblJeven = SUNBandMatrix_Column(SUNMat_J,2*j)-SM_UBAND_B(SUNMat_J);
                    pdblJodd = SUNBandMatrix_Column(SUNMat_J,2*j+1)-SM_UBAND_B(SUNMat_J);
                    for (int i=0; i<iRows; i++)
                    {
                        pdblJeven[1] = pdblReal[0];
                        pdblJeven[2] = pdblImg[0];
                        pdblJodd[0] = -pdblImg[0];
                        pdblJodd[1] = pdblReal[0];
                        pdblJeven += 2;
                        pdblJodd += 2;
                        pdblReal++;
                        pdblImg++;
                    }
                }
            }
            else
            {
                for (int j=0; j < iDim; j++)
                {
                    pdblJeven = SUNBandMatrix_Column(SUNMat_J,2*j)-SM_UBAND_B(SUNMat_J);
                    pdblJodd = SUNBandMatrix_Column(SUNMat_J,2*j+1)-SM_UBAND_B(SUNMat_J);
                    for (int i=0; i<iRows; i++)
                    {
                        pdblJeven[1] = pdblReal[0];
                        pdblJeven[2] = 0.0;
                        pdblJodd[0] = 0.0;
                        pdblJodd[1] = pdblReal[0];
                        pdblJeven += 2;
                        pdblJodd += 2;
                        pdblReal++;
                    }
                }
            }
        }
        else
        {
            for (int j=0; j < iDim; j++)
            {
                std::copy(pdblReal, pdblReal+iRows, SUNBandMatrix_Column(SUNMat_J,j)-SM_UBAND_B(SUNMat_J));
                pdblReal += iRows;
            }
        }
    }
    else if (pI->isSparse() && SUNMatGetID(SUNMat_J) == SUNMATRIX_SPARSE && SM_SPARSETYPE_S(SUNMat_J) == CSR_MAT)
    {
        // Scilab format is CSR (compressed rows)
        types::Sparse *pSp = pI->getAs<types::Sparse>();
        int iNbRows = pSp->getRows();
        if (bComplex)
        {
            sunindextype *piColIndexSUNMAT = SM_INDEXVALS_S(SUNMat_J); // column indexes of values
            sunindextype *piRowStartIndexSUNMAT = SM_INDEXPTRS_S(SUNMat_J); // index of first value of each row in values vector
            double *pdblSUNValues = SM_DATA_S(SUNMat_J); // values
            piRowStartIndexSUNMAT[0] = 0;
            if (pSp->isComplex())
            {
                int *piColIndex = pSp->matrixCplx->innerIndexPtr();
                int *piRowStartIndex = pSp->matrixCplx->outerIndexPtr();
                std::complex<double> *pcplx = pSp->matrixCplx->valuePtr();
                for (int i=0; i<iNbRows; i++)
                {
                    int iNbTermsInRow = piRowStartIndex[i+1]-piRowStartIndex[i];
                    if (iNbTermsInRow > 0)
                    {
                        for (int k=piRowStartIndex[i]; k<piRowStartIndex[i+1]; k++)
                        {
                            pdblSUNValues[0]               =  pcplx[0].real();
                            pdblSUNValues[1]               = -pcplx[0].imag();
                            pdblSUNValues[2*iNbTermsInRow]   =  pcplx[0].imag();
                            pdblSUNValues[2*iNbTermsInRow+1] =  pcplx[0].real();
                            piColIndexSUNMAT[0] = 2*piColIndex[0];
                            piColIndexSUNMAT[1] = 2*piColIndex[0]+1;
                            piColIndexSUNMAT[2*iNbTermsInRow] = 2*piColIndex[0];
                            piColIndexSUNMAT[2*iNbTermsInRow+1] = 2*piColIndex[0]+1;
                            pdblSUNValues += 2;
                            piColIndexSUNMAT += 2;
                            pcplx++;
                            piColIndex++;
                        }
                        piRowStartIndexSUNMAT[2*i+1] = piRowStartIndexSUNMAT[2*i]+2*iNbTermsInRow;
                        piRowStartIndexSUNMAT[2*i+2] = piRowStartIndexSUNMAT[2*i]+4*iNbTermsInRow;
                        pdblSUNValues += 2*iNbTermsInRow;
                        piColIndexSUNMAT += 2*iNbTermsInRow;
                    }
                }
            }
            else
            {
                int *piColIndex = pSp->matrixReal->innerIndexPtr();
                int *piRowStartIndex = pSp->matrixReal->outerIndexPtr();
                double *pdbl = pSp->matrixReal->valuePtr();
                for (int i=0; i<iNbRows; i++)
                {
                    int iNbTermsInRow = piRowStartIndex[i+1]-piRowStartIndex[i];
                    if (iNbTermsInRow > 0)
                    {
                        for (int k=piRowStartIndex[i]; k<piRowStartIndex[i+1]; k++)
                        {
                            //TODO: don't store zeros !
                            pdblSUNValues[0]                 =  pdbl[0];
                            pdblSUNValues[1]                 =  0.0;
                            pdblSUNValues[2*iNbTermsInRow]   =  0.0;
                            pdblSUNValues[2*iNbTermsInRow+1] =  pdbl[0];
                            piColIndexSUNMAT[0] = 2*piColIndex[0];
                            piColIndexSUNMAT[1] = 2*piColIndex[0]+1;
                            piColIndexSUNMAT[2*iNbTermsInRow] = 2*piColIndex[0];
                            piColIndexSUNMAT[2*iNbTermsInRow+1] = 2*piColIndex[0]+1;
                            pdblSUNValues += 2;
                            piColIndexSUNMAT += 2;
                            pdbl++;
                            piColIndex++;
                        }
                        piRowStartIndexSUNMAT[2*i+1] = piRowStartIndexSUNMAT[2*i]+2*iNbTermsInRow;
                        piRowStartIndexSUNMAT[2*i+2] = piRowStartIndexSUNMAT[2*i]+4*iNbTermsInRow;
                        pdblSUNValues += 2*iNbTermsInRow;
                        piColIndexSUNMAT += 2*iNbTermsInRow;
                    }
                }
            }
        }
        else
        {
            int *piColIndex = pSp->matrixReal->innerIndexPtr();
            int *piRowStartIndex = pSp->matrixReal->outerIndexPtr();
            sunindextype *piColIndexSUNMAT = SM_INDEXVALS_S(SUNMat_J); // column indexes of values
            sunindextype *piRowStartIndexSUNMAT = SM_INDEXPTRS_S(SUNMat_J); // index of first value of each row in values vector
            double *pdblSUNValues = SM_DATA_S(SUNMat_J); // values
            double *pdbl = pSp->matrixReal->valuePtr();
            for (int i=0; i<iNbRows; i++)
            {
                int iNbTermsInRow = piRowStartIndex[i+1]-piRowStartIndex[i];
                if (iNbTermsInRow > 0)
                {
                    for (int k=piRowStartIndex[i]; k<piRowStartIndex[i+1]; k++)
                    {
                        *(pdblSUNValues++) =  *(pdbl++);
                        *(piColIndexSUNMAT++) = *(piColIndex++);
                    }
                }
                piRowStartIndexSUNMAT[i+1] = piRowStartIndexSUNMAT[i]+iNbTermsInRow;
            }
        }
    }
    else
    {
        sprintf(errorMsg, _("Incompatible SUNMATRIX type in copyMatrixToSUNMatrix.\n"));
        throw ast::InternalError(errorMsg);
    }
}
