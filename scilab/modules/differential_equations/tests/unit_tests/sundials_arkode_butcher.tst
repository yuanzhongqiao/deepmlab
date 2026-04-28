// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// check that internal tableau match custom version
A = [1 0; -1 1];
c = [1; 0];
b = [0.5 0.5];
d = [1 0];
q = 2;
p = 1;
[t1,y1] = arkode(%SUN_vdp1,1:10,[2;1], DIRKButcherTab=[c A;q b;p d]);
[t2,y2] = arkode(%SUN_vdp1,1:10,[2;1], method="SDIRK_2_1_2");
assert_checkequal(t1,t2)
assert_checkequal(y1,y2)

// check that internal tableau match custom version
A = [0 0; 1 0];
c = [0; 1];
b = [0.5 0.5];
d = [1 0];
q = 2;
p = 1;
[t1,y1] = arkode(%SUN_vdp1,1:10,[2;1], ERKButcherTab=[c A;q b;p d]);
[t2,y2] = arkode(%SUN_vdp1,1:10,[2;1], method="HEUN_EULER_2_1_2");
assert_checkequal(t1,t2)
assert_checkequal(y1,y2)

// test predefined custom tableaux
s=arkode(%SUN_vdp1,1:10,[2;1],ERKButcherTab=%SUN_Tsitouras5());
assert_checkequal(s.method,"USER_ERK_7_4_5");
assert_checkequal(s.stats.nSteps,34);
s=arkode(%SUN_vdp1,1:10,[2;1],ERKButcherTab=%SUN_DormandPrince6());
assert_checkequal(s.method,"USER_ERK_8_5_6");
assert_checkequal(s.stats.nSteps,26);
s=arkode(%SUN_vdp1,1:10,[2;1],ERKButcherTab=%SUN_DormandPrince8());
assert_checkequal(s.method,"USER_ERK_13_7_8");
assert_checkequal(s.stats.nSteps,19);

// fixed step examples
// RK4
A = [0 0 0 0;1/2 0 0 0;0 1/2 0 0;0 0 1 0];
c = [0; 1/2; 1/2; 1];
b = [1/6 1/3 1/3 1/6];
q = 4;
[t,y] = arkode(%SUN_vdp1,[1 10],[2;1], ERKButcherTab=[c A;q b], fixedStep=0.5);
// Backward Euler
[t,y] = arkode(%SUN_vdp1,[1 10],[2;1], DIRKButcherTab=[1 1;1 1], fixedStep=0.05);
// Implicit midpoint rule
[t,y] = arkode(%SUN_vdp1,[1 10],[2;1], DIRKButcherTab=[1/2 1/2;2 1], fixedStep=0.1);
// Implicit Trapezoidal rule
[t,y] = arkode(%SUN_vdp1,[1 10],[2;1], DIRKButcherTab=[0 0 0;1 1/2 1/2;2 1/2 1/2], fixedStep=0.1);
