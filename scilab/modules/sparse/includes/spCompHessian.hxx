//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef __SPCOMPHESSIAN_HXX__
#define __SPCOMPHESSIAN_HXX__

#include "dynlib_sparse.h"
#include "spCompGeneric.hxx"
#include "ColPackHeaders.h"

class SPARSE_IMPEXP spCompHessian final : public spCompGeneric
{
    public :

    spCompHessian(const std::wstring& callerName) : spCompGeneric(callerName)
    {
        m_coloring = ACYCLIC_FOR_INDIRECT_RECOVERY;
        m_ordering = NATURAL;
    };
    ~spCompHessian();    
    bool init();
    bool recover();
    void getColumnColors(vector<int> &vi_VertexColors)
    {
        m_g->GetVertexColors(vi_VertexColors);
    }
    
    private :
    
    ColPack::GraphColoringInterface *m_g = NULL;
    ColPack::HessianRecovery* m_hr = NULL;
};

#endif
