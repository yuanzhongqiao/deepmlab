// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Le Mans Université - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// Description:
// Unitary tests of angle()
// ----------------------------------------------------------------------------

assert_checkequal(angle([]), []);

// Real axis
assert_checkequal(angle([-%inf -2 -1 0 1 2 %inf]), [%pi %pi %pi 0 0 0 0]);

// Imaginary axis
z = complex(zeros(1,7),[-%inf -2 -1 0 1 2 %inf]);
assert_checkequal(angle(z), [-%pi -%pi -%pi 0 %pi %pi %pi]/2);

// NaN real part
z = complex(ones(1,7)*%nan, [-%inf -2 -1 0 1 2 %inf]);
assert_checkequal(angle(z), ones(1,7)*%nan);

// NaN imaginary part
z = complex([-%inf -2 -1 0 1 2 %inf], ones(1,7)*%nan);
assert_checkequal(angle(z), ones(1,7)*%nan);

// Real = Imag
z = complex([-%inf -2 -1 0 1 2 %inf], [-%inf -2 -1 0 1 2 %inf]);
assert_checkequal(angle(z), [-3*%pi -3*%pi -3*%pi 0 %pi %pi %pi]/4);

// Real>0 = -Imag
z = complex([0 1 2 %inf], [0 -1 -2 -%inf]);
assert_checkequal(angle(z), [0 -%pi/4 -%pi/4 -%pi/4]);

// Real<0 = -Imag
z = complex(-[0 1 2 %inf], [0 1 2 %inf]);
assert_checkequal(angle(z), [0 3*%pi/4 3*%pi/4 3*%pi/4]);

// (-%pi bound)
assert_checkequal(angle(-1 -%eps*%i), -%pi);
