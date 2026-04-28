// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15542 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15542
//
// <-- Short Description -->
// whereis("my_user_defined_fun") returns [] and expects a function handle, unlike for macros in libraries and primitives in gateways

deff('out=test()','out=%t');
assert_checkequal(whereis('test'),'script');
assert_checkequal(whereis(test),'script');