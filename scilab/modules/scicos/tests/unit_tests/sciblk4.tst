// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// This is a unit test for sciblk4 API to keep in sync with sciblk2.tst
//

loadXcosLibs

//
// Write a simulation function that output current time on event.
// This function does not have states.
//

function blk = sciblk4_tst(blk, flag)
    if and(flag <> 0:6) then pause, end
    if and(blk.nevprt <> [0 1]) then pause, end
    if blk.x <> [] then pause, end
    if blk.z <> [] then pause, end

    if blk.nrpar <> 2 then pause, end    
    if or(size(blk.rpar) <> [2 1]) then pause, end
    if blk.nipar <> 0 then pause, end
    if blk.ipar <> [] then pause, end
    if blk.inptr <> list() then pause, end

    if flag == 1 then
        // Output update
        blk.outptr = list(scicos_time());
    elseif flag == 4 then
        // Initialization
        blk.outptr = list(blk.rpar(1));
    elseif flag == 5 then
        // Ending
        blk.outptr = list(blk.rpar(2));
    end
endfunction

function [x,y,typ] = SCIBLK4_TST(job, arg1, arg2)
    x=[];
    y=[];
    typ=[];
    select job
    case "set" then
        x=arg1;
    case "define" then
        start_end=[10;20]
        model=scicos_model()
        model.sim=list("sciblk4_tst", 5)
        model.out=1
        model.evtin=1
        model.rpar=start_end
        model.blocktype="d"

        exprs=sci2exp(start_end)
        gr_i=[]
        x=standard_define([2 3], model, exprs,gr_i)
    end
endfunction

blk = SCIBLK4_TST("define");
clk = CLOCK_f("define");
l = scicos_link(from=[2 1 0], to=[1 1 1], ct=[1 -1]);
scs_m = scicos_diagram(objs = list(blk, clk, l));

scs_m.props.tf = 0;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(state0.tevts, 0.1);
assert_checkalmostequal(cpr.state.x,               state0.x,               scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.z,               state0.z,               scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(list2vec(cpr.state.oz),    list2vec(state0.oz),    scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.iz,              state0.iz,              scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.tevts,           state0.tevts,           scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.evtspt,          state0.evtspt,          scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.pointi,          state0.pointi,          scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(list2vec(cpr.state.outtb), 20, scs_m.props.tol(2), scs_m.props.tol(1));

scs_m.props.tf = 1;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, 1.1);
assert_checkalmostequal(cpr.state.outtb(1), 20);

scs_m.props.tf = 2;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, 2);
assert_checkalmostequal(cpr.state.outtb(1), 20);

scs_m.props.tf = 3;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, 3);
assert_checkalmostequal(cpr.state.outtb(1), 20);

//
// Write a simulation function that have a continuous state
//

function blk = sciblk4_tst_x(blk, flag)
    
    if and(flag <> 0:6) then pause, end
    if and(blk.nevprt <> [0 1]) then pause, end
    if blk.z <> [] then pause, end

    if or(size(blk.rpar) <> [2 1]) then pause, end
    if blk.ipar <> [] then pause, end
    if blk.inptr <> list() then pause, end

    if flag == 0 then
        // Continuous state update
        blk.xd = 1 ./ blk.x;
    elseif flag == 1 then
        // Output update
        blk.outptr = list(scicos_time());
    elseif flag == 4 then
        // Initialization
        blk.outptr = list(blk.rpar(1));
    elseif flag == 5 then
        // Ending
        blk.outptr = list(blk.rpar(2));
    end
endfunction

function [x,y,typ] = SCIBLK4_TST_X(job, arg1, arg2)
    x=[];
    y=[];
    typ=[];
    select job
    case "set" then
        x=arg1;
    case "define" then
        start_end=[10;20]
        model=scicos_model()
        model.sim=list("sciblk4_tst_x", 5)
        model.out=1
        model.rpar=start_end
        model.state=[0.1 ; 0.5 ; 1]
        model.dep_ut=[%f %t]
        model.blocktype="c"

        exprs=sci2exp(start_end)
        gr_i=[]
        x=standard_define([2 3], model, exprs,gr_i)
    end
endfunction

blk = SCIBLK4_TST_X("define");
scs_m = scicos_diagram(objs = list(blk));

scs_m.props.tf = 0;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.x,               state0.x,               scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.z,               state0.z,               scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(list2vec(cpr.state.oz),    list2vec(state0.oz),    scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.iz,              state0.iz,              scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.tevts,           state0.tevts,           scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.evtspt,          state0.evtspt,          scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(cpr.state.pointi,          state0.pointi,          scs_m.props.tol(2), scs_m.props.tol(1));
assert_checkalmostequal(list2vec(cpr.state.outtb), 20, scs_m.props.tol(2), scs_m.props.tol(1));

scs_m.props.tf = 1;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, []);
assert_checkalmostequal(cpr.state.outtb(1), 20);
assert_checkalmostequal(cpr.state.x, [ 1.4177416 ; 1.5000008 ; 1.7320511], scs_m.props.tol(2), scs_m.props.tol(1));

scs_m.props.tf = 2;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, []);
assert_checkalmostequal(cpr.state.outtb(1), 20);
assert_checkalmostequal(cpr.state.x, [ 2.0024962 ; 2.0615540 ; 2.2360680], scs_m.props.tol(2), scs_m.props.tol(1));

scs_m.props.tf = 3;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, []);
assert_checkalmostequal(cpr.state.outtb(1), 20);
assert_checkalmostequal(cpr.state.x, [ 2.4515306 ; 2.5000012 ; 2.6457512], scs_m.props.tol(2), scs_m.props.tol(1));

//
// Write a simulation function that have a discrete state
//

function blk = sciblk4_tst_z(blk, flag)

    printf("flag: %d   scicos_time: %lf    z: %lf\n", flag, scicos_time(), blk.z(1));

    if and(flag <> 0:6) then pause, end
    if and(blk.nevprt <> [0 1]) then pause, end
    if blk.x <> [] then pause, end
     
    if or(flag == [1, 2]) then
        assert_checkalmostequal(scicos_time() - blk.z(1), 0.1, scs_m.props.tol(2), scs_m.props.tol(1));
    end

    if or(size(blk.rpar) <> [2 1]) then pause, end
    if blk.ipar <> [] then pause, end
    if blk.inptr <> list() then pause, end
    assert_checkequal(blk.z, list2vec(blk.oz));

    if flag == 1 then
        // Output update
        blk.outptr = list(t);
    elseif flag == 2 then
        // State update
        blk.z(1) = scicos_time();
        blk.oz(1) = scicos_time();
    elseif flag == 4 then
        // Initialization
        blk.outptr = list(blk.rpar(1));
    elseif flag == 5 then
        // Ending
        blk.outptr = list(blk.rpar(2));
    end
endfunction

function [x,y,typ] = SCIBLK4_TST_Z(job, arg1, arg2)
    x=[];
    y=[];
    typ=[];
    select job
    case "set" then
        x=arg1;
    case "define" then
        start_end=[10;20]
        model=scicos_model()
        model.sim=list("sciblk4_tst_z", 5)
        model.out=1
        model.evtin=1
        model.rpar=start_end
        model.dstate=0:6
        model.odstate=list(list(0), 1, 2, 3, list(4), list(5), 6)
        model.blocktype="d"

        exprs=sci2exp(start_end)
        gr_i=[]
        x=standard_define([2 3], model, exprs,gr_i)
    end
endfunction

blk = SCIBLK4_TST_Z("define");
clk = CLOCK_f("define");
l = scicos_link(from=[2 1 0], to=[1 1 1], ct=[1 -1]);
scs_m = scicos_diagram(objs = list(blk, clk, l));

scs_m.props.tf = 0;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(state0.tevts, 0.1);
state0("outtb") = list(20);
for f=fieldnames(cpr.state)', assert_checkalmostequal(list2vec(cpr.state(f)), list2vec(state0(f)), scs_m.props.tol(2), scs_m.props.tol(1)); end

scs_m.props.tf = 1;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, 1.1);
assert_checkalmostequal(cpr.state.outtb(1), 20);

scs_m.props.tf = 2;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, 2);
assert_checkalmostequal(cpr.state.outtb(1), 20);

scs_m.props.tf = 3;
Info = scicos_simulate(scs_m);
[tcur, cpr, alreadyran, needstart, needcompile, state0] = Info(:);
assert_checkalmostequal(cpr.state.tevts, 3);
assert_checkalmostequal(cpr.state.outtb(1), 20);
