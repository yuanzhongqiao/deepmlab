// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 17398 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17398
//
// <-- Short Description -->
// "Error when displaying an uninitialized tlist.
// -------------------------------------------------------------

t=tlist(["type", "a", "b"])
m=mlist(["type", "a", "b"])

