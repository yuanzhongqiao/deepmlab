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
// <-- Non-regression test for issue 16908-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16908
//
// <-- Short Description -->
// Segmentation fault in macr2tree when members of an object are called as a function
//

function f(a)
  a.member // ok
  a.func_member // ok
  a.func_member() // segfaults
  a.func_member(42) // segfaults
  a.func_member('foo') // segfaults
endfunction

macr2tree(f)

