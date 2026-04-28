// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

assert_checkequal(nanmean([]), %nan);
assert_checkequal(nanmean(%nan), %nan);
assert_checkequal(nanmean([], "*"), %nan);
assert_checkequal(nanmean(%nan, "*"), %nan);
assert_checkequal(nanmean([%nan %nan; 1 1]), 1);
assert_checkequal(nanmean([%nan %nan; 1 1], "*"), 1);
assert_checkequal(nanmean([%nan %nan; 1 1], "r"), [1 1]);
assert_checkequal(nanmean([%nan %nan; 1 1], "c"), [%nan; 1]);
assert_checkequal(nanmean([%nan %nan; 1 1], 1), [1 1]);
assert_checkequal(nanmean([%nan %nan; 1 1], 2), [%nan; 1]);

assert_checkequal(nanmean([%nan 1; %nan 1]), 1);
assert_checkequal(nanmean([%nan 1; %nan 1], "*"), 1);
assert_checkequal(nanmean([%nan 1; %nan 1], "r"), [%nan 1]);
assert_checkequal(nanmean([%nan 1; %nan 1], "c"), [1; 1]);
assert_checkequal(nanmean([%nan 1; %nan 1], 1), [%nan 1]);
assert_checkequal(nanmean([%nan 1; %nan 1], 2), [1; 1]);

assert_checkequal(nanmean([1 2; %nan 6]), 3);
assert_checkequal(nanmean([1 2; %nan 6], "*"), 3);
assert_checkequal(nanmean([1 2; %nan 6], "r"), [1 4]);
assert_checkequal(nanmean([1 2; %nan 6], "c"), [1.5; 6]);
assert_checkequal(nanmean([1 2; %nan 6], 1), [1 4]);
assert_checkequal(nanmean([1 2; %nan 6], 2), [1.5; 6]);

assert_checkequal(nanmean([%nan 3*%s; 1 2]), 1+%s);
assert_checkequal(nanmean([%nan 3*%s; 1 2], "*"), 1+%s);
assert_checkequal(nanmean([%nan 3*%s; 1 2], "r"), [1 1+1.5*%s]);
assert_checkequal(nanmean([%nan %s; 1 1], "c"), [%s; 1]);
assert_checkequal(nanmean([%nan 3*%s; 1 2], 1), [1 1++1.5*%s]);
assert_checkequal(nanmean([%nan %s; 1 1], 2), [%s; 1]);

assert_checkequal(nanmean([%nan %t]), 1);
assert_checkequal(nanmean([%nan %t], "*"), 1);
assert_checkequal(nanmean([%nan %t], "r"), [%nan 1]);
assert_checkequal(nanmean([%nan %t], "c"), 1);
assert_checkequal(nanmean([%nan %t], 1), [%nan 1]);
assert_checkequal(nanmean([%nan %t], 2), 1);
