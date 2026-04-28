// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4684 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4684
// printf() does not properly deal with -%inf.

ref = 'Value is: -Inf';
tst = msprintf('Value is: %d', -%inf);

if ref <> tst then pause,end

ref = 'Value is: Inf';
tst = msprintf('Value is: %d', %inf);

if ref <> tst then pause,end

printf('Value is: %d', -%inf);
printf('Value is: %d', %inf);
