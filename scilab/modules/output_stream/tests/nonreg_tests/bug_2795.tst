// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2795 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2795
//

t=["Line 1";"Line 2";"Line 3"];
msprintf("%s\n",t);