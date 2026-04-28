// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function dydt = vdp(t,y,mu)
    dydt = [y(2,:)
            mu*(1-y(1,:).*y(1,:)).*y(2,:)-y(1,:)];
end

function out = crhs(t,y)
    out = 10*exp(2*%i*%pi*t)*y;
endfunction

function out=vdpJac(t,y,mu)
    out = [0 1
          -2*mu*y(1)*y(2)-1 mu*(1-y(1)*y(1))];
endfunction

function dySdt = vdpsens(t,yS,mu)
    y=yS(:,1);
    S=yS(:,2);
    dySdt = [vdp(t,y,mu) vdpJac(t,y,mu)*S+[0;(1-y(1)^2)*y(2)]];
end

function [out,term,dir] = myevent(t,y,term,dir)
    out  = y(1)-1.7;
endfunction


function xdot = matmul(t,x,A)
    xdot=A*x;
endfunction

function Xdot=ric(t,X,A,B,C)
    Xdot=A'*X+X*A-X'*B*X+C
endfunction

function acc = bounce(t,y,g)
    acc = [y(2); -g]
endfunction

function [out,term,dir] = bounce_ev(t,y)
    out = y(1);
    term = 1;
    dir = -1;
endfunction

function dydt=sir(t,y,bet,gam,N)
    dydt=[-bet/N*y(1)*y(2)
           bet/N*y(1)*y(2)-gam*y(2)
           gam*y(2)];
endfunction

function out = sir_ev(t,y,bet,gam,N)
    out = bet/N*y(1)*y(2)-gam*y(2)
endfunction

function out = scicallback(t,y,flag,stats)
    out = %f
    if flag == "step"
        mprintf("%s : hLast=%g\n",flag,stats.hLast)
    end
endfunction

mu = 1;
y0 = [2;1];

//BASIC
[t,y] = arkode(list(vdp,mu), 0:0.1:10, y0,atol=1e-9);
[tm,ym] = arkode(list(vdp,mu), 0:0.1:10, y0, method = "ERK_4",atol=1e-9);
assert_checkequal(y,ym);
assert_checkalmostequal(y(:,$),[   -1.698993908853207557286; -1.61397577130031244508]);

//METHODS
execstr("arkode(cos,[0 1],1,method="""")","errcatch");
mess = lasterror();
[_v,_v,_v,methods]=regexp(mess,"/\{(.*?)\}/");
methods=evstr(methods);
for m=methods
    if and(m<>["FORWARD_EULER_1_1"
"BACKWARD_EULER_1_1"
"IMPLICIT_MIDPOINT_1_2"
"IMPLICIT_TRAPEZOIDAL_2_2"])
        printf("%s : ",m);
        [tm,ym] = arkode(list(vdp,mu), 0:0.1:10, y0, method = m);
        printf("OK, ");
        sol = arkode(list(vdp,mu), [0 10], y0, method = m, hMax = 1, maxSteps=2000);
        printf("OK, ");
        arkode(list(vdp,mu), 0:0.1:10, y0, method = m);
        printf("OK\n");
    end
end

// EVENTS
[t,y,info] = arkode(list(vdp,mu), [0,10], y0,jacobian=list(vdpJac,mu),events=list(myevent,0,0));
assert_checkalmostequal(info.ye(1,:),[1.7,1.7 1.7]);
assert_checkalmostequal(info.te,[ 1.21746186   6.668978609   7.860696911],1e-4);
//
[t,y,info] = arkode(list(vdp,mu), [0,10], y0,jacobian=list(vdpJac,mu),events=list(myevent,0,-1));
assert_checkalmostequal(info.ye(1,:),[1.7, 1.7]);
assert_checkalmostequal(info.te,[ 1.21746186    7.860696911],1e-4);
//
[t,y,info] = arkode(list(vdp,mu), [0,10], y0,jacobian=list(vdpJac,mu),events=list(myevent,0,-1));
assert_checkalmostequal(info.ye(1,:),[1.7, 1.7]);
assert_checkalmostequal(info.te,[ 1.21746186    7.860696911],1e-4);
//
[t,y,info] = arkode(list(vdp,mu), [0,10], y0,jacobian=list(vdpJac,mu),events=list(myevent,1,1));
assert_checkequal(info.te, t($));
assert_checkalmostequal(info.ye(1,:),[1.7]);
assert_checkalmostequal(info.te,[6.668978609],1e-4);
//
[t,y,info] = arkode(list(vdp,mu), [0,10], y0,jacobian=list(vdpJac,mu),events=list(myevent,0,0));
sol = arkode(list(vdp,mu), [0,10], y0, jacobian=list(vdpJac,mu), events=list(myevent,0,0));
assert_checkequal(t,sol.t);
assert_checkequal(y,sol.y);
assert_checkequal(info.te,sol.te);
assert_checkequal(info.ye,sol.ye);
assert_checkequal(info.ie,sol.ie);
assert_checkalmostequal(sol(sol.t),(sol.y));

// EXTEND SOLUTION
sol = arkode(list(vdp,mu), [0 10], y0, atol=1e-9);
solext = arkode(sol, 20, atol=1e-9);
assert_checkequal(size(sol.t),[1,80]);
assert_checkequal(size(solext.t),[1,158]);
assert_checkequal(sol(sol.t),solext(sol.t));

//  EXTEND SOLUTION WITH EVENT
sol2 = arkode(list(vdp,mu), [0,10], y0,events=list(myevent,1,0));
sol2ext = arkode(sol2, 20);
assert_checkequal(sol2(sol2.t),sol2ext(sol2.t));

// MATRIX ODE
disp(1)
[t,y] = arkode(list(matmul,[1 1;0 2]), 1, eye(2,2), t0=0, atol=1e-9);
disp(2)
sol3 = arkode(list(matmul,[1 1;0 2]), 1, eye(2,2), t0=0, atol=1e-9);
disp(3)
assert_checkequal(size(sol3.y),[2,2,17]);
disp(4)
[t,E] = arkode(list(matmul,[1 1;0 2]), 1, eye(2,2), t0=0, atol=1e-9);
disp(5)
assert_checkalmostequal(E,[ 2.718281767 4.670543306; 0,7.388825073],1e-4);
disp(6);

// MATRIX ODE
A=[1,1;0,2]; B=[1,0;0,1]; C=[1,0;0,1];
[t,X]=arkode(list(ric,[1,1;0,2],[1,0;0,1],[1,0;0,1]), %pi, eye(A),t0=0,atol=1e-9);
assert_checkalmostequal(X,[  2.272713109   0.615508769; 0.615508769   4.41906588 ],1e-4);

// COMPLEX ODE
solc = arkode(crhs,[0 5],1,method="ERK_8",rtol=1e-10,atol=1e-12);
assert_checkalmostequal(solc.y(:,$),complex(1,0),0,1e-11);
solcext1=arkode(solc,6);
solcext2=arkode(solc,6,y0=1);
assert_checkalmostequal(solcext2(5+10*%eps),1,0,1e-11);
solcext3=arkode(solc,6,y0=%i);
assert_checkalmostequal(solcext3(5+10*%eps),%i,0,1e-11);

// SENSITIVITY WITH COMPLEX STEP
h = 1e-200;
mu=1
[tcs,ycs] = arkode(list(vdp,complex(mu,h)), [0,10], y0, rtol=1e-10,atol=1e-12,maxSteps=2000);
scs = imag(ycs)/h;
[tcs,sens] = arkode(list(vdpsens,mu), tcs, [y0 [0;0]], rtol=1e-10,atol=1e-12);
sens = squeeze(sens(:,2,:));
assert_checktrue(max(abs(sens-scs)) < 1e-8);

// EXTEND SOLUTION + EVENTS,
sol = arkode(list(bounce,9.81), [0 10], [1;0], events=bounce_ev);
for i=1:100
    yini = sol.y(:,$).*[1;-0.9];
    maxstep = max(sol.t($)-sol.t($-1),0.001);
    sol = arkode(sol, 10, y0=yini, hMax=maxstep);
    if sol.t($) <> sol.te($)
        break;
    end
end
assert_checkalmostequal(sol.te($),8.578733303);
t = linspace(0, sol.t($), 10000);
//clf
//plot(sol.te, sol.ye(1,:), 'or', t, sol(t,1))

// REFINE+EVENTS
//clf
//drawlater
yini = [1;0];
te = 0;
while %t
    [t,y,info] = arkode(list(bounce,9.81), [te($) 100], yini, events=bounce_ev, refine=16);
    if info.te==[]
        break;
    end
//    plot(t,y(1,:),info(1),'o')
    yini = y(:,$).*[1;-0.8];
    te = [te;info.te];
end
assert_checkalmostequal(te($), 4.0637128);
//drawnow

// SIR MODEL
N=60e6;
gam=1/40;
bet=0.2;
y0=[N-1;1;0];
[t,y,info]=arkode(list(sir,bet,gam,N),[0 400],y0,events=sir_ev);
assert_checkalmostequal(info.te, 114.56464,1e-6);
assert_checkalmostequal(info.ye,[   7499999.999999998137355
   36903375.03850146383047
   15596624.96149854548275
],1e-6);
//clf
//plot(t,y,info(2),'or');
//legend "Susceptible" "Infected" "Recovered"

//HEAT EQUATION
function [dv] = f_chaleur(t,v,h,lambda,c,rho)
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
timer();[t,v] = arkode(list(f_chaleur,dx,lambda,c,rhoLin),[0 3],v0,rtol=1e-5,atol=1e-7,method="ARK548L2SA_DIRK_8_4_5");t1=timer()
timer();v2=ode("stiff",v0,0,t,1e-5,1e-7,list(f_chaleur,dx,lambda,c,rhoLin));t2 = timer()
assert_checktrue(max(abs(v-v2)) < 1e-6);

// SCILAB ERRORS
function fe1(t,y)
    out = -y;
endfunction
msg = msprintf(_("%s: Wrong number of output argument(s): %d expected."),"fe1",1);
assert_checkerror("arkode(fe1,[0 70],1)",msg)

function out = fe2(t,y)
    undefined_symbol
endfunction
msg = msprintf(_("Undefined variable: %s\n"),"undefined_symbol");
assert_checkerror("arkode(fe2,[0 70],1)",msg)

// SINGULAR SOLUTION AT T=1
function out = fe4(t,y)
    out = y^2;
endfunction
[t,y] = arkode(fe4,[0 2],1,rtol=1e-8,maxSteps=2000);
assert_checkalmostequal(t($),1,1e-6)

// Linear ode
function out = f5(t,y,A)
    out = A*y;
endfunction
A = [2 1; 1 1];
y0 = [1;0];
[t,y1] = arkode(list(f5,A),[0:10],y0,jacobian=A);

// Linear ode with mass
function out = f5(t,y,A)
    out = A*y;
endfunction
function out = f5mass(t,y,A)
    out = (mass5(t)\A)*y;
endfunction
function out = mass5(t)
    mprintf("mass, t=%g\n",t)
    out = [10 0;0 10+t];
endfunction
A = [2 1; 1 1];
B = [0 1;-1 -1];
y0 = [1;0];
[t,y1] = arkode(list(f5,A),[0:10],y0,mass=B);
[t,y2] = arkode(list(f5,B\A),[0:10],y0);
assert_checktrue(max(abs(y1-y2))<1e-4)

[t,y] = arkode(fe4,[0 1],1,callback=scicallback);
