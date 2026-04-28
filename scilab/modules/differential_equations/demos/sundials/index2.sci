//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function out=res(t,y,yd)
    x=y(1:2);
    u=y(3:4);
    lambda=y(5);
    xd=yd(1:2);
    ud=yd(3:4);
    out=[xd-u
         ud-lambda*x+[0;g]
         x'*u];
endfunction

g=9.81;
l=1;
m=1;
theta0 = %pi/4
x0 = [cos(theta0) sin(theta0)]';
u0 = [0 0]';
lambda0 = -(u0'*u0-g*x0(2))/(x0'*x0);
lambda0=0;
y0 = [x0;u0;lambda0];
yd0 = [u0;-lambda0*x0-[0;g];0];

[t,y] = ida(res,[0 10],y0,yd0,yIsAlgebraic=5,suppressAlg=%t)
clf
plot(y(1,:),y(2,:))
isoview on
