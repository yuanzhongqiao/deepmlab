//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 9821 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9821
//
// <-- Short Description -->
// getrelativename does not manage matrix of strings

computed = getrelativefilename([SCI+'/bin',SCI+'/bin'], [SCI+'/ACKNOWLEDGMENTS',SCI+'/ACKNOWLEDGMENTS']);
expected = pathconvert(["../ACKNOWLEDGMENTS", "../ACKNOWLEDGMENTS"], %f);
assert_checkequal(computed,expected);
