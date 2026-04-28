// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function out=f(t,z)
    out = [z(1)*z(3)-%i*z(2);cos(z(1))*z(2)+z(3);z(1)*z(2)*z(3)];
end
function out=jf(t,z)
    out = [z(3) -%i z(1)
           -sin(z(1))*z(2)    cos(z(1))    1
           z(2)*z(3) z(1)*z(3) z(1)*z(2)]
end

function out=F(t,X)
    n=length(X);
    z=complex(X(1:2:$),X(2:2:$))
    zd=f(z);
    out = zeros(n,1);
    out(1:2:$)=real(zd);
    out(2:2:$)=imag(zd);
end
function out=JF(t,X)
    n=length(X);
    z=complex(X(1:2:$),X(2:2:$))
    jac=jf(z);
    jacr=real(jac);
    jaci=imag(jac);
    out = zeros(n,n);
    i=1:2:$;
    j=2:2:$;
    out(i,i)=jacr
    out(j,i)=jaci
    out(i,j)=-jaci
    out(j,j)=jacr
end

tspan=0:0.1:1;
z0=complex([0.1;0.2;0.3],[1;-1;1])
X0=zeros(6,1);
X0(1:2:$)=real(z0);
X0(2:2:$)=imag(z0);

[t,z]=cvode(f,tspan,z0)
[t,zd]=cvode(f,tspan,z0,jacobian=jf)

[t,X]=cvode(F,tspan,X0)
[t,Xd]=cvode(F,tspan,X0,jacobian=JF)

assert_checkequal(complex(X(1:2:$,:), X(2:2:$,:)), z)
assert_checkequal(complex(Xd(1:2:$,:), Xd(2:2:$,:)), zd)

[t,z]=arkode(f,tspan,z0)
[t,zd]=arkode(f,tspan,z0,jacobian=jf)

[t,X]=arkode(F,tspan,X0)
[t,Xd]=arkode(F,tspan,X0,jacobian=JF)

assert_checkequal(complex(X(1:2:$,:), X(2:2:$,:)), z)
assert_checkequal(complex(Xd(1:2:$,:), Xd(2:2:$,:)), zd)

// Complex rhs/Jacobian
A=[1+%i  1
  -1 %i];
function d=f(t,y)
     d=A*y
end
function out=fd(t,y)
    out=A;
end

z0=[1;-1+%i];
tspan=0:0.1:1;
[t,y]=cvode(f,tspan,z0,method="BDF")
[t,yd]=cvode(f,tspan,z0,jacobian=A)
[t,yfd]=cvode(f,tspan,z0,jacobian=fd)
assert_checkalmostequal(y,yd,1e-4,1e-4)
// outputs will not necessary match because when providing a constant Jacobian thru a
// function call, the solver looses the information that the rhs is linear
assert_checkalmostequal(yfd,yd)

// Complex rhs/band Jacobian
A=(diag(1:5,1)+diag(-5:-1,-1)+diag(-1:4));
A=A+sqrt(A);
A=A/norm(A,"inf")
JCONSTBAND = [[0;diag(A,1)] diag(A) [diag(A,-1);0]].';
//'

function d=f(t,y)
     d=A*y
end
function out=fd(t,y)
    out=JCONSTBAND;
end
z0=ones(6,1)+%i*(1:6)';
tspan=0:0.1:1;

[t,y]=arkode(f,tspan,z0,method="DIRK_5")
[t,yb]=arkode(f,tspan,z0,method="DIRK_5",jacBand=[1,1])
[t,yd]=arkode(f,tspan,z0,method="DIRK_5",jacobian=A)
[t,yjb]=arkode(f,tspan,z0,method="DIRK_5",jacBand=[1,1],jacobian=JCONSTBAND)
[t,yfb]=arkode(f,tspan,z0,method="DIRK_5",jacBand=[1,1],jacobian=fd)

assert_checkalmostequal(y(:,$),expm(A)*z0,1e-4)
assert_checkalmostequal(y,yb)
assert_checkalmostequal(y,yjb,1e-4,1e-4)
assert_checkalmostequal(yd,yjb)

// outputs will not necessary match because when providing a constant Jacobian thru a
// function call, the solver looses the information that the rhs is linear
assert_checkalmostequal(yjb,yfb)

// sparse Jacobian or Mass + complex
JCONSTSPARSE=sparse(A);
function d=f(t,y)
     d=JCONSTSPARSE*y
end
function out=fd(t,y)
    out=JCONSTSPARSE;
end
[t,ysp]=arkode(f,tspan,z0,method="DIRK_5",jacobian=JCONSTSPARSE);
[t,yspfd]=arkode(f,tspan,z0,method="DIRK_5",jacobian=fd);
// results slightly differ because linear solver is different here (sparse klu instead of dense solver)
// but since SUNDIALS 7.4 the discrepancy is abnormally larger
assert_checkalmostequal(ysp,yd,0,1e-6)
// outputs will not necessary match because when providing a constant Jacobian thru a
// function call, the solver looses the information that the rhs is linear
assert_checkalmostequal(ysp,yspfd)

// // here ode is complex only due to z0 (Jacobian is real)
JCONSTSPARSE=real(JCONSTSPARSE);
function d=f(t,y)
    d=JCONSTSPARSE*y
end
function out=fd(t,y)
    out=JCONSTSPARSE;
end
[t,ysp]=arkode(f,tspan,z0,method="DIRK_5",jacobian=JCONSTSPARSE);
[t,yspfd]=arkode(f,tspan,z0,method="DIRK_5",jacobian=fd);
// // results slightly differ because linear solver is different here (sparse klu instead of dense solver)
assert_checkalmostequal(ysp,yspfd)

// final test, everything is real
z0=ones(6,1);
[t,ysp]=arkode(f,tspan,z0,method="DIRK_5",jacobian=JCONSTSPARSE);
[t,yspfd]=arkode(f,tspan,z0,method="DIRK_5",jacobian=fd);
// // results slightly differ because linear solver is different here (sparse klu instead of dense solver)
assert_checkalmostequal(ysp,yspfd)
