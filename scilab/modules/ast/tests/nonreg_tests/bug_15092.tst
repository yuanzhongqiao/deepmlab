// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 15092 -->
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15092
//
// <-- Short Description -->
// New or scalar variable is resized as a column vector instead of row vector


x=1;
x(1:4)=1:4;
assert_checkequal(x,1:4);
x=1;
x(1:4)=(1:4)';
assert_checkequal(x,(1:4)');
x=[];
x(4)=1;
assert_checkequal(x,[0 0 0 1]');
x=[];
x(1:4)=1:4;
assert_checkequal(x,1:4);
x=[];
x(1:4)=(1:4)';
assert_checkequal(x,(1:4)');
x=[1 2];
x(1:4)=1:4;
assert_checkequal(x,1:4);
x(1:4)=(1:4)';
assert_checkequal(x,1:4);
x=[1 2]';
x(1:4)=1:4;
assert_checkequal(x,(1:4)');
x(1:4)=(1:4)';
assert_checkequal(x,(1:4)');

