// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Joseph Agrane
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 17404 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17404
//
// <-- Short Description -->
// Integer multiplication gives wrong results.

// Test correctness of large-valued result
a = [1766319049 1766319049 1766319049];
b = [uint64("3119882982860264401") uint64("3119882982860264401") uint64("3119882982860264401")];
c = [1766319049 0 0];
d = uint64(zeros(3, 3));
d(1, 1) = uint64("3119882982860264401");
assert_checkequal(uint64(a(1)) .* uint64(a), b);
assert_checkequal(uint64(a) .* uint64(a(1)), b);
assert_checkequal(uint64(a(1)) * uint64(a), b);
assert_checkequal(uint64(a) * uint64(a(1)), b);
assert_checkequal(uint64(c)' * uint64(c), d);
assert_checkequal(uint64(c) * uint64(c)', uint64("3119882982860264401"));

// Test that integer multiplication still works (changes affect multiplication in general)
for cast = list(int8, int16, int32, int64)
    a = cast([3 4 5; 4 3 2; -1 -4 -3]);
    b = cast([1 0 1; -1 0 -1; 2 2 2]);
    c = cast([3 4 5]);

    exp1 = cast([20 4 8; 22 17 20; -16 -4 -4]);
    exp2 = cast([50 34 -34; 34 29 -22; -34 -22 26]);
    exp3 = cast([26 28 26; 28 41 38; 26 38 38]);
    exp4 = cast([3 4 5]);
    exp5 = cast([50 34 -34]);
    exp6 = cast([9 10 9]);
    exp7 = cast([8 -8 24]);

    assert_checkequal(a * a, exp1);
    assert_checkequal(a' * a', exp1');
    assert_checkequal(a * a', exp2);
    assert_checkequal(a' * a, exp3);
    assert_checkequal(a * c', exp5');
    assert_checkequal(c * b, exp6);
    assert_checkequal(b * c', exp7');

    assert_checkerror("a * c", "Operator *: Wrong dimensions for operation [3x3] * [1x3].");
end
for cast = list(uint8, uint16, uint32, uint64)
    a = cast([3 4 5; 4 3 2; 1 4 3]);
    b = cast([1 0 1; 1 0 1; 2 2 2]);
    c = cast([3 4 5]);

    exp1 = cast([30 44 38; 26 33 32; 22 28 22]);
    exp2 = cast([50 34 34; 34 29 22; 34 22 26]);
    exp3 = cast([26 28 26; 28 41 38; 26 38 38]);
    exp4 = cast([30 44 38]);
    exp5 = cast([50 34 34]);
    exp6 = cast([17 10 17]);
    exp7 = cast([8 8 24]);

    assert_checkequal(a * a, exp1);
    assert_checkequal(a' * a', exp1');
    assert_checkequal(a * a', exp2);
    assert_checkequal(a' * a, exp3);
    assert_checkequal(c * a, exp4);
    assert_checkequal(a * c', exp5');
    assert_checkequal(c * b, exp6);
    assert_checkequal(b * c', exp7');

    assert_checkerror("a * c", "Operator *: Wrong dimensions for operation [3x3] * [1x3].");
end
