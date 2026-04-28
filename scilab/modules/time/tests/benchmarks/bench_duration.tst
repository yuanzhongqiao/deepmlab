// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- BENCH NB RUN : 1 -->

// <-- BENCH START -->
// Example from MR !1213
h = floor(rand(2e6, 1)*24)+1;
d = string(h) + ":00";
timer();
dd = duration(d, "InputFormat", "hh:mm");
assert_checktrue(timer() < 3);
// <-- BENCH END -->
