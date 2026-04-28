// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14785 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14785
//
// <-- Short Description -->
// optim_ga does not work because of inconsistent usage of the "find" function

// Issue could not be reproduced but this test was added , just in case...

function y=f(x, a1, a2)
  y = a1*sum(x.^2) + a2
endfunction

PopSize     = 100;
Proba_cross = 0.7;
Proba_mut   = 0.1;
NbGen       = 10;
NbCouples   = 110;
Log         = %T;

ga_params = init_param();
// Parameters to control the initial population.
ga_params = add_param(ga_params,"dimension",3);

// Pass the extra parameters to the objective function
a1 = 12;
a2 = 7;
myobjfun = list(f,a1,a2);

// Optimize !
[pop_opt, fobj_pop_opt] = ..
  optim_ga(myobjfun, PopSize, NbGen, Proba_mut, Proba_cross, Log, ga_params);

