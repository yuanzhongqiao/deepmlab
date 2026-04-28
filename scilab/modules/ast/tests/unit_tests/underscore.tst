// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->

function varargout = test()
    for i = 1:nargout
        varargout(i) = i;
    end
end

[a, b, c] = test();
assert_checkequal(a, 1);
assert_checkequal(b, 2);
assert_checkequal(c, 3);

[_ ,b ,c] = test();
assert_checkequal(b, 2);
assert_checkequal(c, 3);
assert_checkequal(_, gettext);

[a, _, c] = test();
assert_checkequal(a, 1);
assert_checkequal(c, 3);
assert_checkequal(_, gettext);

[a, b, _] = test();
assert_checkequal(a, 1);
assert_checkequal(b, 2);
assert_checkequal(_, gettext);

[_, _, c] = test();
assert_checkequal(c, 3);
assert_checkequal(_, gettext);

[_, b, _] = test();
assert_checkequal(b, 2);
assert_checkequal(_, gettext);

[a, _, _] = test();
assert_checkequal(a, 1);
assert_checkequal(_, gettext);
