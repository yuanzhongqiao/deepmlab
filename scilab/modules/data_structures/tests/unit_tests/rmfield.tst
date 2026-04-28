// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

stref = struct("a", 1, "b", 2, "c", 3, "d", 4);

// Error cases
// Wrong type for inputs
assert_checkerror("rmfield(42, ""ff"")", msprintf(gettext("%s: Wrong type for input argument #%d: Must be in %s.\n"), "rmfield", 1, sci2exp("struct")));
assert_checkerror("rmfield(stref, %F)", msprintf(gettext("%s: Wrong type for input argument #%d: Must be in %s.\n"), "rmfield", 2, sci2exp(["empty", "string", "cell"])));
assert_checkerror("rmfield(stref, 42)", msprintf(gettext("%s: Wrong type for input argument #%d: Must be in %s.\n"), "rmfield", 2, sci2exp(["empty", "string", "cell"])));
assert_checkerror("rmfield(stref, {42})", msprintf(gettext("%s: Wrong type for input argument #%d: A string matrix or a cell of strings expected.\n"), "rmfield", 2));
// Remove a field that does not exist
assert_checkerror("rmfield(stref, ""doesnotexist"")", msprintf(gettext("%s: Field ''%s'' does not exist.\n"), "rmfield", "doesnotexist"));

// Empty field case => do nothing
st = rmfield(stref, []);
assert_checkequal(st, stref);
st = rmfield(stref, {});
assert_checkequal(st, stref);

// Tests with different types & sizes for fields
st = rmfield(stref, ["a", "b"]); // Row vector
assert_checkequal(st, struct("c", 3, "d", 4));

st = rmfield(stref, ["a"; "b"; "c"]); // Column vector
assert_checkequal(st, struct("d", 4));

st = rmfield(stref, {"a", "b"; "c", "d"}); // 2-D cell
assert_checkequal(fieldnames(st), []);
