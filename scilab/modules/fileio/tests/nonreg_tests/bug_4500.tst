// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) DIGITEO - 2009 - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4500 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4500
//
// <-- Short Description -->
// basename('') returns an not very clear error message. and not return ''

files = basename('');
if files <> '' then pause,end
