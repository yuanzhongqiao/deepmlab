// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// Built from sundials/examples/cvode/serial/cvParticle_dns.c
// -----------------------------------------------------------------------------
// This example solves the equation for a particle moving conterclockwise with
// velocity alpha on the unit circle in the xy-plane. The ODE system is given by
//
//   x' = -alphay
//   y' =  alphax
//
// where x and y are subject to the constraint
//
//   x^2 + y^2 - 1 = 0
//
// with initial condition x = 1 and y = 0 at t = 0. The system has the analytic
// solution
//
//  x(t) = cos(alphat)
//  y(t) = sin(alphat)
// ---------------------------------------------------------------------------

function Xd=f(t,X,alpha)
    Xd = alpha*[-X(2);X(1)];
end
function corr=proj(t,X,err)
   Xp=X/norm(X);
   corr=Xp-X;
end

alpha=1;
X0=[1;0];
tspan=0:10;

[tp,Xp]=cvode(list(f,alpha),tspan,X0,rtol=1e-4,atol=1e-9,jacobian=[0 -alpha, alpha 0],projection=proj);
[t,X]=cvode(list(f,alpha),tspan,X0,rtol=1e-4,atol=1e-9,jacobian=[0 -alpha, alpha 0]);
assert_checktrue(max(abs(X(1,:).^2+X(2,:).^2-1)) > 1e-4);
assert_checkalmostequal(Xp(1,:).^2+Xp(2,:).^2,ones(tp));

// Built from sundials/examples/cvode/serial/cvPendulum_dns.c
// -----------------------------------------------------------------------------
// This example solves a simple pendulum equation in Cartesian coordinates where
// the pendulum bob has mass 1 and is suspended from the origin with a rod of
// length 1. The governing equations are
//
// x'  = vx
// y'  = vy
// vx' = -x * T
// vy' = -y * T - g
//
// with the constraints
//
// x^2 + y^2 - 1 = 0
// x * vx + y * vy = 0
//
// where x and y are the pendulum bob position, vx and vy are the bob velocity
// in the x and y directions respectively, T is the tension in the rod, and
// g is acceleration due to gravity chosen such that the pendulum has period 2.
// The initial condition at t = 0 is x = 1, y = 0, vx = 0, and vy = 0.
//
// A reference solution is computed using the pendulum equation in terms of the
// angle between the x-axis and the pendulum rod i.e., theta in [0, -pi]. The
// governing equations are
//
// theta'  = vtheta
// vtheta' = -g * cos(theta)
//
// where theta is the angle from the x-axis, vtheta is the angular velocity, and
// g the same acceleration due to gravity from above. The initial condition at
// t = 0 is theta = 0 and vtheta = 0.
//

function out = fpend(t,state)
    X = state(1:2);
    V = state(3:4);

    // Compute tension
    tmp = V'*V - GRAV * X(2);
 
    // Compute rhs
    out = [ V; -X*tmp ];
    out(4) = out(4) - GRAV;
end

function out = fpendref(t,state)
    out = [state(2);-GRAV*cos(state(1))];
end

function [corr,err] = projPend(t,state,err)

  X=state(1:2)
  V=state(3:4)

  // Project positions
  Xnew = X/norm(X);

   // Project velocities
   //
   //        +-            -+  +-    -+
   //        |  y*y    -x*y |  |  xd  |
   //  P v = |              |  |      |
   //        | -x*y     x*x |  |  yd  |
   //        +-            -+  +-    -+

   P = [ Xnew(2)^2         -Xnew(1)*Xnew(2)
        -Xnew(1)*Xnew(2)    Xnew(1)^2];
  Vnew = P*V;
 
  // Return position and velocity corrections */
  corr = [Xnew;Vnew] - state;
 
  // Project error, if applicable
  if argn(1)==2
      err=[P*err(1:2);P*err(3:4)]
  end
end

GRAV = 13.750371636040745654980191559621114395801712;
state0=[1;0;0;0];
nout = 5;
tspan = linspace(0,30,nout+1)
RTOL = 1e-12;
ATOL = 1e-14;

[t,statereftheta] = cvode(fpendref,tspan,[0;0],method="BDF",rtol=RTOL,atol=ATOL,maxSteps=50000);
th=statereftheta(1,:);
thd=statereftheta(2,:);
stateref=[cos(th); sin(th); -thd.*sin(th); thd.*cos(th)];

[t,state] = cvode(fpend,tspan,state0,method="BDF",rtol=RTOL,atol=ATOL,projection=projPend,maxSteps=50000);
assert_checkalmostequal(state(1,:).^2+state(2,:).^2,ones(t));
assert_checktrue(max(abs(state-stateref)) < 1e-6)

[t,state] = cvode(fpend,tspan,state0,method="BDF",rtol=RTOL,atol=ATOL,projection=projPend,projectError=%t,maxSteps=50000);
assert_checkalmostequal(state(1,:).^2+state(2,:).^2,ones(t));
assert_checktrue(max(abs(state-stateref)) < 1e-6)

