// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2026 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17540 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17540
//
// <-- Short Description -->
// cvode projection feature + interval tspan freezes Scilab

function Xd=f(t,X,alpha)
    Xd = alpha*[-X(2);X(1)];
end
function corr=proj(t,X,err)
   Xp=X/norm(X);
   corr=Xp-X;
end

alpha=1;
X0=[1;0];
// use interval to trigger CV_ONE_STEP mode instead of CV_NORMAL
tspan=[0 10];

[tp,Xp]=cvode(list(f,alpha),tspan,X0,projection=proj);


