// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->


// <-- Non-regression test for bug 4386 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4386
//
// <-- Short Description -->
// link('show') with only one symbol writes 'librairies' and not 'library'.

ulink();
link('show');
