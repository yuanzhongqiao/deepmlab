// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021-2023 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// basic example
function out = res(t,y,yp)
    out = y+yp;
end
[t,y] = ida(res,[0 5],1,-1);


// SIR MODEL
function res = sir(t,y,yp,bet,gam,N)
    res=[yp(1)+bet/N*y(1)*y(2)
         yp(2)-bet/N*y(1)*y(2)+gam*y(2)
         y(1)+y(2)+y(3)-N];
end
function jac = sir_jac(t,y,yp,c,bet,gam,N)
    jac = [ bet/N*y(2)+c  bet/N*y(1)     0
            -bet/N*y(2) -bet/N*y(1)+gam+c 0
             1           1              1];
end
function out = sir_ev(t,y,yp,bet,gam,N)
    out = yp(2);
end
N=60e6;
gam=1/40;
bet=0.2;
y0=[N-1;1;0];
yp0 = [-bet/N*y0(1)*y0(2);+bet/N*y0(1)*y0(2)-gam*y0(2);gam*y0(2)];
[t,y,info] = ida(list(sir,bet,gam,N),[0 400],y0,yp0,events=list(sir_ev,bet,gam,N));
assert_checkalmostequal(info.te,114.56018)
assert_checkalmostequal(info.ype(2),0,0,1e-6)

// with jacobian and extending solution
sol = ida(list(sir,bet,gam,N),[0 200],y0,yp0);
sol2 = ida(list(sir,bet,gam,N),[0 200],y0,yp0,jacobian=list(sir_jac,bet,gam,N));

assert_checkalmostequal(sol(sol.t),sol.y)
sol2 = ida(sol,400);
assert_checkalmostequal(sol2(sol.t),sol.y)
assert_checkalmostequal(sol2(sol2.t),sol2.y)

// compute initial condition
[t,y] = ida(list(sir,bet,gam,N),0:400,y0,yp0,rtol=1e-14);
y0=[N-1;1;0];
yp0 = [0;0;0];
[tt,yy]= ida(list(sir,bet,gam,N),0:400,y0,yp0,rtol=1e-14,calcIc="y0yp0",yIsAlgebraic=3);
assert_checkalmostequal(yy(:,$),y(:,$),1e-6);

// Robertson problem
function res = robertsidae(t,y,yp)
    res = [yp(1)+0.04*y(1)-1e4*y(2)*y(3);
    yp(2)-0.04*y(1)+1e4*y(2)*y(3)+3e7*y(2)*y(2);
    y(1)+y(2)+y(3)-1];
end

y0 = [1-1e-3; 0; 1e-3];
yp0 = [-0.0400; 0.0400; 0];
tspan = [0 4e6];
[t,y] = ida(robertsidae,tspan,y0,yp0,h0=1e-6,maxSteps=2000);
solr = ida(robertsidae,tspan,y0,yp0,h0=1e-6,maxSteps=2000);
// compute initial condition of algebraic state
y0 = [1-1e-3; 0; 0];
yp0 = [-0.0400; 0.0400; 0];
[t,y] = ida(robertsidae,tspan,y0,yp0,h0=1e-6,calcIc="y0yp0",yIsAlgebraic=3,maxSteps=2000);

// Linear DAE
function out = res(t,y,yp,A,B)
    out = A*yp-B*y;
endfunction
A = [2 1; 1 1];
B = [0 1;-1 -1];
y0 = [1;0];
yp0 = A\(B*y0);
sol = ida(list(res,A,B),[0 10],y0,yp0);
assert_checkequal(sol.stats.nRhsEvalsFD,40);
solj = ida(list(res,A,B),[0 10],y0,yp0,jacobian={-B,A});
assert_checkequal(solj.stats.nRhsEvalsFD,0);
[t,y,info] = ida(list(res,A,B),[0 10],y0,zeros(2,1),calcIc="y0yp0");
assert_checkalmostequal(info.yp(:,1),yp0);

// fully implicit
function res = weissinger(t,y,yp)
    res=t*y^2 * yp^3 - y^3 * yp^2 + t*(t^2 + 1)*yp - t^2 * y;
end
t0=1;
y0=sqrt(3/2);
yp0=0;
[t,y,info]=ida(weissinger,[1 10],y0,yp0,calcIc="y0yp0");
assert_checkalmostequal(info.yp(:,1),0.816496582)

// Using C compiled externals
//
// source is in SCI/modules/sundials/src/c/externals_for_tests.c
//
// int SUN_chemres(realtype t, N_Vector Y, N_Vector Yd, N_Vector R, void *user_data)
// {
//     double *y = NV_DATA_S(Y);
//     double *yd = NV_DATA_S(Yd);
//     double *r =  NV_DATA_S(R);
//     r[0] = yd[0]+0.04*y[0]-1.0e4*y[1]*y[2];
//     r[1] = yd[1]-0.04*y[0]+1.0e4*y[1]*y[2]+3.0e7*y[1]*y[1];
//     r[2] = y[0]+y[1]+y[2]-1;
//     return 0;
// }
//exec("sundials_ida.tst");

// int SUN_chemjac(realtype t, realtype cj, N_Vector Y, N_Vector Yd, N_Vector R, SUNMatrix J,
//     void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3)
// {
//     double *y = NV_DATA_S(Y);
//     double *jac = SM_DATA_D(J);
//     /* first column*/
//     jac[0] = 0.04+cj;
//     jac[1] =  -0.04;
//     jac[2] =  1.0;
//     /* second column*/
//     jac[3] =  -1.0e4*y[2];
//     jac[4] = +1.0e4*y[2]+2*3.0e7*y[1]+cj;
//     jac[5] =  1.0;
//     /* third column*/
//     jac[6] =  -1.0e4*y[1];
//     jac[7] = +1.0e4*y[1];
//     jac[8] =  1.0;
//     return 0;
// }
//
// int SUN_chemevent(realtype t, N_Vector Y, N_Vector Yd, realtype *gout, void *user_data)
// {
//     double *yd = NV_DATA_S(Yd);
//     gout[0] = yd[1];
//     return 0;
// }
//
// int SUN_chemcb(realtype t, int iFlag, N_Vector Y, N_Vector Yd, void *user_data)
// {
//     double *y = NV_DATA_S(Y);
//     double *yd = NV_DATA_S(Yd);
//     sciprint("t=%f, y2=%e, yp2=%e\n",t,y[1],yd[1]);
//     return 0;
// }

y0 = [1-1e-3; 0; 1e-3];
yp0 = [-0.0400; 0.0400; 0];
tspan = [0 4e6];

[t1,y1,info1] = ida("SUN_chemres",tspan,y0,yp0,maxSteps=2000);
[t2,y2,info2] = ida(robertsidae,tspan,y0,yp0,maxSteps=2000);
[t3,y3,info3] = ida("SUN_chemres",tspan,y0,yp0,jacobian="SUN_chemjac");

assert_checktrue(max(abs(y1(:,$)-y2(:,$)))<=1e-6)
assert_checktrue(max(abs(info1.yp(:,$)-info2.yp(:,$)))<=1e-10)
assert_checktrue(size(t1)/size(t3) > 2)

//test dynamic event
[t3,y3,info] = ida("SUN_chemres",tspan,y0,yp0,jacobian="SUN_chemjac",events="SUN_chemevent",nbEvents=1);
assert_checkequal(info.te,4.84950409816763735D-03)

//test dynamic callback
[t1,y1] = ida("SUN_chemres",tspan,y0,yp0,callback="SUN_chemcb",maxSteps=2000);


