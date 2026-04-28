//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020-2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "spCompGeneric.hxx"
#include "ColPackHeaders.h"
#include "Eigen/Sparse"
#include "configvariable.hxx"
#include "function.hxx"
#include "string.hxx"
#include "commentexp.hxx"

#define COLPACK_DELETE(p) \
    if (p != NULL)        \
    delete[] p

spCompGeneric::spCompGeneric(const std::wstring& callerName)
{
    m_wstrCaller = callerName;
    m_pstrCaller = wide_string_to_UTF8(callerName.c_str());
}

spCompGeneric::~spCompGeneric()
{

    //delete matrices in Colpack CSR format
    if (m_ppuiSparsityPattern != NULL)
    {
        free_2DMatrix(m_ppuiSparsityPattern, m_iNbRows);
    }
    if (m_ppdblProd != NULL)
    {
        free_2DMatrix(m_ppdblProd, m_iNbRows);
    }
    //delete[] if != NULL

    COLPACK_DELETE(m_pCallFunctionName);
    COLPACK_DELETE(m_pstrCaller);
    COLPACK_DELETE(m_pdblStep);
    COLPACK_DELETE(m_piRowBeginIndex);
    COLPACK_DELETE(m_piValueColIndex);
    COLPACK_DELETE(m_pdblValues);

    if (m_pDblRelStep != NULL)
    {
        m_pDblRelStep->killMe();
    }
    if (m_pDblTypicalX != NULL)
    {
        m_pDblTypicalX->killMe();
    }
}

std::string spCompGeneric::getOrdering()
{
    return orderingAsString[m_ordering];
}
std::string spCompGeneric::getColoring()
{
    return coloringAsString[m_coloring];
}

bool spCompGeneric::setComputeParameters(types::typed_list& in, types::optional_list& opt, bool bSym)
{
    int* piValueColIndex;
    int* piRowBeginIndex;

    if (in[0]->isCallable())
    {
        m_pCallFunction = in[0]->getAs<types::Callable>();
        m_pCallFunctionName = wide_string_to_UTF8(m_pCallFunction->getName().c_str());
    }
    else
    {
        Scierror(999, _("%s: parameter %d should be a function.\n"), m_pstrCaller, 1);
        return false;
    }

    if (in[1]->isSparse())
    {
        types::Sparse* pSpPattern = in[1]->getAs<types::Sparse>();
        types::Sparse::RealSparse_t* psp = pSpPattern->matrixReal;
        m_iNbRows = pSpPattern->getRows();
        m_iNbVars = pSpPattern->getCols();
        m_iNonZeros = (int)pSpPattern->nonZeros();
        piValueColIndex = psp->innerIndexPtr(); // column index of values
        piRowBeginIndex = psp->outerIndexPtr(); // index of each row begining in values vector
    }
    else if (in[1]->isSparseBool())
    {
        types::SparseBool* pSpBoolPattern = in[1]->getAs<types::SparseBool>();
        types::SparseBool::BoolSparse_t* pspb = pSpBoolPattern->matrixBool;
        m_iNbRows = pSpBoolPattern->getRows();
        m_iNbVars = pSpBoolPattern->getCols();
        m_iNonZeros = (int)pSpBoolPattern->nbTrue();
        piValueColIndex = pspb->innerIndexPtr(); // column index of values
        piRowBeginIndex = pspb->outerIndexPtr(); // index of each row begining in values vector
    }
    else
    {
        Scierror(999, _("%s: Wrong type for input argument #%d : A sparse matrix expected.\n"), m_pstrCaller);
        return false;
    }
    if (bSym)
    {
        if (m_iNbRows != m_iNbVars)
        {
            Scierror(999, _("%s: Argument #%d must be a square matrix.\n"), m_pstrCaller);
            return false;
        }
        // Check if pattern is symmetric
        int iValueIndex = 0;
        
        std::vector<int> index;
        index.reserve(m_iNonZeros);
        for (int i = 0; i < m_iNbRows; i++)
        {
            // we assume that matrix is in Eigen compressed row format
            for (int k = 0; k < piRowBeginIndex[i + 1] - piRowBeginIndex[i]; k++)
            {
                int j = piValueColIndex[iValueIndex++];
                // add linear index of equivalent lower off-diagonal term
                if (i != j)
                {
                    index.push_back(std::max(i, j) + std::min(i, j) * m_iNbVars);
                }
            }
        }
        std::unordered_set<int> uniqueIndex(index.begin(), index.end());

        // Each linear index should occur twice if matrix is symmetric
        if (index.size() != 2 * uniqueIndex.size())
        {
            Scierror(999, _("%s: Argument #%d must be a symmetric matrix.\n"), m_pstrCaller);
            return false;
        }
    }

    if (opt.size() > 0)
    {
        if (opt.find(L"Vectorized") != opt.end())
        {
            types::InternalType* pI = opt[L"Vectorized"];
            if (pI->isString() && pI->getAs<types::String>()->isScalar())
            {
                std::wstring pStr = pI->getAs<types::String>()->get(0);
                std::transform(pStr.begin(), pStr.end(), pStr.begin(), ::toupper);
                if (pStr == L"ON")
                {
                    m_bVectorized = true;
                }
                else if (pStr == L"OFF")
                {
                    m_bVectorized = false;
                }
                else
                {
                    Scierror(999, _("%s: wrong value for \"Vectorized\" options. Expected values are \"on\" or \"off\".\n"), m_pstrCaller);
                    return false;
                }
            }
            else
            {
                Scierror(999, _("%s: wrong value type for \"Vectorized\" option. A scalar string is expected.\n"), m_pstrCaller);
                return false;
            }
        }
        if (bSym == true) // Hessian
        {
            if (opt.find(L"Coloring") != opt.end())
            {
                types::InternalType* pI = opt[L"Coloring"];
                if (pI->isString() && pI->getAs<types::String>()->isScalar())
                {
                    std::wstring pStr = pI->getAs<types::String>()->get(0);
                    std::transform(pStr.begin(), pStr.end(), pStr.begin(), ::toupper);
                    for (auto col : {DISTANCE_TWO, STAR, RESTRICTED_STAR, ACYCLIC_FOR_INDIRECT_RECOVERY, INVALID_COLORING})
                    {
                        m_coloring = col;
                        if (pStr == coloringAsWString[col])
                        {
                            break;
                        }
                    }
                    if (m_coloring == INVALID_COLORING)
                    {
                        Scierror(999, _("%s: wrong value for \"Coloring\" option. Expected values are \"DISTANCE_TWO\", \"STAR\", \"RESTRICTED_STAR\" or  \"ACYCLIC_FOR_INDIRECT_RECOVERY\".\n"), m_pstrCaller);
                        return false;
                    }
                }
                else
                {
                    Scierror(999, _("%s: wrong value type for \"Coloring\" options. A scalar string is expected.\n"), m_pstrCaller);
                    return false;
                }
            }
            if (opt.find(L"Ordering") != opt.end())
            {
                types::InternalType* pI = opt[L"Ordering"];
                if (pI->isString() && pI->getAs<types::String>()->isScalar())
                {
                    std::wstring pStr = pI->getAs<types::String>()->get(0);
                    std::transform(pStr.begin(), pStr.end(), pStr.begin(), ::toupper);
                    for (auto ord : {NATURAL, LARGEST_FIRST, DYNAMIC_LARGEST_FIRST, DISTANCE_TWO_LARGEST_FIRST, SMALLEST_LAST,
                                     DISTANCE_TWO_SMALLEST_LAST, INCIDENCE_DEGREE, DISTANCE_TWO_INCIDENCE_DEGREE, RANDOM, INVALID_ORDERING})
                    {
                        m_ordering = ord;
                        if (pStr == orderingAsWString[ord])
                        {
                            break;
                        }
                    }
                    if (m_ordering == INVALID_ORDERING)
                    {
                        Scierror(999, _("%s:  wrong value for \"Ordering\" option. Expected values are \"NATURAL\", \"LARGEST_FIRST\", \"DYNAMIC_LARGEST_FIRST\", \"DISTANCE_TWO_LARGEST_FIRST\","
                                        " \"SMALLEST_LAST\", \"DISTANCE_TWO_SMALLEST_LAST\" ,\"INCIDENCE_DEGREE\", \"DISTANCE_TWO_INCIDENCE_DEGREE\" or \"RANDOM\".\n"),
                                 m_pstrCaller);
                        return false;
                    }
                }
                else
                {
                    Scierror(999, _("%s: wrong value type for \"Ordering\" option. A scalar string is expected.\n"), m_pstrCaller);
                    return false;
                }
            }
        }
        else // General Jacobian
        {
            if (opt.find(L"Coloring") != opt.end())
            {
                types::InternalType* pI = opt[L"Coloring"];
                if (pI->isString() && pI->getAs<types::String>()->isScalar())
                {
                    std::wstring pStr = pI->getAs<types::String>()->get(0);
                    std::transform(pStr.begin(), pStr.end(), pStr.begin(), ::toupper);
                    if (pStr == coloringAsWString[COLUMN_PARTIAL_DISTANCE_TWO])
                    {
                        m_coloring = COLUMN_PARTIAL_DISTANCE_TWO;
                    }
                    else
                    {
                        Scierror(999, _("%s: wrong value for \"Coloring\" option. Expected value is \"COLUMN_PARTIAL_DISTANCE_TWO\".\n"), m_pstrCaller);
                        return false;
                    }
                }
                else
                {
                    Scierror(999, _("%s: wrong value type for \"Coloring\" option. A scalar string is expected.\n"), m_pstrCaller);
                    return false;
                }
            }
            if (opt.find(L"Ordering") != opt.end())
            {
                types::InternalType* pI = opt[L"Ordering"];
                if (pI->isString() && pI->getAs<types::String>()->isScalar())
                {
                    std::wstring pStr = pI->getAs<types::String>()->get(0);
                    std::transform(pStr.begin(), pStr.end(), pStr.begin(), ::toupper);
                    for (auto ord : {NATURAL, LARGEST_FIRST, SMALLEST_LAST, INCIDENCE_DEGREE, RANDOM, INVALID_ORDERING})
                    {
                        m_ordering = ord;
                        if (pStr == orderingAsWString[ord])
                        {
                            break;
                        }
                    }
                    if (m_ordering == INVALID_ORDERING)
                    {
                        Scierror(999, _("%s: wrong value for \"Ordering\" option. Expected values are \"NATURAL\", \"LARGEST_FIRST\","
                                        " \"SMALLEST_LAST\" ,\"INCIDENCE_DEGREE\" or \"RANDOM\".\n"),
                                 m_pstrCaller);
                        return false;
                    }
                }
                else
                {
                    Scierror(999, _("%s: wrong value type for \"Ordering\" option. A scalar string is expected.\n"), m_pstrCaller);
                    return false;
                }
            }
        }
        if (opt.find(L"FiniteDifferenceType") != opt.end())
        {
            types::InternalType* pI = opt[L"FiniteDifferenceType"];
            if (pI->isString() && pI->getAs<types::String>()->isScalar())
            {
                std::wstring pStr = pI->getAs<types::String>()->get(0);
                std::transform(pStr.begin(), pStr.end(), pStr.begin(), ::toupper);
                if (pStr == L"FORWARD")
                {
                    m_scheme = FORWARD;
                }
                else if (pStr == L"CENTERED" || pStr == L"CENTRAL")
                {
                    m_scheme = CENTERED;
                }
                else if (pStr == L"COMPLEXSTEP")
                {
                    m_scheme = COMPLEXSTEP;
                }
                else
                {
                    Scierror(999, _("%s: wrong value for \"FiniteDifferenceType\" option. Expected values are \"FORWARD\", \"CENTERED\", \"CENTRAL\" or \"COMPLEXSTEP\".\n"), m_pstrCaller);
                    return false;
                }
            }
            else
            {
                Scierror(999, _("%s: wrong value type for \"FiniteDifferenceType\" option. A scalar string is expected.\n"), m_pstrCaller);
                return false;
            }
        }
        if (opt.find(L"FiniteDifferenceStepSize") != opt.end())
        {
            types::InternalType* pI = opt[L"FiniteDifferenceStepSize"];
            if (pI->isDouble() && pI->getAs<types::Double>()->isComplex() == false)
            {
                types::Double* pDbl = pI->getAs<types::Double>();
                if (pDbl->isScalar())
                {
                    m_pDblRelStep = new types::Double(m_iNbVars, 1);
                    std::fill(m_pDblRelStep->get(), m_pDblRelStep->get() + m_iNbVars, pDbl->get(0));
                }
                else if (pDbl->getSize() == m_iNbVars)
                {
                    m_pDblRelStep = pDbl->clone();
                }
                else
                {
                    Scierror(999, _("%s: wrong value type for \"FiniteDifferenceStepSize\" option. A vector of length %d is expected.\n"), m_pstrCaller, m_iNbVars);
                    return false;
                }
            }
            else
            {
                Scierror(999, _("%s: wrong value type for \"FiniteDifferenceStepSize\" option. A scalar or a real vector is expected.\n"), m_pstrCaller);
                return false;
            }
        }
        if (opt.find(L"TypicalX") != opt.end())
        {
            types::InternalType* pI = opt[L"TypicalX"];
            if (pI->isDouble() && pI->getAs<types::Double>()->isComplex() == false)
            {
                types::Double* pDbl = pI->getAs<types::Double>();
                if (pDbl->isScalar())
                {
                    m_pDblTypicalX = new types::Double(m_iNbVars, 1);
                    std::fill(m_pDblTypicalX->get(), m_pDblTypicalX->get() + m_iNbVars, pDbl->get(0));
                }
                else if (pDbl->getSize() == m_iNbVars)
                {
                    m_pDblTypicalX = pDbl->clone();
                }
                else
                {
                    Scierror(999, _("%s: wrong value type for \"TypicalX\" option. A vector of length %d is expected.\n"), m_pstrCaller, m_iNbVars);
                    return false;
                }
            }
            else
            {
                Scierror(999, _("%s: wrong value type for \"TypicalX\" option. A scalar or a real vector is expected.\n"), m_pstrCaller);
                return false;
            }
        }
    }

    if (m_pDblRelStep == NULL)
    {
        //default relative step,
        m_pDblRelStep = new types::Double(m_iNbVars, 1);
        if (m_scheme == FORWARD)
        {
            std::fill(m_pDblRelStep->get(), m_pDblRelStep->get() + m_iNbVars, std::pow(2.0, -26.0));
        }
        else if (m_scheme == CENTERED)
        {
            std::fill(m_pDblRelStep->get(), m_pDblRelStep->get() + m_iNbVars, std::pow(2.0, -17.0));
        }
        else if (m_scheme == COMPLEXSTEP)
        {
            std::fill(m_pDblRelStep->get(), m_pDblRelStep->get() + m_iNbVars, std::pow(2.0, -332.0));
        }
    }

    if (m_pDblTypicalX == NULL)
    {
        //default typical X, ones
        m_pDblTypicalX = new types::Double(m_iNbVars, 1);
        std::fill(m_pDblTypicalX->get(), m_pDblTypicalX->get() + m_iNbVars, 1.0);
    }

    //allocate vectors
    m_pdblStep = new double[std::max(m_iNbVars,m_iNbRows)];
    if (m_iNbRows > m_iNbVars)
    {
        // eventual extra terms (ones) in m_pdblStep are used only to allow the same row/col rescaling
        // after ColPack recovery for Hessian or Jacobian
        std::fill(m_pdblStep+m_iNbVars,m_pdblStep+m_iNbRows,1.0);
    }
    m_pdblValues = new double[m_iNonZeros];

    setPattern(in[1]);

    return true;
}

void spCompGeneric::setPattern(types::InternalType* pI)
{
    if (pI->isSparse())
    {
        types::Sparse* pSpPattern = pI->getAs<types::Sparse>();
        types::Sparse::RealSparse_t* psp = pSpPattern->matrixReal;
        setPattern(psp->outerIndexPtr(), psp->innerIndexPtr(), pSpPattern->getRows(), (int)pSpPattern->nonZeros());
        // not redundant when setPattern is called from external library:
        m_iNbRows = pSpPattern->getRows();
        m_iNbVars = pSpPattern->getCols();
    }
    else if (pI->isSparseBool())
    {
        types::SparseBool* pSpBoolPattern = pI->getAs<types::SparseBool>();
        types::SparseBool::BoolSparse_t* pspb = pSpBoolPattern->matrixBool;
        setPattern(pspb->outerIndexPtr(), pspb->innerIndexPtr(), pSpBoolPattern->getRows(), (int)pSpBoolPattern->nbTrue());
        // not redundant when setPattern is called from external library:
        m_iNbRows = pSpBoolPattern->getRows();
        m_iNbVars = pSpBoolPattern->getCols();
    }
}

void spCompGeneric::setPattern(int* piRowBeginIndex, int* piValueColIndex, int iRows, int iNonZeros)
{
    //copy inner and outer vectors of sparsity pattern for later use (recovery)
    m_piRowBeginIndex = new int[iRows + 1];
    m_piValueColIndex = new int[iNonZeros];
    memcpy(m_piRowBeginIndex, piRowBeginIndex, sizeof(int) * (iRows + 1));
    memcpy(m_piValueColIndex, piValueColIndex, sizeof(int) * iNonZeros);

    //convert sparsity pattern of user matrix to internal ColPack compressed row format:
    m_ppuiSparsityPattern = new unsigned int*[iRows];
    int iValueIndex = 0;
    int iNonZerosInRow = 0;
    for (int i = 1; i < iRows + 1; i++)
    {
        iNonZerosInRow = m_piRowBeginIndex[i] - m_piRowBeginIndex[i - 1]; // we assume that matrix is in Eigen compressed row format
        m_ppuiSparsityPattern[i - 1] = new unsigned int[iNonZerosInRow + 1];
        m_ppuiSparsityPattern[i - 1][0] = iNonZerosInRow; // 0-index term holds the number of terms in row
        for (int j = 0; j < iNonZerosInRow; j++)
        {
            m_ppuiSparsityPattern[i - 1][j + 1] = m_piValueColIndex[iValueIndex++];
        }
    }
}

bool spCompGeneric::computeDerivatives(types::typed_list& in)
{
    types::typed_list in2;
    types::typed_list out2;
    types::optional_list opt2;
    types::Double* pDblFstep;
    types::Double* pDblX0;

    char errorMsg[256];

    int iNbColArg;

    if (in[0]->isDouble() && in[0]->getAs<types::Double>()->isComplex() == false)
    {
        pDblX0 = in[0]->getAs<types::Double>();
        pDblX0->IncreaseRef();

        if (pDblX0->getSize() != m_iNbVars)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d : a vector of size %d expected.\n"), "spCompGeneric::computeDerivatives", 1, m_iNbVars);
            return false;
        }
    }
    else
    {
        Scierror(999, _("%s: Wrong type for input argument #%d : A real matrix expected.\n"), "spCompGeneric::computeDerivatives", 2);
        return false;
    }

    double* pdblX0 = pDblX0->get();

    //prepare steps for formulas and later rescaling
    for (int i = 0; i < m_iNbVars; i++)
    {
        m_pdblStep[i] = std::copysign(1, pdblX0[i]) * m_pDblRelStep->get(i) * std::max(std::abs(m_pDblTypicalX->get(i)), std::abs(pdblX0[i]));
    }

    //prepare matrix of concatenated columns to be given to user function
    if (m_scheme == COMPLEXSTEP)
    {
        m_pDblX = new types::Double(m_iNbVars, m_iNbSeedCols, true);
        for (int i = 0; i < m_iNbVars; i++)
        {
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_pDblX->set(i, j, pdblX0[i]);
                m_pDblX->setImg(i, j, m_pdblStep[i] * m_ppdblSeed[i][j]);
            }
        }
    }
    else if (m_scheme == CENTERED)
    {
        m_pDblX = new types::Double(m_iNbVars, 2 * m_iNbSeedCols);
        for (int i = 0; i < m_iNbVars; i++)
        {
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_pDblX->set(i, 2 * j, pdblX0[i] - m_pdblStep[i] * m_ppdblSeed[i][j]);
                m_pDblX->set(i, 2 * j + 1, pdblX0[i] + m_pdblStep[i] * m_ppdblSeed[i][j]);
            }
        }
    }
    else if (m_scheme == FORWARD)
    {
        m_pDblX = new types::Double(m_iNbVars, m_iNbSeedCols + 1);
        for (int i = 0; i < m_iNbVars; i++)
        {
            m_pDblX->set(i, 0, pdblX0[i]);
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_pDblX->set(i, j + 1, pdblX0[i] + m_pdblStep[i] * m_ppdblSeed[i][j]);
            }
        }
    }

    iNbColArg = m_pDblX->getCols();

    if (m_bVectorized)
    {
        in2.push_back(m_pDblX);
        //add user parameters in arguments list
        for (int i = 1; i < in.size(); i++)
        {
            in2.push_back(in[i]);
        }
        for (auto pIn : in2)
        {
            pIn->IncreaseRef();
        }

        try
        {
            // new std::wstring(L"") is deleted in destructor of ast::CommentExp
            m_pCallFunction->invoke(in2, opt2, 1, out2, ast::CommentExp(Location(), new std::wstring(L"")));
        }
        catch (ast::InternalError& ie)
        {
            if (ConfigVariable::getLastErrorFunction() == L"")
            {
                // necessary for errors such as "Wrong number of input arguments"
                std::wostringstream ostr;
                ostr << m_pCallFunctionName << L": " << ie.GetErrorMessage();
                ie.SetErrorMessage(ostr.str());
            }
            throw(ie);
        }

        for (auto pIn : in2)
        {
            pIn->DecreaseRef();
            if (pIn->isDeletable())
            {
                delete pIn;
            }
        }

        if (out2.size() != 1)
        {
            sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), m_pCallFunctionName, 1);
            throw ast::InternalError(errorMsg);
        }

        if (out2[0]->isDouble() == false)
        {
            sprintf(errorMsg, _("%s: Wrong type for output argument #%d: real matrix expected.\n"), m_pCallFunctionName, 1);
            throw ast::InternalError(errorMsg);
        }

        pDblFstep = out2[0]->getAs<types::Double>();

        if (pDblFstep->getRows() != m_iNbRows || pDblFstep->getCols() != iNbColArg)
        {
            sprintf(errorMsg, _("%s: Wrong size for output argument #%d: a matrix with %d rows and %d columns expected.\n"), m_pCallFunctionName, 1, m_iNbRows, iNbColArg);
            throw ast::InternalError(errorMsg);
        }
    }
    else
    {
        types::Double* pDblXcol = new types::Double(m_iNbVars, 1, m_scheme == COMPLEXSTEP);
        pDblFstep = new types::Double(m_iNbRows, iNbColArg, m_scheme == COMPLEXSTEP);

        double* pdblXcol = pDblXcol->get();
        double* pdblXcolImg = pDblXcol->getImg();

        in2.push_back(pDblXcol);
        // extra user arguments
        for (int i = 1; i < in.size(); i++)
        {
            in2.push_back(in[i]);
        }

        for (auto pIn : in2)
        {
            pIn->IncreaseRef();
        }

        for (int j = 0; j < iNbColArg; j++)
        {
            //copy of jth column of X into Xcol
            memcpy(pdblXcol, m_pDblX->get() + j * m_iNbVars, m_iNbVars * sizeof(double));
            if (pdblXcolImg)
            {
                memcpy(pdblXcolImg, m_pDblX->getImg() + j * m_iNbVars, m_iNbVars * sizeof(double));
            }

            try
            {
                // new std::wstring(L"") is deleted in destructor of ast::CommentExp
                m_pCallFunction->invoke(in2, opt2, 1, out2, ast::CommentExp(Location(), new std::wstring(L"")));
            }
            catch (ast::InternalError& ie)
            {
                if (ConfigVariable::getLastErrorFunction() == L"")
                {
                    // necessary for errors such as "Wrong number of input arguments"
                    std::wostringstream ostr;
                    ostr << m_pCallFunctionName << L": " << ie.GetErrorMessage();
                    ie.SetErrorMessage(ostr.str());
                }
                throw(ie);
            }

            if (out2.size() != 1)
            {
                sprintf(errorMsg, _("%s: Wrong number of output argument(s): %d expected.\n"), m_pCallFunctionName, 1);
                throw ast::InternalError(errorMsg);
            }

            if (out2[0]->isDouble() == false)
            {
                sprintf(errorMsg, _("%s: Wrong type for output argument #%d: real matrix expected.\n"), m_pCallFunctionName, 1);
                throw ast::InternalError(errorMsg);
            }

            types::Double* pDblFstepCurrCol = out2[0]->getAs<types::Double>();
            out2.pop_back();

            if (pDblFstepCurrCol->getRows() != m_iNbRows || pDblFstepCurrCol->getCols() != 1)
            {
                sprintf(errorMsg, _("%s: Wrong size for output argument #%d: a matrix with %d rows and %d columns expected.\n"), m_pCallFunctionName, 1, m_iNbRows, 1);
                throw ast::InternalError(errorMsg);
            }

            for (int i = 0; i < m_iNbRows; i++)
            {
                pDblFstep->set(i, j, pDblFstepCurrCol->get(i));
            }
            if (m_scheme == COMPLEXSTEP)
            {
                for (int i = 0; i < m_iNbRows; i++)
                {
                    pDblFstep->setImg(i, j, pDblFstepCurrCol->getImg(i));
                }
            }

            pDblFstepCurrCol->killMe();
        } //for (int j=0; j < iNbColArg; j++)

        for (auto pIn : in2)
        {
            pIn->DecreaseRef();
            if (pIn->isDeletable())
            {
                delete pIn;
            }
        }

    } // if (m_bVectorized)

    // Computing the derivative approximations (rescaling is done after jacobian recovery)
    // We post mutiply by m_pdblStep[i] in order to finaly recover a symmetric matrix diag(m_pdblStep)*f'(x)*diag(m_pdblStep) in the Hessian case
    // In the Jacobian case we recover diag(m_pdblStep[1...m_iNbRows])*f'(x)*diag(m_pdblStep[1...m_iNbVars])
    // The rescaling is done the same way in both cases. 

    if (m_scheme == CENTERED)
    {
        for (int i = 0; i < m_iNbRows; i++)
        {
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_ppdblProd[i][j] = m_pdblStep[i] * (pDblFstep->get(i, 2 * j + 1) - pDblFstep->get(i, 2 * j)) / 2.0;
            }
        }
    }
    else if (m_scheme == FORWARD)
    {
        for (int i = 0; i < m_iNbRows; i++)
        {
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_ppdblProd[i][j] = m_pdblStep[i] * (pDblFstep->get(i, j + 1) - pDblFstep->get(i, 0));
            }
        }
    }
    else if (m_scheme == COMPLEXSTEP)
    {
        for (int i = 0; i < m_iNbRows; i++)
        {
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_ppdblProd[i][j] = m_pdblStep[i] * pDblFstep->getImg(i, j);
            }
        }
    }

    pDblFstep->killMe();
    pDblX0->killMe();

    return true;
}

types::Sparse* spCompGeneric::getRecoveredMatrix()
{
    int iValueIndex = 0;
    //recover Jacobian from product with seed (directional derivative approximations)
    // Rescaling is symmetric, which is a must for the Hessian case. Method should be
    // different for Jacobian

    recover();

    m_pdblValues = new double[m_iNonZeros];

    // rescale columns and convert to Eigen CSR: outer and inner vectors are already known from initial pattern.
    // hence we just concatenate the Hessian values as a single vector.
    for (int i = 0; i < m_iNbRows; i++)
    {
        for (int j = 1; j < (int)m_ppdblJacValue[i][0] + 1; j++)
        {
            m_pdblValues[iValueIndex] = m_ppdblJacValue[i][j] / m_pdblStep[m_piValueColIndex[iValueIndex]] / m_pdblStep[i];
            iValueIndex++;
        }
    }

    types::Sparse* pDblJac = new types::Sparse(m_iNbRows, m_iNbVars, m_iNonZeros, m_piValueColIndex, m_piRowBeginIndex, m_pdblValues, NULL);

    return pDblJac;
}

void spCompGeneric::recoverMatrix(double* pdblValues)
{
    int iValueIndex = 0;
    //recover Jacobian from product with seed (directional derivative approximations)
    //no rescaling, nozero terms are directly copied in pdblValues[]

    recover();

    // rescale columns and convert to Eigen CSR: outer and inner vectors are already known from initial pattern.
    // hence we just concatenate the Hessian values as a single vector.
    for (int i = 0; i < m_iNbRows; i++)
    {
        for (int j = 1; j < (int)m_ppdblJacValue[i][0] + 1; j++)
        {
            pdblValues[iValueIndex] = m_ppdblJacValue[i][j];
            iValueIndex++;
        }
    }
}

types::Double* spCompGeneric::getSeed()
{

    types::Double* pDblSeed = new types::Double(m_iNbVars, m_iNbSeedCols);
    for (int i = 0; i < m_iNbVars; i++)
    {
        for (int j = 0; j < m_iNbSeedCols; j++)
        {
            pDblSeed->set(i, j, m_ppdblSeed[i][j]);
        }
    }
    return pDblSeed;
}
