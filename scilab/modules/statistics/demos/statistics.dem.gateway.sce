// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("statistics.dem.gateway.sce");
    add_demo("Statistics", demopath+"statistics.dem.gateway.sce");

    subdemolist = [
    "K-means clustering", "demo_kmeans.dem.sce"
    ];
    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction

subdemolist = demo_gateway();
clear demo_gateway;
