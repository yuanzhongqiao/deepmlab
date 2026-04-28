// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 14265 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14265
//
// <-- Short Description -->
// Display properties instead of the function
// when inserting in gcf()

gcf().info_message = "Non-regression test for bug 14265."
figure().info_message = "Non-regression test for bug 14265."