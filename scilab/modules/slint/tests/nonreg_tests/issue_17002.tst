// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17002 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17002
//
// <-- Short Description -->
// Slint default configuration file copied into SCIHOME and used instead of the original one.

assert_checktrue(isfile(SCI+"/modules/slint/etc/slint.xml"));
assert_checktrue(isfile(SCIHOME+"/slint.xml"));
