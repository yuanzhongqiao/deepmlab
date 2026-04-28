// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 8955 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8955
//
// <-- Short Description -->
// Spaces within matrix should be processed a special way.

// <-- CLI SHELL MODE -->

if or([1 - 1] <> [0]) then pause, end
if or([1 -1] <> [1, -1]) then pause, end
if or([1- 1] <> [0]) then pause, end
if or([1-1] <> [0]) then pause, end

a = 10;
if or([a (1)] <> [10, 1]) then pause, end
if or([a(1)] <> [10]) then pause, end
if or([(a)(1)] <> [10]) then pause, end
if or([(a) (1)] <> [10, 1]) then pause, end

if a(1) <> 10 then pause, end
if a     (1) <> 10 then pause, end
