//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "spCompHessian.hxx"

spCompHessian::~spCompHessian()
{
    delete m_g;
    delete m_hr;
}

bool spCompHessian::init()
{
    if (m_ppuiSparsityPattern != NULL && m_iNbRows != 0 && m_iNbVars != 0)
    {
        int iSeedRowCount;
        int iSeedColumnCount;
        
        m_g = new ColPack::GraphColoringInterface(SRC_MEM_ADOLC, m_ppuiSparsityPattern, m_iNbRows);
        m_hr = new ColPack::HessianRecovery();

        //Step 2.2: Color the bipartite graph with the specified ordering
        //Step 2.3: From the coloring information, create and return the seed matrix    
        
        m_g->Coloring(orderingAsString[m_ordering],coloringAsString[m_coloring]);      
        m_ppdblSeed = m_g->GetSeedMatrix(&iSeedRowCount, &iSeedColumnCount);
        
        // iSeedColumnCount can be larger that the actual number of colors
        m_iNbSeedCols = m_g->GetVertexColorCount();
        //allocate matrix of "products" in double Compressed row ColPack format
        m_ppdblProd = new double*[m_iNbRows];                
        for (int i = 0; i < m_iNbRows; i++)
        {
            m_ppdblProd[i] = new double[m_iNbSeedCols];
            for (int j = 0; j < m_iNbSeedCols; j++)
            {
                m_ppdblProd[i][j] = 0.0;
            }
        }                    
    }
    else
    {
        Scierror(999, _("%s: Internal error, sparsity pattern not set.\n"), "numsphessian");            
        return false;
    }
    return true;
}

bool spCompHessian::recover()
{
    if (m_coloring == ACYCLIC_FOR_INDIRECT_RECOVERY)
    {
        m_hr->IndirectRecover_RowCompressedFormat(m_g, m_ppdblProd, m_ppuiSparsityPattern, &m_ppdblJacValue);        
    }
    else
    {
        m_hr->DirectRecover_RowCompressedFormat(m_g, m_ppdblProd, m_ppuiSparsityPattern, &m_ppdblJacValue);
    }
    return true;
}
