//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef __SPCOMPJACOBIAN_HXX__
#define __SPCOMPJACOBIAN_HXX__

#include "dynlib_sparse.h"
#include "spCompGeneric.hxx"
#include "ColPackHeaders.h"

class SPARSE_IMPEXP spCompJacobian final : public spCompGeneric
{
    public :

    spCompJacobian(const std::wstring& callerName) : spCompGeneric(callerName)
    {
        m_coloring = COLUMN_PARTIAL_DISTANCE_TWO;        
        m_ordering = SMALLEST_LAST;        
    };
    ~spCompJacobian();    
    bool init();
    bool recover();
    void getColumnColors(vector<int> &vi_VertexColors)
    {
        m_g->GetRightVertexColors(vi_VertexColors);
    }

    private :

    ColPack::BipartiteGraphPartialColoringInterface *m_g = NULL;
    ColPack::JacobianRecovery1D* m_jr1d = NULL;
};

#endif
