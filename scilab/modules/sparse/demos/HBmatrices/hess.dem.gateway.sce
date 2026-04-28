//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

demopath = get_absolute_file_path("hess.dem.gateway.sce");

subdemolist = [
"lund_a.rsa","lund_a.rsa.dem.sce"
"lund_b.rsa","lund_b.rsa.dem.sce"
"eris1176.psa","eris1176.psa.dem.sce"
"ash85.psa","ash85.psa.dem.sce"
"ash292.psa","ash292.psa.dem.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
