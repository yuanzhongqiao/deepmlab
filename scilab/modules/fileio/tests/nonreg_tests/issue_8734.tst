// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 8734 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8734
//
// <-- Short Description -->
// copyfile crash Scilab while playing with locales
//

// while locale is fr_FR
$ bin/scilab -l en_US

--> copyfile(SCI + "/etc/scilab.start", TMPDIR + "/Schéma électrique.start")
