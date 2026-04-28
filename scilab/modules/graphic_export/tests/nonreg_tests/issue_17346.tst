// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17346 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17346
//
// <-- Short Description -->
// When an axes has a frame as parent, anti-aliasing is not activated as in parent figure.

f = gcf();
fr = uicontrol(f, "style", "frame");

jimport org.scilab.modules.graphic_objects.graphicModel.GraphicModel;
m = GraphicModel.getModel();
jf = m.getObjectFromId(f.UID); // Figure in Java model
jfr = m.getObjectFromId(fr.UID); // Frame in Java model
assert_checkequal(jfr.getAntialiasing(), jf.getAntialiasing());