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
// <-- Non-regression test for issue 15405 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15405
//
// <-- Short Description -->
// hdf5: fix crashes on extraction of compound fields integer 64 bits (signed and unsigned)

fd =  h5open(fullfile(SCI, "modules", "hdf5", "tests", "nonreg_tests", "issue_15405.h5"));
radar = h5read(fd.root.Radar, "radar.radar");
h5close(fd);

scatter3d(double(radar.timestampR), double(radar.id_radar), radar.distance, ..
		 radar.distance, radar.distance, "fill", "markerEdgeColor", "darkblue");


