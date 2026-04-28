// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// load an old COSF file from Scilab 5.5.2 and save it to SSP
// this will test the Adapters and the SSP save/load

loadXcosLibs();

function scs_m = load_552_file()
    // within a function to cleanup temporaries
    exec("SCI/modules/scicos/tests/unit_tests/pendulum_anim45_552.cosf", -1);
endfunction

scs_m_552 = load_552_file();
scicosDiagramToScilab("pendulum_anim45_552.ssp", scs_m_552);

// load it back
scs_m_ssp = scicosDiagramToScilab("pendulum_anim45_552.ssp");

// check using the cpr version of these diagrams, the block order might change but the compiled version is the same
alreadyran = %f;
[%cpr_552,ok] = do_compile(scs_m_552);
assert_checktrue(ok);
alreadyran = %f;
[%cpr_ssp,ok] = do_compile(scs_m_ssp);
assert_checktrue(ok);

assert_checkequal(%cpr_ssp.state, %cpr_552.state);
assert_checkequal(%cpr_ssp.sim, %cpr_552.sim);
// cor and corinv are different due to block ordering
// assert_checkequal(%cpr_ssp.cor, %cpr_552.cor);
// assert_checkequal(%cpr_ssp.corinv, %cpr_552.corinv);
