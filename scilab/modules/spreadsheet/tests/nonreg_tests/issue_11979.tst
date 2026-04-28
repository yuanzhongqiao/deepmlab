// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 11979 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11979
//
// <-- Short Description -->
// csvTextScan() reported errors non matching spaces as separator

// parsing with empty cell
data = csvTextScan(" 1  0 1", " ");
assert_checkequal(isnan(data), [%t %f %t %f %f]);

// parsing with consuming space
data = csvTextScan(";+1; 0;-1", ";");
assert_checkequal(isnan(data), [%t %f %f %f]);
assert_checkequal(data(2:$), [1 0 -1]);

// the positive value is correctly decoded, Nan are all around the place
str = [ "67200.999762419  40.966898   -0.262274  7279.7  0.77  13.6 0037"
        "67201.000202098  40.921647   -0.104834  9037.0  2.36  14.7 003f"
        "67201.001540389  40.926605   -0.119784  9622.2  1.63  15.1 003f"
        "67201.001670842  41.535461   -0.923526  3754.7  0.73  19.1 003f"
        "67201.001976426  40.951865   0.213778  9654.5  0.95  19.0 003e" ];

data = csvTextScan(str, " ");
assert_checkequal(data(5,6), 0.213778);