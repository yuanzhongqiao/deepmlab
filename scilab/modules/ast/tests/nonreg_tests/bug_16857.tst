// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16857 -->
//
// <-- Bugzilla URL -->
// http://bugzilla.scilab.org/16857
//
// <-- Short Description -->
// the colon operator in start:step:stop sometimes exceeds the limit stop

sampFreq = 200
start = 0
stop = 28.705
sampPeriod = 1 ./ sampFreq;
t = start:sampPeriod:stop;
assert_checkequal(t($),stop)

for i=1:10000
    start = grand(1,1,"unf",0,1);
    stop = grand(1,1,"unf",0,1);
    n = grand(1,1,"uin",1,200);
    step = (stop-start)/n;
    t = start:step:stop;
    assert_checktrue((t($)-stop)/step <= 0);
end
