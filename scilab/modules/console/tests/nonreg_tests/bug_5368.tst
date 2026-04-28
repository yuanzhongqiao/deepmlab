// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 5368 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5368
//
// <-- Short Description -->
//

v = [];
for i = 1:20
  v = input('Hit Return');
  if v <> [] then
    disp('NOK');
  else
    disp('OK');
  end
end
