// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for issue 17368 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17368
//
// <-- Short Description -->
// bloc2ss expects a list as input argument

//Initialization
s=poly(0,'s');
P=[1/s, 1/(s+1); 1/(s+2),2/s]; k= 1/(s-1);
P11 = P(1,1);
P12 = P(1,2);
P21 = P(2,1);
P22 = P(2,2);
syst=list('blocd');
l=1;

//System (2x2 blocks plant)
l=l+1;
n_s=l;
syst(l)=list('transfer',['P11','P12';'P21','P22']);

//Controller
l=l+1;
n_k=l;
syst(l)=list('transfer','k');

//Links
l=l+1;
syst(l)=list('link','w',[-1],[n_s,1]);
l=l+1;
syst(l)=list('link','z',[n_s,1],[-1]);
l=l+1;
syst(l)=list('link','u',[n_k,1],[n_s,2]);
l=l+1;
syst(l)=list('link','y',[n_s,2],[n_k,1]);
s=poly(0,'s'); 
S1=1/(s+1);
S2=1/s; 
sysf=bloc2ss(syst);

msg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "bloc2ss", 1, sci2exp("list"));
assert_checkerror("bloc2ss(1)", msg);