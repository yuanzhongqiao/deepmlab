// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- XCOS TEST -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for issue 16925 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16925
//
// <-- Short Description -->
// Xcos schema with modelica blocks was using the schema filename as the modelica 
// filename and modelname.
//

loadXcosLibs();
importXcosDiagram("SCI/modules/xcos/demos/ModelicaBlocks/Ball_Platform.zcos");

scs_m.props.tf = 0;
scs_m.props.title(1) = "this will be - used as # modelica name";
scicos_simulate(scs_m, list());
