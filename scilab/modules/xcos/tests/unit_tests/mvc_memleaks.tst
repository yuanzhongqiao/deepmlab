// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- TEST WITH XCOS -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//
// <-- Short Description -->
// Check that a diagram import and a simulation does not leak MVC objects.


function check_memleaks(diary_id)
    diary(diary_id, "close");

    log = mgetl(TMPDIR + "/mvc_leak.log");
    log = log(grep(log, ["objectCreated", "objectDeleted"]));

    disp(log)
    objects = strtod(csvTextScan(log, " ", ".", "string")(:, 7));
    objects = gsort(objects);

    leaks = objects(2*find((objects(1:2:$-1) - objects(2:2:$))));
    if leaks <> [] then
        scicos_log("WARNING");
        error("check_memleaks found leaks at " + string(leaks));
    end
endfunction

loadXcosLibs();
scicos_log("INFO");


diary_id = diary(TMPDIR + "/mvc_leak.log");
scs_m = scicosDiagramToScilab(SCI+"/modules/xcos/tests/unit_tests/mvc_memleaks_Discrete_KalmanFilter.ssp");
clear scs_m;
check_memleaks(diary_id);

diary_id = diary(TMPDIR + "/mvc_leak.log");
scs_m = scicosDiagramToScilab(SCI+"/modules/xcos/tests/unit_tests/mvc_memleaks_Discrete_KalmanFilter.ssp");
xcos_simulate(scs_m, 4);
clear scs_m;
check_memleaks(diary_id);

deletefile(TMPDIR + "/mvc_leak.log");
