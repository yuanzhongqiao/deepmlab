// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 7691 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7691
//
// <-- Short Description -->
// Giving complex arguments to inverse degree trigonometric functions yields inconsistent results.

funmat = [
  "acosd"
  "acotd"
  "asind"
  "cosd"
  "cotd"
  "cscd"
  "secd"
  "sind"
  "tand"
];
for fname = funmat'
  instr = fname + "(%i)";
  execstr(instr,"errcatch");
  errmsg = lasterror();
  expected = fname + ": Wrong value for input argument #1: Real numbers expected.";
  if ( errmsg <> expected) then pause, end
end

refMsg = msprintf(_("%s: Wrong type for input argument #%d: Real matrix expected.\n"), "atand", 1);
assert_checkerror("atand(%i)", refMsg);
