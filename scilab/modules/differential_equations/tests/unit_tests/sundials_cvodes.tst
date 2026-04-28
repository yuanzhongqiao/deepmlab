// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// Compare true equations of sensitivity 
// with internal finite differences of cvodes

function dydt = vdp(t,y,mu)
    dydt = [y(2,:)
            mu*(1-y(1,:).*y(1,:)).*y(2,:)-y(1,:)];
end

function out=vdpJac(t,y,mu)
    out = [0 1
          -2*mu*y(1)*y(2)-1 mu*(1-y(1)*y(1))];
end

function dSdt = vdpSensRhs(t,y,S,mu)
    dSdt = vdpJac(t,y,mu)*S+[0;(1-y(1)^2)*y(2)];
end

function dySdt = vdpsens(t,yS,mu)
    y=yS(:,1);
    S=yS(:,2);
    dySdt = [vdp(t,y,mu) vdpSensRhs(t,y,S,mu)];
end

function out = myevent(t,y)
    out  = y(1)-1.7;
endfunction

mu = 1;
y0 = [2;1];

tspan = 0:0.1:10;
// here method = "ADAMS" is used (the default)
[t,ys] = cvode(list(vdpsens,mu), tspan, [y0 [0;0]],rtol=1e-10);
[t,y,info1] = cvode(vdp, 0:0.1:10, y0, sensPar=mu,rtol=1e-10);
[t,y,info2] = cvode(vdp, 0:0.1:10, y0, sensPar=mu,rtol=1e-10,sensErrCon=%t);

assert_checktrue(max(abs(squeeze(ys(:,2,:))-info1.s))<2e-4)
assert_checktrue(max(abs(squeeze(ys(:,2,:))-info2.s))<5e-5)

sol = cvode(vdp, 0:0.1:10, y0, sensPar=mu,rtol=1e-10, events=myevent);
sol1 = cvode(vdp, 0:0.1:10, y0, sensPar=mu,rtol=1e-10, sensCorrStep="simultaneous");
sol2 = cvode(vdp, 0:0.1:10, y0, sensPar=mu,rtol=1e-10, sensCorrStep="staggered");
sol3 = cvode(vdp, 0:0.1:10, y0, sensPar=mu,rtol=1e-10, sensRhs=vdpSensRhs);

assert_checkequal(sol2.stats.nRhsEvalsFD,786);
assert_checkequal(sol3.stats.nRhsEvalsFD,0);

// Another test with 3 parameters
function [f]=michaelis(t,C,p)
 // CA0 is p(1)
 Km = p(2);
 Vmax = p(3);
 f=-Vmax*C/(Km+C);
end

data = [
   0.      923.38533   45.      
   0.75    767.21761   41.415994
   1.5     696.12562   37.846265
   2.25    652.45205   34.293425
   3.      633.54049   30.760847
   3.75    566.87269   27.253008
   4.5     474.24043   23.775987
   5.25    346.09829   20.338329
   6.      354.623     16.952515
   6.75    273.43702   13.637678
   7.5     208.7877    10.42495 
   8.25    165.6477    7.3688374
   9.      102.75075   4.5730145
   9.75    43.6592     2.245501 
   10.5    14.305625   0.7334234
   11.25   3.0266653   0.150531 
   12.     0.4749311   0.05     
   12.75   0.0524342   0.05     
   13.5    0.0400235   0.05     
   14.25   0.          0.05     
   15.     0.0521208   0.05];
t_mesure=data(:,1);
CA_mesure=data(:,2);
sigma_mesure=data(:,3);

// parameter vector
param=[CA_mesure(1);20;80];
CA0=param(1);

sol = cvode(michaelis, t_mesure, CA0, sensPar=param, yS0=[1 0 0]);
sol = cvode(michaelis, t_mesure, CA0, sensPar=param, sensParIndex=[1 2], yS0=[1 0]);
[t,y,s] = cvode(michaelis, t_mesure, CA0, sensPar=param, sensParIndex=[1 2], yS0=[1 0]);

// SIR model

function dydt=sir(t,y,par)
    bet=par(1);
    gam=par(2);
    dydt=[-bet*y(1)*y(2)
           bet*y(1)*y(2)-gam*y(2)  
           gam*y(2)];
end
    
gam=1/15;
bet=0.1;

tspan=0:800;
y0=[1-1e-6;1e-6;0];
[t,y,info]=cvode(sir,tspan,y0,sensPar=[bet;gam],method="BDF");
assert_checkequal(size(info.s)(1:2),[3 2])












