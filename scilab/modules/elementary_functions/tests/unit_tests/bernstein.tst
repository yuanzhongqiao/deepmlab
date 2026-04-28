// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for bernstein function
// =============================================================================

// bernstein of degree 1
t = linspace(0, 1, 5);
b1 = bernstein(1, t);
expected = [1 0; 0.75 0.25; 0.5 0.5; 0.25 0.75; 0 1];
assert_checkequal(b1, expected);

// bernstein of degree 2
b2 = bernstein(2, t);
expected = [1 0 0; 0.5625 0.375 0.0625; 0.25 0.5 0.25; 0.0625 0.375 0.5625; 0 0 1];
assert_checkequal(b2, expected);

// bernstein of degree 3
b3 = bernstein(3, t);
expected = [1 0 0 0;
            0.421875 0.421875 0.140625 0.015625; 
            0.125 0.375 0.375 0.125;
            0.015625 0.140625 0.421875 0.421875;
            0 0 0 1];
assert_checkequal(b3, expected);


t = linspace(0, 1, 100);
for i = 1:100
    b = bernstein(i, t);
    assert_checkalmostequal(sum(b, "c"), ones(100,1));
end

// t is scalar
t = 5;
b = bernstein(2, t);
expected = [1 0 0; 0.5625 0.375 0.0625; 0.25 0.5 0.25; 0.0625 0.375 0.5625; 0 0 1];
assert_checkequal(b, expected);

// check error
msg = msprintf(_("%s: Wrong value for input argument #%d: Positive numbers expected.\n"), "bernstein", 1);
assert_checkerror("bernstein(0, linspace(0, 1, 5))", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "bernstein", 1);
assert_checkerror("bernstein(1.5, linspace(0, 1, 5))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "bernstein", 1, sci2exp("double"));
assert_checkerror("bernstein(""1"", linspace(0, 1, 5))", msg);