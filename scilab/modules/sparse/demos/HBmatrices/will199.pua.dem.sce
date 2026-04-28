//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

demopath = get_absolute_file_path("will199.pua.dem.sce");
exec(fullfile(demopath,"testJacBoeing.sce"),-1);
testJacBoeing("will199.pua")
clear testJacBoeing
clear demopath
