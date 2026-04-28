// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- BENCH NB RUN : 1 -->

// <-- BENCH START -->
exec(fullfile("SCI", "modules", "differential_equations", "tests", "unit_tests", "sundials_arkode_omp.tst"));

if with_openmp
    assert_checktrue(info2.stats.eTime > info1.stats.eTime);
end
// <-- BENCH END -->
