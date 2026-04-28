//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2338 -->
// <-- CLI SHELL MODE -->
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2338
//
// <-- Short Description -->
//    string(overloadinglib) contains one empty element: that shouldn't be


a=string(overloadinglib);
if ~isempty(find(a=="")) then pause,end
