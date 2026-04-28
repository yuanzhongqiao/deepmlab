// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


// Linear DAE
function out = res(t,y,yp,K,M)
    out = M*yp-K*y;
endfunction
function out = jac(t,y,yp,c,K,M) 
    out = c*M-K;
end
function out = jacsp(t,y,yp,c,K,M) 
    out = sparse(c*M-K);
end
K=(diag(1:5,1)+diag(-5:-1,-1)+diag(-1:4));
K=K/norm(K,"inf")
K=-K'*K;
M=-diag(diag(K));

y0=[1 -1 1 -1 1 -1]';
yp0=M\(K*y0);
yend=expm(M\K*100)*y0;

tspan = [0 100];
[t,y,info]=ida(list(res,K,M),tspan,y0,yp0);
assert_checktrue(max(abs(yend-y(:,$)))<1e-6)
assert_checktrue(max(abs(res(t,y,info.yp,K,M))) < 1e-4)

[t,yj]=ida(list(res,K,M),tspan,y0,yp0,jacobian={-K,M});
assert_checktrue(max(abs(yend-yj(:,$)))<1e-6)

[t,yjf]=ida(list(res,K,M),tspan,y0,yp0,jacobian=list(jac,K,M));
assert_checktrue(max(abs(yend-yjf(:,$)))<1e-6)

[t,yb]=ida(list(res,K,M),tspan,y0,yp0,jacBand=[2,2]);
assert_checktrue(max(abs(yend-yb(:,$)))<1e-6)

[t,ys]=ida(list(res,K,M),tspan,y0,yp0,jacobian={-sparse(K),sparse(M)});
assert_checktrue(max(abs(yend-ys(:,$)))<1e-6)

[t,ysf]=ida(list(res,K,M),tspan,y0,yp0,jacobian=list(jacsp,K,M));
assert_checktrue(max(abs(yend-ysf(:,$)))<1e-6)

K=complex(K,-K/2)
M=complex(M,-M/2)
y0=[1 -%i 1 -%i 1 -%i]';
yp0=M\(K*y0);
tspan = [0 100];
yend=expm(M\K*100)*y0;

[t,y]=ida(list(res,K,M),tspan,y0,yp0);
assert_checktrue(max(abs(yend-y(:,$)))<1e-5)

// Complex DAE, complex y0
[t,yj]=ida(list(res,K,M),tspan,y0,yp0,jacobian={-K,M});
assert_checktrue(max(abs(yend-yj(:,$)))<1e-5)

[t,yjf]=ida(list(res,K,M),tspan,y0,yp0,jacobian=list(jac,K,M));
assert_checktrue(max(abs(yend-yjf(:,$)))<1e-5)

[t,yb]=ida(list(res,K,M),tspan,y0,yp0,jacBand=[2,2]);
assert_checktrue(max(abs(yend-yb(:,$)))<1e-5)

[t,ys]=ida(list(res,K,M),tspan,y0,yp0,jacobian={-sparse(K),sparse(M)});
assert_checktrue(max(abs(yend-ys(:,$)))<1e-5)

[t,ysf]=ida(list(res,K,M),tspan,y0,yp0,jacobian=list(jacsp,K,M));
assert_checktrue(max(abs(yend-ysf(:,$)))<1e-5)

