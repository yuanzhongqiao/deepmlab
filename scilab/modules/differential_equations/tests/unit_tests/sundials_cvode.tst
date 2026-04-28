// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021-2023 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function dydt = vdp(t,y,mu);
    dydt = [y(2,:);
            mu*(1-y(1,:).*y(1,:)).*y(2,:)-y(1,:)];
end

function out = crhs(t,y);
    out = 10*exp(2*%i*%pi*t)*y;
endfunction

function out=vdpJac(t,y,mu);
    out = [0 1
          -2*mu*y(1)*y(2)-1 mu*(1-y(1)*y(1))];
endfunction

function dySdt = vdpsens(t,yS,mu);
    y=yS(:,1);
    S=yS(:,2);
    dySdt = [vdp(t,y,mu) vdpJac(t,y,mu)*S+[0;(1-y(1)^2)*y(2)]];
end

function [out,term,dir] = myevent(t,y,term,dir);
    out  = y(1)-1.7;
endfunction


function xdot = matmul(t,x,A);
    xdot=A*x;
endfunction

function Xdot=ric(t,X,A,B,C);
    Xdot=A'*X+X*A-X'*B*X+C
endfunction

function acc = bounce(t,y,g);
    acc = [y(2); -g];
endfunction

function [out,term,dir] = bounce_ev(t,y);
    out = y(1);
    term = 1;
    dir = -1;
endfunction

function dydt=sir(t,y,bet,gam,N);
    dydt=[-bet/N*y(1)*y(2);
           bet/N*y(1)*y(2)-gam*y(2);
           gam*y(2)];
endfunction

function out = sir_ev(t,y,bet,gam,N);
    out = bet/N*y(1)*y(2)-gam*y(2);
endfunction

function out = scicallback(t,y,flag,stats);
    out = %f;
    if flag == "step"
        mprintf("%s : hLast=%g\n",flag,stats.hLast);
    end
endfunction

mu = 1;
y0 = [2;1];

//BASIC
[t,y] = cvode(list(vdp,mu), 0:0.1:10, y0);
assert_checkalmostequal(y(:,$),[ -1.69926222096315782117; -1.612661327686174983498]);
//VERY STIFF
[t,y] = cvode(list(vdp,1000), [0 10], y0, method="BDF",rtol=1e-10);
assert_checkalmostequal(y(:,$),[1.9936489238; -0.0006702151],1e-7);
 
[t,y] = cvode(list(vdp,mu), 0:0.1:10, y0, method="BDF");
assert_checkalmostequal(y(:,$),[ -1.701027506064791028351; -1.611750957657939409273]);

[t,y] = cvode(list(vdp,mu), 0:0.1:10, y0, method="BDF",rtol=1e-10);
[ts,ys] = cvode(list(vdp,mu), [0 10], y0, method="BDF",rtol=1e-10);
assert_checkalmostequal(y(:,$),ys(:,$),1e-7);

// EVENTS
[t,y,info] = cvode(list(vdp,mu), [0,10], y0, method="BDF",jacobian=list(vdpJac,mu),events=list(myevent,0,0));
assert_checkalmostequal(info.ye(1,:),[1.7,1.7 1.7]);
assert_checkalmostequal(info.te,[ 1.21746186   6.668978609   7.860696911]);
//
[t,y,info] = cvode(list(vdp,mu), [0,10], y0, method="BDF",jacobian=list(vdpJac,mu),events=list(myevent,0,-1));
assert_checkalmostequal(info.ye(1,:),[1.7, 1.7]);
assert_checkalmostequal(info.te,[ 1.21746186    7.860696911]);
//
[t,y,info] = cvode(list(vdp,mu), [0,10], y0, method="BDF",jacobian=list(vdpJac,mu),events=list(myevent,0,-1));
assert_checkalmostequal(info.ye(1,:),[1.7, 1.7]);
assert_checkalmostequal(info.te,[ 1.21746186    7.860696911]);
//
[t,y,info] = cvode(list(vdp,mu), [0,10], y0, method="BDF",jacobian=list(vdpJac,mu),events=list(myevent,1,1));
assert_checkequal(info.te, t($));
assert_checkalmostequal(info.ye(1,:),[1.7]);
assert_checkalmostequal(info.te,[6.668978609]);
//
[t,y,info] = cvode(list(vdp,mu), [0,10], y0, method="BDF",jacobian=list(vdpJac,mu),events=list(myevent,0,0));
sol = cvode(list(vdp,mu), [0,10], y0, method="BDF", jacobian=list(vdpJac,mu), events=list(myevent,0,0));
assert_checkequal(t,sol.t);
assert_checkequal(y,sol.y);
assert_checkequal(info.te,sol.te);
assert_checkequal(info.ye,sol.ye);
assert_checkequal(info.ie,sol.ie);
assert_checkalmostequal(sol(sol.t),(sol.y));

// EXTEND SOLUTION
sol = cvode(list(vdp,mu), [0 10], y0, method="BDF");
solext = cvode(sol, 20);
assert_checkequal(size(sol.t),[1,159]);
assert_checkequal(size(solext.t),[1,319]);
assert_checkequal(sol(sol.t),solext(sol.t));

//  EXTEND SOLUTION WITH EVENT
sol2 = cvode(list(vdp,mu), [0,10], y0, method="BDF",events=list(myevent,1,0));
sol2ext = cvode(sol2, 20);
assert_checkequal(sol2(sol2.t),sol2ext(sol2.t));

// MATRIX ODE
[t,y] = cvode(list(matmul,[1 1;0 2]), 1, eye(2,2), t0=0);
sol3 = cvode(list(matmul,[1 1;0 2]), 1, eye(2,2), t0=0);
assert_checkequal(size(sol3.y),[2,2,19]);
[t,E] = cvode(list(matmul,[1 1;0 2]), 1, eye(2,2), t0=0);
assert_checkalmostequal(E,[2.718281819604412952174   4.67056227186950945196 
   0.                        7.388844091473924180491]);

// MATRIX ODE
A=[1,1;0,2]; B=[1,0;0,1]; C=[1,0;0,1];
[t,X]=cvode(list(ric,[1,1;0,2],[1,0;0,1],[1,0;0,1]), %pi, eye(A),t0=0);
assert_checkalmostequal(X,[   2.272710085904093624265   0.615515434389987459163
   0.615515434389987459163   4.419093982274265641763 ]);

// COMPLEX ODE
solc = cvode(crhs,[0 5],1);
assert_checkalmostequal(solc.y(:,$),1,0,1e-3);
solcext1=cvode(solc,6);
solcext2=cvode(solc,6,y0=1);
assert_checkalmostequal(solcext2(5+10*%eps),1,0,100*%eps);
solcext3=cvode(solc,6,y0=%i);
assert_checkalmostequal(solcext3(5+10*%eps),%i,0,100*%eps);

// SENSITIVITY WITH COMPLEX STEP
h = 1e-200;
mu=1;
[tcs,ycs] = cvode(list(vdp,complex(mu,h)), [0,10], y0, rtol=1e-14);
scs = imag(ycs)/h;
[tcs,sens] = cvode(list(vdpsens,mu), tcs, [y0 [0;0]], rtol=1e-14);
sens = squeeze(sens(:,2,:));
assert_checktrue(max(abs(sens-scs)) < 3e-4);

// EXTEND SOLUTION + EVENTS,
sol = cvode(list(bounce,9.81), [0 10], [1;0], events=bounce_ev);
for i=1:100
    yini = sol.y(:,$).*[1;-0.9];
    sol = cvode(sol, 10, y0=yini);
    if sol.te($)-sol.te($-1) < 1e-3
        break;
    end
end
assert_checkalmostequal(sol.te($),8.5634978);
t = linspace(0, sol.t($), 10000);
//clf
//plot(sol.te, sol.ye(1,:), 'or', t, sol(t,1));

// REFINE+EVENTS
//clf
//drawlater
yini = [1;0];
te = 0;
while %t
    [t,y,info] = cvode(list(bounce,9.81), [te($) 100], yini, events=bounce_ev, refine=16);
    if info.te==[]
        break;
    end
    // plot(t,y(1,:),te,ye(1),'o');
    yini = y(:,$).*[1;-0.8];
    te = [te;info.te];
end
assert_checkalmostequal(te($), 4.0588273,0,1e-6);
//drawnow

// SIR MODEL
N=60e6;
gam=1/40;
bet=0.2;
y0=[N-1;1;0];
[t,y,info]=cvode(list(sir,bet,gam,N),[0 400],y0,events=sir_ev);
assert_checkalmostequal(info.te, 114.561646320925021314);
assert_checkalmostequal(info.ye,[7499999.999998786486685
   36903765.29698479920626
   15596234.70301640406251
]);
//clf
//plot(t,y,te,ye(2),'or');
//legend "Susceptible" "Infected" "Recovered"

//HEAT EQUATION
function [dv] = f_chaleur(t,v,h,lambda,c,rho);
	f=x>1/4 & x<1/3;
  dv = (f-lambda/h^2*( -[0;v(1:$-1)] + 2*v -[v(2:$);0] ))/c/rho;
endfunction
L=1; N=1000;
lambda = 1;
c=200;
rho=7893;
d=0.02;
tf=300;
section=%pi*d^2/4;
rhoLin=rho*section;
dx = L/N; x = linspace(dx,L-dx,N-1)';
v0=zeros(N-1,1);
t=[0 logspace(0,3,19)]; // vecteur des temps
timer();
[t,v] = cvode(list(f_chaleur,dx,lambda,c,rhoLin),t,v0,method="BDF",rtol=1e-5,atol=1e-7);
t1=timer()

v2=ode("stiff",v0,0,t,1e-5,1e-7,list(f_chaleur,dx,lambda,c,rhoLin));
t2 = timer()
assert_checktrue(max(abs(v-v2)) < 1e-6);

//POSITIVENESS
function out=fp(t,y);
     out = -y;
endfunction

[t,y] = cvode(fp,[0 70],1,atol=1e-12);
assert_checktrue(or(y < 0));
[t,y] = cvode(fp,[0 70],1,atol=1e-12,positive=1);
assert_checktrue(y > 0);

//SCILAB ERRORS
function fe1(t,y);
    out = -y;
endfunction
msg = msprintf(_("%s: Wrong number of output argument(s): %d expected."),"fe1",1);
assert_checkerror("cvode(fe1,[0 70],1)",msg);

function out = fe2(t,y);
    undefined_symbol
endfunction
msg = msprintf(_("Undefined variable: %s\n"),"undefined_symbol");
assert_checkerror("cvode(fe2,[0 70],1)",msg);

// SINGULAR SOLUTION AT T=1
function out = fe4(t,y);
    out = y^2;
endfunction
[t,y] = cvode(fe4,[0 2],1);
assert_checkalmostequal(t($),0.999630242);

// Using C compiled externals
//
// source is in SCI/modules/sundials/src/c/externals_for_tests.c
//

// int SUN_dynrhs(realtype t, N_Vector Y, N_Vector Yd, void *user_data);
// {
//     double *y = NV_DATA_S(Y);
//     double *yd = NV_DATA_S(Yd);
//     yd[0] = y[1];
//     yd[1] = (1-y[0]*y[0])*y[1]-y[0];
//     return 0;
// }
//
// int SUN_dynrhspar(realtype t, N_Vector Y, N_Vector Yd, void *user_data);
// {
//     double *y = NV_DATA_S(Y);
//     double *yd = NV_DATA_S(Yd);
//     double *mu = (double *)user_data;
//     yd[0] = y[1];
//     yd[1] = mu[0]*(1-y[0]*y[0])*y[1]-y[0];
//     return 0;
// }
//
// int SUN_dynjac(realtype t, N_Vector Y, N_Vector Yd, SUNMatrix J,
//     void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
// {
//     double *y = NV_DATA_S(Y);
//     double *jac = SM_DATA_D(J);
//     jac[0] = 0; jac[1] = -2*y[0]*y[1]-1;
//     jac[2] = 1.0; jac[3] = 1-y[0]*y[0];
//     return 0;
// }
//
// int SUN_dynjacpar(realtype t, N_Vector Y, N_Vector Yd, SUNMatrix J,
//     void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
// {
//     double *y = NV_DATA_S(Y);
//     double *jac = SM_DATA_D(J);
//     double *mu = (double *)user_data;
//     jac[0]=0; jac[1]=-2.0*mu[0]*y[0]*y[1]-1.0;
//     jac[2]=1.0; jac[3]=mu[0]*(1.0-y[0]*y[0]);
//     return 0;
// }
//
// int SUN_dyncb(realtype t, int iFlag, N_Vector N_VectorY, void *user_data);
// {
//     sciprint("flag=%d\n", iFlag);
//     return 0;
// }
//
// int SUN_dynevent(realtype t, N_Vector Y, realtype *gout, void *user_data);
// {
//     double *y = NV_DATA_S(Y);
//     gout[0] = y[0]-1.7;
//     return 0;
// }
//
// int SUN_dyneventpar(realtype t, N_Vector Y, realtype *gout, void *user_data);
// {
//     double *y = NV_DATA_S(Y);
//     double *par = (double *)user_data;
//     gout[0] = y[0]-par[0];
//     return 0;
// }

[tg,yg]=cvode('SUN_dynrhs',[0 10],[2;1]);
[t,y]=cvode(list(vdp,1),[0 10], [2;1]);
assert_checkalmostequal(y,yg,0,1e-6);

// RHS WITH PARAMETER
[tg,yg]=cvode(list('SUN_dynrhspar',1),[0 10], [2;1]);
assert_checkalmostequal(y,yg,0,1e-6);

// RHS WITH PARAMETER AND JACOBIAN
[t,y]=cvode(list(vdp,1),[0 10], [2;1],  method="BDF");
[tg,yg]=cvode('SUN_dynrhs',[0 10], [2;1], jacobian="SUN_dynjac");
assert_checkalmostequal(y,yg,1e-3);
[tg1,yg1]=cvode('SUN_dynrhs',[0 10], [2;1], jacobian=list(vdpJac,1));
assert_checkalmostequal(yg,yg1);

// CALLBACK
[t,y] = cvode(fe4,[0 0.5],1,callback="SUN_dyncb");
[t,y] = cvode(fe4,[0 1],1,callback=scicallback);

// EVENTS
[t,y] = cvode(list(vdp,1), [0 10], [2;1], events="SUN_dynevent",nbEvents=1,evTerm=1);
assert_checkalmostequal(y(1,$),1.7);

[t,y,info] = cvode(list(vdp,1), [0 10], [2;1], events="SUN_dynevent",nbEvents=1,evDir=1);
assert_checkequal(size(info.ye),[2 1]);

[t,y,info] = cvode(list(vdp,1), [0 10], [2;1], events="SUN_dynevent",nbEvents=1,evDir=-1);
assert_checkequal(size(info.ye),[2 2]);

// EVENTS WITH PARAMETER
[t,y,info] = cvode(list(vdp,1), [0 10], [2;1], events=list("SUN_dyneventpar",1),nbEvents=1,evTerm=1);
assert_checkalmostequal(info.ye(1),1);

[t,y,info] = cvode(list(vdp,1), [0 10], [2;1], events=list("SUN_dyneventpar",1.234),nbEvents=1,evTerm=1);
assert_checkalmostequal(info.ye(1),1.234);
