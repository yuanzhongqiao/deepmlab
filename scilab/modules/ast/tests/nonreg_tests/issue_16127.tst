// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16127-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16127
//
// <-- Short Description -->
// c = {1:$} crashes Scilab
//

a = {1:$};
assert_checkequal({1:$}, a);