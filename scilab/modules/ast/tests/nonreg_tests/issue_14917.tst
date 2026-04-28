// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16919 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14917
//
// <-- Short Description -->
// A first empty instruction --> ; a=1 yields an error (same with --> ,a=1)

;1
,1
;,1
;a=1
,a=1
context = [";", "", "generatedVar0 = [];"]'; execstr(context)