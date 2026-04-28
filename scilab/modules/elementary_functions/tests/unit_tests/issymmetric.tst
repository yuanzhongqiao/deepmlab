// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// =============================================================================
// Unit tests for issymmetric function
// =============================================================================

assert_checktrue(issymmetric([]));

assert_checktrue(issymmetric(5));
assert_checktrue(issymmetric(0));

// symmetric real dense matrices
A = [1 2 3; 2 4 5; 3 5 6];
assert_checktrue(issymmetric(A));

A = eye(5, 5);
assert_checktrue(issymmetric(A));

A = [1 0 0; 0 2 0; 0 0 3];
assert_checktrue(issymmetric(A));

// non-symmetric real dense matrices
A = [1 2 3; 4 5 6; 7 8 9];
assert_checkfalse(issymmetric(A));

A = [1 2; 3 4];
assert_checkfalse(issymmetric(A));

// non-square matrices
A = [1 2 3; 4 5 6];
assert_checkfalse(issymmetric(A));

A = [1; 2; 3];
assert_checkfalse(issymmetric(A));

// hermitian complex matrices 
A = [1 1+%i 2+%i; 1-%i 2 3+%i; 2-%i 3-%i 3];
assert_checkfalse(issymmetric(A));

A = [1 %i; -%i 2];
assert_checkfalse(issymmetric(A));

// complex diagonal matrix (should be hermitian)
A = [1+0*%i 0 0; 0 2+0*%i 0; 0 0 3+0*%i];
assert_checktrue(issymmetric(A));

// non-hermitian complex matrices
A = [1 1+%i; 1+%i 2];  // Not hermitian but symmetric
assert_checktrue(issymmetric(A));

A = [1 %i; %i 2];  // Not hermitian but symmetric
assert_checktrue(issymmetric(A));

A = [%i 0; 0 1];  
assert_checktrue(issymmetric(A));

// sparse symmetric matrices
S = sparse([1 2 0; 2 3 0; 0 0 4]);
assert_checktrue(issymmetric(S));

S = speye(10, 10);
assert_checktrue(issymmetric(S));

// sparse non-symmetric matrices
S = sparse([1 2 0; 3 4 0; 0 0 5]);
assert_checkfalse(issymmetric(S));

S = sparse([0 1 0; 0 0 1; 0 0 0]);
assert_checkfalse(issymmetric(S));

S = sparse([]);
assert_checktrue(issymmetric(S));

// sparse hermitian complex matrices
S = sparse([1 1+%i; 1-%i 2]);
assert_checkfalse(issymmetric(S));

// sparse non-hermitian complex matrices -> symmetric
S = sparse([1 1+%i; 1+%i 2]);
assert_checktrue(issymmetric(S));

n = 100;
A = sparse(eye(n, n));
for i = 1:10
    for j = i+1:min(i+3, n)
        val = rand();
        A(i, j) = val;
        A(j, i) = val;
    end
end
assert_checktrue(issymmetric(A));
