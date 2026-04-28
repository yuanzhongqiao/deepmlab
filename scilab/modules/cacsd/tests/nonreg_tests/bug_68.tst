// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA -Serge Steer
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
//<-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 68 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/68
//
// <-- Short Description -->
//Precision problem with the trzeros function,

s=poly(0,"s");
A=[-113.63636,-2840909.1,113.63636,2840909.1,0,0;
1,0,0,0,0,0;
347.22222,8680555.6,-366.66667,-11111111,19.444444,2430555.6;
0,0,1,0,0,0;
0,0,50,6250000,-50,-6250000;
0,0,0,0,1,0];

System =syslin("c",A,[1;0;0;0;0;0],[0 0 0 1 0 0]);

Td=1/0.1;
alpha=1000;
Ti=1/0.1;
Tr=1/10000;
Kp=1e2;
PID=tf2ss(syslin("c",Kp*(1+Td*s)/(1+Td/alpha*s)));

Hrond1=PID*System;
closed1=(1/.(Hrond1));
ClosedZeros1=trzeros(closed1);

Hrond2=System*PID;
closed2=(1/.(Hrond2));
ClosedZeros2=trzeros(closed2);

computed1 = gsort(ClosedZeros1, "lr", ["d" "d"], list(imag, real));
computed2 = gsort(ClosedZeros2, "lr", ["d" "d"], list(imag, real));

assert_checkalmostequal ( computed1 , computed2, [] , 1.e-7 );

