//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020-2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "spCompJacobian.hxx"

spCompJacobian::~spCompJacobian()
{
    delete m_g;
    delete m_jr1d;
}

bool spCompJacobian::init()
{
    if (m_ppuiSparsityPattern != NULL && m_iNbRows != 0 && m_iNbVars != 0)
    {
        int iSeedRowCount;
        int iSeedColumnCount;
        
        m_g = new ColPack::BipartiteGraphPartialColoringInterface(SRC_MEM_ADOLC, m_ppuiSparsityPattern, m_iNbRows, m_iNbVars);
        m_jr1d = new ColPack::JacobianRecovery1D();

        //Step 2.2: Do Partial-Distance-Two-Coloring the bipartite graph with the specified ordering
        //Step 2.3: From the coloring information, create and return the seed matrix
        
        m_g->PartialDistanceTwoColoring(orderingAsString[m_ordering],coloringAsString[m_coloring]);
        m_ppdblSeed = m_g->GetSeedMatrix(&iSeedRowCount, &iSeedColumnCount);

        // iSeedColumnCount can be larger that the actual number of colors
        m_iNbSeedCols = m_g->GetVertexColorCount();
        //allocate matrix of "products" in Compressed row ColPack format
        m_ppdblProd = new double*[m_iNbRows];
        for (int i = 0; i < m_iNbRows; i++)
        {
            m_ppdblProd[i] = new double[m_iNbSeedCols];
        }
    }
    else
    {
        Scierror(999, _("%s: Internal error, sparsity pattern not set.\n"), "numspjacobian");
        return false;
    }
    return true;
}

bool spCompJacobian::recover()
{
    m_jr1d->RecoverD2Cln_RowCompressedFormat(m_g, m_ppdblProd, m_ppuiSparsityPattern,&m_ppdblJacValue);
    return true;
}