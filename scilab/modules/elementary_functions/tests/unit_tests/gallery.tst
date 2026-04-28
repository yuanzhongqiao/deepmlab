// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for gallery function
// =============================================================================

g = gallery(3);
expected = [-149 -50 -154; 537 180 546; -27 -9 -25];
assert_checkequal(g, expected);

g = gallery(5);
expected = [-9 11 -21 63 -252; 
            70 -69 141 -421 1684;
            -575 575 -1149 3451 -13801;
            3891 -3891 7782 -23345 93365; 
            1024 -1024 2048 -6144 24572];
assert_checkequal(g, expected);

// cauchy
name = "cauchy";
assert_checkequal(gallery(name, 0), []);
assert_checkequal(gallery(name, 1), 0.5);

n = 4;
expected = 1./[2 3 4 5; 3 4 5 6; 4 5 6 7; 5 6 7 8];
assert_checkequal(gallery(name, n), expected);
assert_checkequal(gallery(name, n, n), expected);
assert_checkequal(gallery(name, 1:n, n), expected);
assert_checkequal(gallery(name, n, 1:n), expected);
assert_checkequal(gallery(name, 1:n, 1:n), expected);

expected = 1./[6 8 10; 7 9 11; 8 10 12];
assert_checkequal(gallery(name, 1:3, 5:2:9), expected);
assert_checkequal(gallery(name, 5:2:9, 1:3), expected');

expected = 1./[4 3 2 1; -1 -2 -3 -4; 6 5 4 3; -3 -4 -5 -6];
assert_checkequal(gallery(name, [3 -2 5 -4], [1 0 -1 -2]), expected);

expected = [0.25-0.25i 1/6-1i/6; 1/6-1i/6 0.125-0.125i];
assert_checkequal(gallery(name, [1+1i, 2+2i]), expected);

expected = [0.4-0.2i 0.3-0.1i; 0.25-0.25i 0.2307692 - 0.1538462i];
assert_checkalmostequal(gallery(name, [1i, 2i], [2 3]), expected, [], 1e-7);
assert_checkalmostequal(gallery(name, [2 3], [1i, 2i]), expected.',  [], 1e-7);

expected = [0.5-0.5i 0.2-0.4i; 0.4-0.2i 0.25-0.25i];
assert_checkequal(gallery(name, 2, [1i, 2i]), expected);
assert_checkequal(gallery(name, [1i, 2i], 2), expected.');

// circul
name = "circul";
msg = msprintf(_("%s: Wrong size for input argument #%d: A vector expected.\n"), "gallery", 2);
assert_checkerror("gallery(name, [])", msg);

assert_checkequal(gallery(name, 1), 1);

expected = [1 2 3;3 1 2; 2 3 1];
assert_checkequal(gallery(name, 3), expected);
assert_checkequal(gallery(name, 1:3), expected);

expected = [2 4 6;6 2 4; 4 6 2];
assert_checkequal(gallery(name, 2:2:6), expected);
assert_checkequal(gallery(name, [2; 4; 6]), expected);

g = gallery(name, [1:3]+[2:4]*1i);
expected = [1 2 3;3 1 2; 2 3 1] + [2 3 4; 4 2 3; 3 4 2]*%i;
assert_checkequal(g, expected);

g = gallery(name, [1 2i 4]);
expected = [1 0 4; 4 1 0; 0 4 1] + [0 2 0; 0 0 2; 2 0 0] *%i;
assert_checkequal(g, expected);

// ris
name = "ris";
msg = msprintf(_("%s: Wrong size for input argument #%d: A scalar expected.\n"), "gallery", 2);
assert_checkerror("gallery(name, 1:2)", msg);

assert_checkequal(gallery(name, []), []);
assert_checkequal(gallery(name, 1), 1);

g = gallery(name, 2);
assert_checkequal(g, [1/3 1; 1 -1]);

g = gallery(name, 3);
expected = [0.2 1/3 1; 1/3 1 -1; 1 -1 -1/3];
assert_checkequal(g, expected);

// minij
name = "minij";
msg = msprintf(_("%s: Wrong size for input argument #%d: A scalar expected.\n"), "gallery", 2);
assert_checkerror("gallery(name, 1:2)", msg);

assert_checkequal(gallery(name, []), []);
assert_checkequal(gallery(name, 1), 1);

g = gallery(name, 3);
assert_checkequal(g, [1 1 1; 1 2 2; 1 2 3]);

g = gallery(name, 5);
assert_checkequal(g, [1 1 1 1 1; 1 2 2 2 2; 1 2 3 3 3; 1 2 3 4 4; 1 2 3 4 5]);

// moler
name = "moler";
msg = msprintf(_("%s: Wrong size for input argument #%d: A scalar expected.\n"), "gallery", 2);
assert_checkerror("gallery(name, 1:2)", msg);

assert_checkequal(gallery(name, []), []);
assert_checkequal(gallery(name, 1), 1);

g = gallery(name, 3);
assert_checkequal(g, [1 -1 -1; -1 2 0; -1 0 3]);

g = gallery(name, 5);
assert_checkequal(g, [1 -1 -1 -1 -1; -1 2 0 0 0; -1 0 3 1 1; -1 0 1 4 2; -1 0 1 2 5]);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), "gallery", 1);
assert_checkerror("gallery()", msg);