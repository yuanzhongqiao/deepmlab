// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 -UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15796 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15796
//
// <-- Short Description -->
// Display after mprintf("") msprintf("") crashes Scilab (was OK in 6.0.1)

mprintf("")
msprintf("")
printf("")
sprintf("")
