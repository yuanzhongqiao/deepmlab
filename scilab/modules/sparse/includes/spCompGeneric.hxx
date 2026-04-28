//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020-2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef __SPCOMPGENERIC_HXX__
#define __SPCOMPGENERIC_HXX__

#include <map>

#include "dynlib_sparse.h"
#include "function.hxx"
#include "double.hxx"
#include "sparse.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

class SPARSE_IMPEXP spCompGeneric
{
    public :
    
    spCompGeneric(const std::wstring& callerName);
    virtual ~spCompGeneric() = 0;

    enum approximationType {FORWARD,CENTERED,COMPLEXSTEP};
    enum coloringType {DISTANCE_TWO,ACYCLIC_FOR_INDIRECT_RECOVERY,STAR,RESTRICTED_STAR,COLUMN_PARTIAL_DISTANCE_TWO,INVALID_COLORING};    
    enum orderingType {NATURAL,LARGEST_FIRST,DYNAMIC_LARGEST_FIRST,DISTANCE_TWO_LARGEST_FIRST,
        SMALLEST_LAST,DISTANCE_TWO_SMALLEST_LAST,INCIDENCE_DEGREE,DISTANCE_TWO_INCIDENCE_DEGREE,RANDOM,INVALID_ORDERING};

    std::map<coloringType,std::string> coloringAsString {
        {DISTANCE_TWO, "DISTANCE_TWO"},                  
        {ACYCLIC_FOR_INDIRECT_RECOVERY, "ACYCLIC_FOR_INDIRECT_RECOVERY"},                  
        {STAR, "STAR"},
        {RESTRICTED_STAR, "RESTRICTED_STAR"},       
        {COLUMN_PARTIAL_DISTANCE_TWO, "COLUMN_PARTIAL_DISTANCE_TWO"},
        {INVALID_COLORING, "INVALID"}
    }; 
    
    std::map<coloringType,std::wstring> coloringAsWString {
        {DISTANCE_TWO, L"DISTANCE_TWO"},                  
        {ACYCLIC_FOR_INDIRECT_RECOVERY, L"ACYCLIC_FOR_INDIRECT_RECOVERY"},                  
        {STAR, L"STAR"},       
        {RESTRICTED_STAR, L"RESTRICTED_STAR"},       
        {COLUMN_PARTIAL_DISTANCE_TWO, L"COLUMN_PARTIAL_DISTANCE_TWO"},
        {INVALID_COLORING, L"INVALID"}
    }; 

    std::map<orderingType,std::string> orderingAsString {
        {NATURAL, "NATURAL"},
        {LARGEST_FIRST, "LARGEST_FIRST"},               
        {DYNAMIC_LARGEST_FIRST,"DYNAMIC_LARGEST_FIRST"},
        {DISTANCE_TWO_LARGEST_FIRST,"DISTANCE_TWO_LARGEST_FIRST"},
        {SMALLEST_LAST, "SMALLEST_LAST"},
        {DISTANCE_TWO_SMALLEST_LAST, "DISTANCE_TWO_SMALLEST_LAST"},
        {INCIDENCE_DEGREE, "INCIDENCE_DEGREE"},
        {DISTANCE_TWO_INCIDENCE_DEGREE, "DISTANCE_TWO_INCIDENCE_DEGREE"},
        {RANDOM, "RANDOM"},
        {INVALID_ORDERING, "INVALID"}
    }; 

    std::map<orderingType,std::wstring> orderingAsWString {
        {NATURAL, L"NATURAL"},
        {LARGEST_FIRST, L"LARGEST_FIRST"},               
        {DYNAMIC_LARGEST_FIRST,L"DYNAMIC_LARGEST_FIRST"},
        {DISTANCE_TWO_LARGEST_FIRST,L"DISTANCE_TWO_LARGEST_FIRST"},
        {SMALLEST_LAST, L"SMALLEST_LAST"},
        {DISTANCE_TWO_SMALLEST_LAST, L"DISTANCE_TWO_SMALLEST_LAST"},
        {INCIDENCE_DEGREE, L"INCIDENCE_DEGREE"},
        {DISTANCE_TWO_INCIDENCE_DEGREE, L"DISTANCE_TWO_INCIDENCE_DEGREE"},
        {RANDOM, L"RANDOM"},
        {INVALID_ORDERING, L"INVALID"}
    };
    
    virtual bool init() = 0;
    virtual bool recover() = 0;
    virtual void getColumnColors(std::vector<int> &vi_VertexColors) = 0;
    
    bool setComputeParameters(types::typed_list &in, types::optional_list &opt, bool bSym = false);
    bool computeDerivatives(types::typed_list &in);
    void setPattern(int *piRowBeginIndex, int *piValueColIndex, int iRows, int iNonZeros);
    void setPattern(types::InternalType *pI);

    std::string getOrdering();
    std::string getColoring();
    types::Double *getSeed();
    types::Sparse *getRecoveredMatrix();
    void recoverMatrix(double *);  

    int *getPiRowBeginIndex()
    {
        return m_piRowBeginIndex;
    }
    int *getPiValueColIndex()
    {
        return  m_piValueColIndex; 
    }     
    double **getProducts()
    {
        return m_ppdblProd;
    }
    double **getSeeds()
    {
        return m_ppdblSeed;
    }
    int getNbSeeds()
    {
        return m_iNbSeedCols;
    }
      
    protected :
    
    unsigned int **m_ppuiSparsityPattern = NULL;  
    int m_iNbRows = 0;
    int m_iNbVars = 0;
    int m_iNbSeedCols = 0;
    double **m_ppdblJacValue = NULL;
    double **m_ppdblSeed = NULL;
    double **m_ppdblProd = NULL;
    
    coloringType m_coloring;
    orderingType m_ordering;
    
    private :

    std::wstring m_wstrCaller;
    char *m_pstrCaller = NULL;

    approximationType m_scheme = FORWARD;

    int m_iNonZeros = 0;
    
    int *m_piRowBeginIndex = NULL;
    int *m_piValueColIndex = NULL;
        
    double *m_pdblValues = NULL;
    double *m_pdblStep = NULL;

    bool m_bVectorized = false;

    types::Double  *m_pDblRelStep = NULL;
    types::Double  *m_pDblTypicalX = NULL;
    types::Double  *m_pDblX = NULL;
    types::Double  *m_pDblOut = NULL;
    
    types::Callable *m_pCallFunction = NULL;
    char *m_pCallFunctionName = NULL;
};

#endif
