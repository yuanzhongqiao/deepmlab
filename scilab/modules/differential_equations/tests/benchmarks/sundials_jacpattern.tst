// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- BENCH NB RUN : 1 -->

// <-- BENCH START -->
exec(fullfile("SCI", "modules", "differential_equations", "tests", "unit_tests", "sundials_jacpattern.tst"));

assert_checktrue(info0cvode.stats.eTime/info1cvode.stats.eTime > 10);
assert_checktrue(info0cvode.stats.eTime/info2cvode.stats.eTime > 20);
assert_checktrue(info0cvode.stats.eTime/info3cvode.stats.eTime > 20);

assert_checktrue(info0arkode.stats.eTime/info1arkode.stats.eTime > 5);
assert_checktrue(info0arkode.stats.eTime/info2arkode.stats.eTime > 5);
assert_checktrue(info0arkode.stats.eTime/info3arkode.stats.eTime > 5);
// <-- BENCH END -->
