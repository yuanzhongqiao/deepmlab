// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systeme - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
// <-- Non-regression test for issue 14358 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14358
//
// <-- Short Description -->
// Black Hole demo produced an error java, clicking on "Clear" button

cd SCI/modules/differential_equations/demos/flow
exec blackhole.dem.sce
// Play with the Clear button
