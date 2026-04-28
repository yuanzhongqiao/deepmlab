// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2007-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for datevec function
// =============================================================================


warning("off"); // WARNING_EMPTY_OPS
assert_checkequal(datevec(1), [0,1,1,0,0,0]);
assert_checkequal(datevec(719529), [1970,1,1,0,0,0]);

in  = [ 158493 247745 637308 ; 567032 499035 514298 ; 165 471293 658662 ];
out = [ 433 12 8 0 0 0; ..
1552 6  24  0 0 0 ; ..
0    6  13  0 0 0 ; ..
678  4  20  0 0 0 ; ..
1366 4  23  0 0 0 ; ..
1290 5  9   0 0 0 ; ..
1744 11 20  0 0 0 ; ..
1408 2  6   0 0 0 ; ..
1803 5  10  0 0 0];

assert_checkequal(datevec(in), out);

in  = [ 250000 500000 750000 1000000 ];
out = datevec(in);
assert_checktrue(size(out) == [4 6]);

in  = [ 250000 500000 ; 750000 1000000 ];
out = datevec(in);
assert_checktrue(size(out) == [4 6]);

in  = [ 250000 ; 500000 ; 750000 ; 1000000 ];
out = datevec(in);
assert_checktrue(size(out) == [4 6]);

out = datevec(datenum(2025, 04, 22, 1, 0, 0));
assert_checkequal(out, [2025,4,22,1,0,0]);

// Check no rounding on time
ss = [0:59]';
sizeSS = size(ss, '*');
mm = [0:59]';
sizeMM = size(mm, '*');
hh = [0:23]';
sizeHH = size(hh, '*');

allDates = [ 2025 .*. ones(sizeHH * sizeMM * sizeSS, 1), ...
            4 .*. ones(sizeHH * sizeMM * sizeSS, 1), ...
            22 .*. ones(sizeHH * sizeMM * sizeSS, 1), ...
            hh .*. ones(sizeMM * sizeSS, 1), ...
            ones(sizeHH, 1) .*. mm .*. ones(sizeSS, 1), ...
            ones(sizeHH * sizeMM, 1) .*. ss];
convertedDates = datevec(datenum(allDates(:,1), allDates(:,2), allDates(:,3), allDates(:,4), allDates(:,5), allDates(:,6)));
assert_checkequal(convertedDates, allDates);