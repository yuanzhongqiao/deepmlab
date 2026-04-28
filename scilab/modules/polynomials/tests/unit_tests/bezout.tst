// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Clement DAVID - Dassault Système
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

assert_checkequal(typeof(bezout(1, 1)), "polynomial")

// polynom
x = poly(0,'x');
p1 = (x+1)*(x-3)^5;
p2 = (x-2)*(x-3)^3;
[thegcd,U] = bezout(p1,p2);

assert_checkalmostequal(clean([p1 p2]*U), [thegcd 0]);
assert_checkalmostequal(coeff(clean(det(U))), -1);
assert_checkalmostequal(p1*U(1,2), lcm([p1,p2]));

// double
i1 = 2*3^5;
i2 = 2^3*3^2;
[thegcd, U] = bezout(i1, i2);

assert_checkalmostequal(clean([i1 i2]*U), [thegcd 0]);
assert_checkalmostequal(coeff(clean(det(U))), -1);


// integer
i1 = int32(2*3^5);
i2 = int32(2^3*3^2);
[thegcd, U] = bezout(i1, i2);

assert_checkequal([i1 i2]*U, [thegcd int32(0)]);
assert_checkalmostequal(det(double(U)), 1);

// corner cases
assert_checkequal(coeff(bezout(%inf, 1)), 0);
assert_checkequal(coeff(bezout(%nan, 1)), 0);

assert_checkequal(coeff(bezout(1, %inf)), 0);
assert_checkequal(coeff(bezout(1, %nan)), 0);
