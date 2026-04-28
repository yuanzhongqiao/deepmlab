//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022-2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "sparse_gw.hxx"

#include "function.hxx"
#include "double.hxx"
#include "mlist.hxx"
#include "pointer.hxx"
#include "spCompHessian.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

types::Function::ReturnValue sci_spCompHessian(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    // H = spCompHessian(g,sp_pattern,options);
    // g is a Scilab function returning the gradient
    // sp_pattern is a sparse or sparse boolean matrix
    // options is a list of optional named parameters

    if (in.size()  != 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d expected.\n"), "spCompHessian", 2);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
      Scierror(999, _("%s: Wrong number of output argument(s): at most %d expected.\n"), "spCompHessian", 1);
      return types::Function::Error;
    }

    spCompHessian *spchEngine = new spCompHessian(L"spCompHessian");

    if (spchEngine->setComputeParameters(in, opt, true) == false)
    {
        delete spchEngine;
        return types::Function::Error;
    }

    if (spchEngine->init() == false)
    {
        delete spchEngine;
        return types::Function::Error;
    }

    types::MList *pObj = new types::MList();
    types::String *pStr = new types::String(1,6);
    types::Pointer *pEngine = new types::Pointer((void *)spchEngine);

    pStr->set(0,L"_spCompHessian");
    pStr->set(1,L"Ordering");
    pStr->set(2,L"Coloring");
    pStr->set(3,L"seed");
    pStr->set(4,L"colors");
    pStr->set(5,L"engine");

    pObj->set(0,pStr);
    pObj->set(1,new types::String(spchEngine->getOrdering().c_str()));    
    pObj->set(2,new types::String(spchEngine->getColoring().c_str()));    
    pObj->set(3,spchEngine->getSeed());

    vector<int> viColors;
    spchEngine->getColumnColors(viColors);
    types::Double *pDblCol = new types::Double((int)viColors.size(),1);
    for (int i=0; i<pDblCol->getSize(); i++)
    {
        pDblCol->set(i,1+viColors[i]);
    }
    pObj->set(4,pDblCol);
    pObj->set(5,pEngine);

    out.push_back(pObj);

    return types::Function::OK;
}
