// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021-2023 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- BENCH NB RUN : 1 -->

// <-- BENCH START -->
exec(fullfile("SCI", "modules", "differential_equations", "tests", "unit_tests", "sundials_cvode.tst"));

assert_checktrue(t2>t1);
// <-- BENCH END -->
