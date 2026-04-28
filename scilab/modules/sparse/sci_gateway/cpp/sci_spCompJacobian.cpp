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
#include "spCompJacobian.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
}

types::Function::ReturnValue sci_spCompJacobian(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    // H = spCompJacobian(f,sp_pattern,options);
    // f is a Scilab function returning the function to derive
    // sp_pattern is a sparse or sparse boolean matrix
    // options is a list of optional named parameters
    if (in.size() != 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d expected.\n"), "spCompJacobian", 2);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
      Scierror(999, _("%s: Wrong number of output argument(s): at most %d expected.\n"), "spCompJacobian", 1);
      return types::Function::Error;
    }

    spCompJacobian *spcjEngine = new spCompJacobian(L"spCompJacobian");
      
    if (spcjEngine->setComputeParameters(in, opt, false) == false)
    {
        delete spcjEngine;
        return types::Function::Error;
    }

    if (spcjEngine->init() == false)
    {
        delete spcjEngine;
        return types::Function::Error;
    }
    
    types::MList *pObj = new types::MList();
    types::String *pStr = new types::String(1,6);
    types::Pointer *pEngine = new types::Pointer((void *)spcjEngine);

    pStr->set(0,L"_spCompJacobian");
    pStr->set(1,L"Ordering");
    pStr->set(2,L"Coloring");
    pStr->set(3,L"seed");
    pStr->set(4,L"colors");
    pStr->set(5,L"engine");

    pObj->set(0,pStr);
    pObj->set(1,new types::String(spcjEngine->getOrdering().c_str()));    
    pObj->set(2,new types::String(spcjEngine->getColoring().c_str()));    

    pObj->set(3,spcjEngine->getSeed());

    vector<int> viColors;
    spcjEngine->getColumnColors(viColors);

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
