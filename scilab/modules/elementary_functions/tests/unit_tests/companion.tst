//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for companion
// =============================================================================
//

// Linear real polynomial
p=1+2*%s;
computed=companion(p);
expected=[-1/2];
assert_checkequal(computed, expected);

// Quadratic real polynomial
p=1+2*%s+3*%s^2;
computed=companion(p);
expected=[-2/3 , -1/3;1 , 0];
assert_checkequal(computed, expected);

// Cubic real polynomial
p=1+2*%s+3*%s^2+4*%s^3;
computed=companion(p);
expected=[-3/4 , -2/4 , -1/4; 1 , 0 , 0 ; 0 , 1, 0];
assert_checkequal(computed, expected);

// Linear complex polynomial
p=1+%i+2*%s;
computed=companion(p);
expected=[-(1+%i)/2];
assert_checkequal(computed, expected);

// Quadratic complex polynomial
p=1+%i+2*%s+3*%s^2;
computed=companion(p);
expected=[-2/3 , -(1+%i)/3;1 , 0];
assert_checkequal(computed, expected);

// Cubic complex polynomial
p=1+%i+2*%s+3*%s^2+4*%s^3;
computed=companion(p);
expected=[-3/4 , -2/4 , -(1+%i)/4; 1 , 0 , 0 ; 0 , 1, 0];
assert_checkequal(computed, expected);

// Vector of linear polynomials
p1=1+2*%s;
p2=1+%i+2*%s;
vector = [p1 p2];
computed=companion(vector);
expected=[-1/2 0;0 -(1+%i)/2];
assert_checkequal(computed, expected);

// Vector of quadratic/cubic real/complex polynomials
p1=1+2*%s+3*%s^2;
p2=1+%i+2*%s+3*%s^2+4*%s^3;
vector = [p1 p2];
computed=companion(vector);
expected=[-2/3 -1/3 0 0 0;1 0 0 0 0; 0 0 -3/4 -2/4 -(1+%i)/4;0 0 1 0 0;0 0 0 1 0];
assert_checkequal(computed, expected);

// With double
c = [2 1];
computed=companion(c);
expected=[-1/2];
assert_checkequal(computed, expected);

c = [3 2 1];
computed=companion(c);
expected=[-2/3 , -1/3;1 , 0];
assert_checkequal(computed, expected);

c = [4 3 2 1];
computed=companion(c);
expected=[-3/4 , -2/4 , -1/4; 1 , 0 , 0 ; 0 , 1, 0];
assert_checkequal(computed, expected);

c = [2 1+1i];
computed=companion(c);
expected=[-(1+%i)/2];
assert_checkequal(computed, expected);

c = [3 2 1+1i];
computed=companion(c);
expected=[-2/3 , -(1+%i)/3;1 , 0];
assert_checkequal(computed, expected);

c = [4 3 2 1+1i];
computed=companion(c);
expected=[-3/4 , -2/4 , -(1+%i)/4; 1 , 0 , 0 ; 0 , 1, 0];
assert_checkequal(computed, expected);

// Vector of linear polynomials
vector = [2 1; 2 1 + 1i];
msg = msprintf(_("%s: Wrong size for input argument #%d: A vector expected.\n"), "companion", 1);
assert_checkerror("companion(vector)", msg);

msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "companion", 1);
assert_checkerror("companion()", msg);
msg = msprintf(_("Wrong number of input arguments."));
assert_checkerror("companion(1,2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "companion", 1, sci2exp(["double", "polynomial"]));
assert_checkerror("companion(""toto"")", msg);
