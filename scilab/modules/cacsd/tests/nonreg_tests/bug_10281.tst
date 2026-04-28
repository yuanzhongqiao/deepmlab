// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 10281 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10281
//
// <-- Short Description -->
// lyap segfaults in some cases

s=poly(0,'s');
A=[-1 10;0 1];B=[-2;0];C=[-2 3];D=[-2];
sis57=syslin('c',A,B,C,D);
ss2tf(sis57);

gs=C*inv((s*eye(2,2)-A))*B+D;

C=ones(2,2);
A=[0 1;-0.5 -1];
X=lyap(A,C,'c');
assert_checkalmostequal(X,[-0.75 -1; -1 -1.5]);
assert_checkalmostequal(A'*X+X*A, C);

C = [1 1];
msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a square matrix.\n"), "lyap", 2);
assert_checkerror("X=lyap(A,C,""c"")", msg);
