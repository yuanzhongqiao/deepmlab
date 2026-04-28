// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15732 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15732
//
// <-- Short Description -->
// In a "try" block, "continue" is ignored

for i = 1:4
    try
        continue
    end
    assert_generror("try -> continue execution failed");
end
assert_checkequal(i, 4);

for i = 1:4
    if i > 1 then
        assert_generror("try -> break execution failed");
    end

    try
        break
    end
    assert_generror("try -> break execution failed");
end
assert_checkequal(i, 1);

for i = 1:4
    try
        error("generate an error to catch")
    catch
        continue
    end
    assert_generror("try catch -> continue execution failed");
end
assert_checkequal(i, 4);

for i = 1:4
    if i > 1 then
        assert_generror("try catch -> break execution failed");
    end

    try
        error("generate an error to catch")
    catch
        break
    end
    assert_generror("try catch -> break execution failed");
end
assert_checkequal(i, 1);
 