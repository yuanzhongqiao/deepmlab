// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16640 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16640
//
// <-- Short Description -->
// glue(gcf()) crashes Scilab

try
	glue(gcf());
	error("should not be called");
catch
	//normal path
end

