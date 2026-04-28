// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15071 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15071
//
// <-- Short Description -->
// Extraction of mlist from another mlist debhaves differently in Scilab 6
//

a = mlist(['mytype']);
b = mlist(['myothertype']);
function out = %mytype_e(varargin)
   var   = varargin($);
   field = varargin(1);
   out = field;
endfunction
assert_checkequal(a(b), b);
