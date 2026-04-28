//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2s.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

demopath = get_absolute_file_path("jac.dem.gateway.sce");

subdemolist = [
"gent113.pua","gent113.pua.dem.sce"
"ibm32.pua","ibm32.pua.dem.sce"
"will57.pua","will57.pua.dem.sce"
"will199.pua","will199.pua.dem.sce"
"curtis54.pua","curtis54.pua.dem.sce"
"fs_541_1.rua","fs_541_1.rua.dem.sce"
"arc130.rua","arc130.rua.dem.sce"
"ash219.pra","ash219.pra.dem.sce"
"ash331.pra","ash331.pra.dem.sce"
"str__200.rua","str__200.rua.dem.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
