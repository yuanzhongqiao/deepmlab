// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for hadamard function
// =============================================================================

assert_checkequal(hadamard([]), []);

assert_checkequal(hadamard(1), 1);

assert_checkequal(hadamard(2), [1 1; 1 -1]);

h = hadamard(4);
expected = [1 1 1 1; 1 -1 1 -1; 1 1 -1 -1; 1 -1 -1 1];
assert_checkequal(h, expected);
assert_checkequal(h*h', 4 * eye(4,4));

n = [12 16 20 28];
for i = n
    h = hadamard(i);
    assert_checkequal(h*h', i * eye(i, i));
end

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "hadamard", 1);
assert_checkerror("hadamard()", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "hadamard", 1, sci2exp("double"));
assert_checkerror("hadamard(""str"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be a scalar or empty.\n"), "hadamard", 1);
assert_checkerror("hadamard([1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Positive numbers expected.\n"), "hadamard", 1);
assert_checkerror("hadamard(-2)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Must be %d, %d, or a multiple of %d.\n"), "hadamard", 1, 1, 2, 4);
assert_checkerror("hadamard(5)", msg);