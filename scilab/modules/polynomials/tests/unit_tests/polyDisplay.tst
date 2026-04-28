// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 UTC - Stéphane MOTTELET

//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

assert_checkequal(polyDisplay(),"ascii");
p = (%s-1)^3;
polyDisplay("ascii")
assert_checkequal(string(p),"-1 +3s -3s^2 +s^3")
polyDisplay("unicode")
assert_checkequal(string(p),"-1 +3s -3s² +s³")
