// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3054 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3054
//
if TCL_EvalStr("encoding system") == 'identity' then pause,end
if TCL_EvalStr("encoding names") == 'utf-8 identity unicode'  then pause,end
