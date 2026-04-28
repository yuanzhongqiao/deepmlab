// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Paul Bignier
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
//
// <-- CLI SHELL MODE -->
//

loadXcosLibs();
ilib_verbose(0); //to remove ilib_* traces

// Define diagram
exec("SCI/modules/scicos/tests/unit_tests/Solvers/DAE/Bouncing.sce");

Info = scicos_simulate(scs_m, list(), 'nw');

// Modify solver + run DDaskr + save results
scs_m.props.tol(6) = 102;       // Solver
scicos_simulate(scs_m, Info, 'nw');   // DDaskr
ddaskrval = res.values;         // Results

// Modify solver + run IDA + save results
scs_m.props.tol(6) = 100;      // Solver
idaval = res.values;           // Results

// Compare results
compa = abs(ddaskrval-idaval);

// Extract mean, standard deviation, maximum
mea = mean(compa);
[maxi, indexMaxi] = max(compa);
stdeviation = stdev(compa);

// Verifying closeness of the results
assert_checktrue(maxi <= 5d-5);
assert_checktrue(mea <= 5d-5);
assert_checktrue(stdeviation <= 5d-5);
