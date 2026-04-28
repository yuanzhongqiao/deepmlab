// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021-2023 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// residual of Robertson problem DAE
function res = robertsidae(t,y,yp,p)
    res = [yp(1)+p(1)*y(1)-p(2)*y(2)*y(3);
    yp(2)-p(1)*y(1)+p(2)*y(2)*y(3)+p(3)*y(2)*y(2);
    y(1)+y(2)+y(3)-1];
end

// jacobian of residual w.r.t. y
function j=jacy(t,y,yp,p)
 j = [p(1)  -p(2)*y(3)             -p(2)*y(2)    
     -p(1)   p(2)*y(3)+2*p(3)*y(2)  p(2)*y(2)
      1      1                      1]
endfunction

// jacobian of residual w.r.t. y'
function j=jacyp(t,y,yp,p)
 j = [1 0 0
      0 1 0
      0 0 0]; 
endfunction

// jacobian of residual w.r.t. p (parameter)
function j=jacp(t,y,yp,p)
    j = [ y(1) -y(2)*y(3) 0
         -y(1)  y(2)*y(3) y(2)^2
          0     0         0];
endfunction

// jacobian of residual w.r.t. y and yp
function j = jacres(t,y,yp,c,p)
    j = jacy(t,y,yp,p)+c*jacyp(t,y,yp,p);
endfunction

// sensitivity equation residual
function sensres=rS(t,y,yp,yS,ypS,p)
    sensres = jacy(t,y,yp,p)*yS + jacyp(t,y,yp,p)*ypS + jacp(t,y,yp,p);
endfunction


// Using original data and setup of
// examples/idas/serial/idasRoberts_FSA_dns.c
//
// In this example the sensitivity equation residual
// must be given by the user otherwise convergence
// with finite difference cannot be achieved.
//
// However, omiting the exact jacobian of residual is possible
// i.e. we do not use "jacobian" option below (jacobian of the residual)
// as exact sensitivity of the residual equation seems enough
par = [0.04;1e4;3e7];
y0 = [1;0;0];
yp0 = [0.1;0;0];
tspan = [0 0.4*10^(0:11)]
[t,y,info] = ida(robertsidae,tspan,y0,yp0,...
    rtol = 1e-8, atol = [1e-8;1e-14;1e-6],...
    sensRes = rS,...
    jacobian = jacres,...
    yIsAlgebraic = 3,...
    calcIc = "y0yp0",...
    sensPar = par);
    
// check final value of y and yp
assert_checkalmostequal(y(:,$),[0;0;1],0,1e-7)
assert_checkalmostequal(info.yp(:,$),[0;0;0],0,1e-14)

// check computed initial sensitivities
assert_checkalmostequal(info.s(:,:,1),zeros(3,3),0,%eps) 
assert_checkalmostequal(info.sp(:,:,1),[-1 0 0;1 0 0;0 0 0]) 

// check sensitivity equation residual in 2-matricial norm
for i=1:length(t)
    rsnorm=norm(rS(t(i),y(:,i),info.yp(:,i),info.s(:,:,i),info.sp(:,:,i),par));
    assert_checktrue(rsnorm < 1e-6);
end

//
// Sensitivity equation residual computed with complex step
// gives same results !
//
// residual Jacobian
function jac = jacres_complex(t,y,yp,c,p)
    jac = zeros(3,3);
    d = 1e-200;
    id = imult(d);
    yc = y;
    ypc = yp;
    for i=1:length(p)
        yc(i)=yc(i)+id;
        ypc(i)=ypc(i)+c*id;
        jac(:,i) = imag(robertsidae(t,yc,ypc))/d;
        yc(i)=y(i);
        ypc(i)=yp(i);
    end
endfunction

// sensitivity equation residual by complex step method
function sensres=rS_complex(t,y,yp,yS,ypS,p)
    sensres = zeros(length(y),length(p));
    d = 1e-200;
    id = imult(d);
    pc = p+imult(0);
    for i=1:length(p)
        pc(i)=p(i)+id;
        sensres(:,i) = imag(robertsidae(t,y+id*yS(:,i),yp+id*ypS(:,i),pc))/d;
        pc(i)=p(i);
    end
endfunction

[t,y_c,info_c] = ida(robertsidae,tspan,y0,yp0,...
    rtol = 1e-8, atol = [1e-8;1e-14;1e-6],...
    sensRes = rS_complex,...
    jacobian = jacres_complex,...
    yIsAlgebraic = 3,...
    calcIc = "y0yp0",...
    sensPar = par);
  
// check that we obtain almost exactly the same results
assert_checkalmostequal(y,y_c,0,1e-11)
assert_checkalmostequal(info.yp,info_c.yp,0,1e-11)
