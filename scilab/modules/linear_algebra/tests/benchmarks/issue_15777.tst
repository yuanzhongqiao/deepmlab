// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for issue 15777 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15777
//
// <-- Short Description -->
// eigs() was slow
// =============================================================================

path = fullfile(SCI, "modules", "linear_algebra", "tests", "benchmarks", "issue_15777.mat");
loadmatfile(path);
tic()
for i=1:100
    eigs(a,[],1,'LM');
end
t=toc()/100