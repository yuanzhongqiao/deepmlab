// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15465 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15465
//
// <-- Short Description -->
// Saved datatips cannot be restored correctly after reloading a diagram

plotExportFile  =  pathconvert(TMPDIR) + "savePlot.hdf5";
t = linspace(0,2*%pi,128);
clf
h = plot(t,[sin(t);cos(t);sin(2*t)])(3);
h.tag = "curve";

// datatip with internal {dataIndex,ratio} = {47,0.623064}
hd = datatipCreate(h,[3*%pi/4 sqrt(2)/2]);
data1 = hd.data;

// save the curves
f  =  gcf();
save(plotExportFile, "f");
delete(f)

// reload data and compare data
load(plotExportFile);
data2 = get("curve").datatips(1).data;
assert_checkequal(data1,data2);
