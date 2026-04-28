//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

// residual function for a dissipative mechanical system with constraints:
function out = res(t,y,yd,n,sim,mass,Mass,par)
    // n is the dimension of x and u
    x = y(1:n);
    u = y(n+1:2*n);
    λ = y(2*n+1:$);
    xd = yd(1:n);
    ud = yd(n+1:2*n);

    // call the simulator
    [Vd,Dd,Fd] = sim(t,x,u,mass,par(:))

    out = [xd-u
           Mass.*ud+Vd.'+Dd.'-Fd.'*λ
           Fd*u];
end

function out = jac(t,y,yd,c,n,sim,mass,Mass,par)
    x = y(1:n);
    u = y(n+1:2*n);
    λ = y(2*n+1:$);
    nc = length(λ);
    xd = yd(1:n);
    ud = yd(n+1:2*n);
    h = 1e-200;
    e = zeros(n,1);
    Vdd = zeros(n,n);
    Ddd = zeros(n,n);
    Fdd = zeros(n,n,nc);    
    for i=1:n
        e(i)=h;
        [Vd,Dd,Fd] = sim(t,x+imult(e),u+imult(e),mass,par(:));
        Vdd(i,:) = imag(Vd)/h;
        Ddd(i,:) = imag(Dd)/h;
        Fdd(i,:,:) = (imag(Fd)/h)';
        e(i)=0;
    end
    Fd=real(Fd);
    I = eye(n,n);
    Fdu_x=zeros(nc,n);
    for k=1:nc
        Vdd = Vdd-λ(k)*Fdd(:,:,k);
        Fdu_x(k,:)=u'*Fdd(:,:,k);      
    end
    out=[c*I   -I                  zeros(n,nc)
         Vdd    Ddd+c*diag(Mass)  -Fd'
         Fdu_x  Fd                 zeros(nc,nc)]
endfunction

function varargout = compute(sim,tspan,x0,u0,mass,p1,p2,p3,p4,p5,p6,p7,p8)
    opt = checkNamedArguments();
    [nargout,nargin] = argn(); 
    nargin = nargin - size(opt,"*");
    
    if ~exists("rtol","local")
        rtol=1e-4;
    end
    if ~exists("atol","local")
        atol=1e-6;
    end

    // get number of bodies:
    nb = length(mass);
    // get dimension of state:
    n = length(x0);
    // guess number of coordinates per body:
    dim = round(n/nb);    

    // diagonal of mass matrix:
    Mass = mass(:).*.ones(dim,1);

    // parse eventual user parameters:
    if typeof(sim) == "list"
        par = list(sim(2:$));
        sim = sim(1);
    else
        par = list();
    end

    // call the simulator with initial conditions:
    [Vd0,Dd0,Fd0] = sim(tspan(1),x0,u0,mass,par(:))

    // get number of constraints:
    nc = size(Fd0,1);

    // compute initial value of lagrange multipliers by second total
    // derivative of the constraints:
    // Fd*ud + sum_{k=1}^nc u*Fdd_k*u where Fdd_k is the Hessian of f_k
    // then write ud according to second block of residual
    // 1: estimate Fdd_k*u, k=1..nc with a complex step
    // 2: solve linear system

    rhs = Fd0*((Vd0+Dd0)'./Mass);
    // note: evaluating directional derivative of Fd in direction u0
    // yields a matrix
    h = 1e-200;
    [?,?,Fd] = sim(tspan(1),x0+imult(h*u0),u0,mass,par(:));
    Fdd0 = imag(Fd)/h;
    rhs = rhs-Fdd0*u0;

    λ0 = (Fd0*(Fd0'./Mass(:,ones(1,nc))))\rhs;

    // compute initial accelerations:
    ud0 = (-Vd0'-Dd0'+Fd0'*λ0)./Mass
    // overall initial contitions:
    y0 = [x0;u0;λ0];
    yd0 = [u0;ud0;zeros(nc,1)];

    // solve the DAE 
    if exists("callback","local")
        λ_ind = 2*n+1:length(y0);
        [t,y,info] = ida(list(res,n,sim,mass,Mass,par),tspan,y0,yd0,...
            rtol=rtol,atol=atol,...
            yIsAlgebraic = λ_ind,suppressAlg = %t,...
            jacobian=list(jac,n,sim,mass,Mass,par), callback=callback)
        // yield x,u,ud,lambda,info
        varargout=list(t,y(1:n,:),y(n+1:2*n,:),info.yp(n+1:2*n,:),y(2*n+1:$,:),info);
    else
        λ_ind = 2*n+1:length(y0);
        ida(list(res,n,sim,mass,Mass,par),tspan,y0,yd0,...
            rtol=rtol,atol=atol,...
            yIsAlgebraic = λ_ind,suppressAlg = %t,...
            jacobian=list(jac,n,sim,mass,Mass,par));
        varargout=list();
    end
 endfunction































