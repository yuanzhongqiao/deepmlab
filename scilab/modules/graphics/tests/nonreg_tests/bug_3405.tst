// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Sylvestre Koumar
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 3405 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3405
//
// <-- Short Description -->
// Scilab hangs but does not crash

// used to freeze Scilab
for i=1:100,
  h=scf(i);
  addmenu(i,'mymenu');
  delete(h);
end

