// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- LONG TIME EXECUTION -->

// Checks that this test is skipped because it requires a long time (5 seconds).
delay = 5;
j = 2;
timer();
while ( %t )
  t = timer()
  if ( t > delay ) then
    break
  end
  j = j+1;
end
