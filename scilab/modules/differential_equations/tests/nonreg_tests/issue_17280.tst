// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
// <-- WINDOWS ONLY -->
//
// <-- Non-regression test for issue 17280 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17280
//
// <-- Short Description -->
// cvode crashes scilab under Windows because of uncaught exception

n = 20;
tfinal = 35;
L = 6;
dz = L/n;
u = .2;
Cf = 500;

function dCdt = odefun(t,C)
    dCdt      = zeros(n,1);
    dCdz      = zeros(n,1);
    ksi       = 0.001*C.**2.01;
    dCdz(1)   = ( C(1)-Cf ) / dz;
    dCdz(2:n) = ( C(2:n)-C(1:(n-1)) ) ./ dz;
    dCdt      = -u*dCdz - ksi;
endfunction

ic   = zeros(n,1);
time = linspace(0, tfinal);

assert_checkerror("[t,y] = cvode(odefun, time, ic)","odefun: Unexpected complex type output after initialization phase.");
