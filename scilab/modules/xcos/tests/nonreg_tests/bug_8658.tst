// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8658 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8658
//
// <-- Short Description -->
// Modelica compiler fail for a diagram with accentuated filename.

diagram = TMPDIR + "/Schema-@-electrique.zcos";
[status,msg] = copyfile(SCI + "/modules/xcos/demos/ModelicaBlocks/RLC_Modelica.zcos", diagram);
if ~status then pause, end

if ~importXcosDiagram(diagram) then pause, end
diagram, scs_m.props.title
if ~isempty(strstr(scs_m.props.title(1), "@")) then pause, end

// try to set a model name with an invalid character
scs_m.props.title(1) = "Schema-@-electrique";
diagram, scs_m.props.title
if ~isempty(strstr(scs_m.props.title(1), "@")) then pause, end

deletefile(diagram);

