// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15602 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15602
//
// <-- Short Description -->
// gca()("thickness") crashes Scilab

gca()("thickness");
