// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// <-- Non-regression test for bug 17147 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17238
//
// <-- Short Description -->
// {list()} cannot be displayed

%ce_string({list()});
%ce_string({list(1, 2 ,3)});
