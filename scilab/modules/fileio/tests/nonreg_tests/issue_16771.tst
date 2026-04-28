// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16771 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16771
//
// <-- Short Description -->
// fullpath("existing_path/*.ext") crashes Scilab 6.1.1
//

assert_checktrue(fullpath(SCI+"/modules/core/*.start")<>[])