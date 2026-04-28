// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E.
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// =============================================================================
// Unit tests for ishermitian function
// =============================================================================

assert_checktrue(ishermitian([]));
assert_checktrue(ishermitian(5));
assert_checktrue(ishermitian(0));
assert_checkfalse(ishermitian(%i));
assert_checktrue(ishermitian(1));

A = [1 2 3; 2 4 5; 3 5 6];
assert_checktrue(ishermitian(A));

A = eye(5, 5);
assert_checktrue(ishermitian(A));

A = [1 2 3; 4 5 6; 7 8 9];
assert_checkfalse(ishermitian(A));

// hermitian complex matrices
A = [1 1+%i 2+%i; 1-%i 2 3+%i; 2-%i 3-%i 3];
assert_checktrue(ishermitian(A));

A = [1 %i; -%i 2];
assert_checktrue(ishermitian(A));

// complex diagonal matrix (should be hermitian ONLY if diagonal is real)
A = [1+0*%i 0 0; 0 2+0*%i 0; 0 0 3+0*%i];
assert_checktrue(ishermitian(A));

// Diagonal with imaginary part -> NOT hermitian
A = [1+%i 0; 0 1];
assert_checkfalse(ishermitian(A));

// non-hermitian complex matrices
A = [1 1+%i; 1+%i 2];  // Symmetric but Not hermitian
assert_checkfalse(ishermitian(A));

// sparse symmetric real matrices (are hermitian)
S = sparse([1 2 0; 2 3 0; 0 0 4]);
assert_checktrue(ishermitian(S));

// sparse hermitian complex matrices
S = sparse([1 1+%i; 1-%i 2]);
assert_checktrue(ishermitian(S));

// sparse non-hermitian complex matrices
S = sparse([1 1+%i; 1+%i 2]); // Symmetric but not hermitian
assert_checkfalse(ishermitian(S));

// Check error messages
assert_checkerror("ishermitian()", [], 77);
assert_checkerror("ishermitian(1, 2)", [], 77);
