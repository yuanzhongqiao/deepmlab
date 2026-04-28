// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 7236 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7236
//
// <-- Short Description -->
// sci2exp(-%inf) return a wrong value -nf and not -%inf,
// a consequence of bug 1371 fix

if sci2exp(%inf)<>"%inf" then pause,end
if sci2exp(-%inf)<>"-%inf" then pause,end
if sci2exp(%nan)<>"%nan" then pause,end
if string(%inf)<>"Inf"  then pause,end
if string(-%inf)<>"-Inf"  then pause,end
if string(1-imult(%inf))<>"1-%i*Inf"  then pause,end
if string(1+imult(%inf))<>"1+%i*Inf"  then pause,end
if sci2exp(1-imult(%inf))<>"complex(1,-%inf)"  then pause,end
if sci2exp(1+imult(%inf))<>"complex(1,%inf)"  then pause,end
