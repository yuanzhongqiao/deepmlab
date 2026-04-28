// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 3700 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3700
//
// <-- Short Description -->
// mputl fails to write some accents

refText = [ 'éàèù$£§µûâô^v~ç';'éàèù$£§µûâô^v~ç'];
mputl(refText, TMPDIR+filesep()+'bug_3700.txt');

TXT2 = mgetl(TMPDIR+filesep()+'bug_3700.txt');
if (refText <> TXT2) then pause,end
