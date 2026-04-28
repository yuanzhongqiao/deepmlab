//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function y=f(x)
    j = size(x,2);
    z = zeros(1,j);
    y = -2*sin(x)+[z;x(1:$-1,:).*x(1:$-1,:)]+[x(2:$,:).*x(2:$,:).*x(2:$,:);z];
    y = [y+y($:-1:1,:)]
    y = [y;y]
end

N=30;
x0 = linspace(-1,1,N);
sp = sparse(numderivative(f,x0));

// get computation engine
jacobian = spCompJacobian(f,sp,FiniteDifferenceType="COMPLEXSTEP");

// compute colored Jacobian
J = jacobian(x0);

assert_checkalmostequal(J,sp,0,1e-7)