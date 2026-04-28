// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2030 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2030
//
// <-- Short Description -->
// When runing the following loop, Scilab crashes when n is big (13000000 for instance)

// <-- INTERACTIVE TEST -->

for i=1:n
  eps=grand(650,1,'nor',0,1)
end

// Copy/Paste this code inside Scilab console, takes a long time but does not crash!
