// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 7312 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7312
//
// <-- Short Description -->
// strstr crashed scilab if the second input argument was longer than the first one.

if execstr("r = strstr(""small"", ""largestring"")", "errcatch") <> 0 then pause,end
if r <> "" then pause, end

r = strstr(["a","b";"c","d"], "largestring");
ref = emptystr(2, 2);
if or(r <> ref)  then pause, end
