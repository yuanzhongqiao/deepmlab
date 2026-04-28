// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function demo_kmeans()
    fig = scf(100001);
    clf(fig,"reset");
    demo_viewCode("demo_kmeans.dem.sce");
    fig.figure_name = "kmeans_demo";
    fig.axes_size = [1021,460];
    fig.color_map = [77, 175, 74
    55,126,184
    152,78,163
    255,127,0] ./ 255
    n = 200;
    x1 = rand(n, 2, "normal") + 2 * ones(n, 2);
    x2 = rand(n, 2, "normal") - 2 * ones(n, 2);
    x3 = rand(n, 2, "normal") * 1.5 + ones(n, 2);
    x4 = rand(n, 2, "normal") * -1.5 - ones(n, 2);

    x = [x1; x2; x3; x4];
    [index, c] = kmeans(x, 3);

    subplot(121)
    scatter(x(:,1), x(:,2), [], color(255,127,0), "fill")
    title("Raw data")

    subplot(122)
    scatter(x(:,1), x(:,2), [], index, "fill")
    scatter(c(:,1), c(:,2), 150, color(228, 26, 28), "fill") // centroid of each cluster
    title("3 clusters and centroid")

endfunction

demo_kmeans();
clear demo_kmeans;