// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function astar_html()
    close(100002)
    // Create a figure
    f = figure(...
        "figure_name", "A* Search algorithm",...
        "infobar_visible", "off",...
        "toolbar_visible", "off",...
        "dockable", "off",...
        "menubar", "none",...
        "default_axes", "off", ...
        "layout", "border", ...
        "resize", "off", ...
        "tag", "astar_html", ...
        "visible", "off");

    f.figure_id = 100002;
    f.axes_size = [800 600];

    fr = uicontrol(f, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "layout", "border");

    uicontrol(fr, ...
        "style", "browser", ...
        "debug", "on", ...
        "string", SCI + "/modules/gui/demos/astar.html", ...
        "callback", "cbAStar", ...
        "tag", "browser");

    f.visible = "on";
endfunction

function cbAStar(msg, cb)
    if msg == "loaded" then
        return;
    end

    select msg.type
    case "compute"
        data = msg.data;
        res = astar(data.map, data.costs, sub2ind(data.grid, data.finish), sub2ind(data.grid, data.start));
        cb(ind2sub(data.grid, res));
    case "help"
        astar_help();
    end
endfunction

/*
map = zeros(5, 5);
map(1,:) = 1;
astar(map <> 0, ones(map), 1, 21)
// [21, 16, 11, 6, 1])

map = [ ...
    1, 1, 1, 1, 1 ; ...
    1, 0, 0, 0, 1 ; ...
    1, 1, 0, 1, 1 ; ...
    0, 0, 0, 1, 0 ; ...
    1, 1, 1, 1, 1 ; ...
    ];
final = astar(map <> 0, ones(map), 6, 5)
//[5, 10, 15, 19, 18, 22, 16, 11, 6])
*/
function res = astar(map, costs, start, goal)
    // Avoid div by zero
    costs(costs == 0) = %eps;
    // Normalize such that smallest cost is 1.
    costs = costs ./ min(costs);

    res = [];

    mapSize = size(map);
    mapNumEl = size(map, "*");

    openSet = ones(map) == 0;
    openSet(start) = %t;

    closedSet = ones(map) == 0;

    cameFrom = [0 0];

    gScore = ones(map) * %inf;
    gScore(start) = 0;

    [gr, gc] = ind2sub(mapSize, goal);

    fScore = ones(map) * %inf;
    fScore(start) = astar_compute_cost(mapSize, start, gr, gc);

    S2 = sqrt(2);

    while or(openSet)
        [_, current] = min(fScore);
        current = sub2ind(mapSize, current);

        if current == goal then
            res = astar_get_path(cameFrom, current);
            return
        end

        rc = pmodulo(current - 1, mapSize(1)) + 1;
        cc = (current - rc) / mapSize(1) + 1;

        openSet(rc, cc) = %f;
        closedSet(rc, cc) = %t;

        fScore(rc, cc) = %inf;
        gScoreCurrent = gScore(rc, cc) + costs(rc, cc);

        n_ss = [ ...
            rc + 1, cc + 0, 1
            rc + 0, cc - 1, 1
            rc - 1, cc - 0, 1
            rc - 0, cc + 1, 1
        ];

        valid_row = n_ss(:,1) >= 1 & n_ss(:,1) <= mapSize(1);
        valid_col = n_ss(:,2) >= 1 & n_ss(:,2) <= mapSize(2);
        n_ss = n_ss(valid_row & valid_col, :);

        neighbors = n_ss(:,1) + (n_ss(:,2) - 1) .* mapSize(1);

        ixInMap = map(neighbors) & ~closedSet(neighbors);
        neighbors = neighbors(ixInMap);

        if neighbors == [] then
            continue;
        end

        dists = n_ss(ixInMap, 3);

        openSet(neighbors) = %t;

        tentative_gscores = gScoreCurrent + costs(neighbors) .* dists;

        ixBetter = tentative_gscores < gScore(neighbors);
        bestNeighbors = neighbors(ixBetter);
        if bestNeighbors == [] then
            continue;
        end

        cameFrom(bestNeighbors) = current;
        gScore(bestNeighbors) = tentative_gscores(ixBetter);
        fScore(bestNeighbors) = gScore(bestNeighbors) + astar_compute_cost(mapSize, bestNeighbors, gr, gc);
    end
endfunction

function p = astar_get_path(cameFrom, current)
    // Returns the path. This function is only called once and therefore does not need to be extraordinarily efficient
    inds = find(cameFrom);
    p = zeros(1, length(inds)) * %nan;
    p(1) = current;
    next = 1;
    while or(current == inds)
        current = cameFrom(current);
        next = next + 1;
        p(next) = current;
    end

    p(isnan(p)) = [];
endfunction

function cost = astar_compute_cost(mapSize, from, rTo, cTo)
    // Returns COST, an estimated cost to travel the map, starting FROM and ending at TO.
    [rFrom, cFrom] = ind2sub(mapSize, from);
    cost = sqrt((rFrom - rTo) .^ 2 + (cFrom - cTo) .^ 2);
endfunction

function astar_help()
    msg = ["Welcome in ""A* Search demo""";
            ""
            "This demo is based on `browser uicontrol`";
            "To access the source code: [crtl + shift + i] or openDevtools(get(""astar""))."
            ""
            "You can change de size of the grid and the positions of start and finish."
            "By clicking in the grid, you can increase its weight, and by right-clicking you can decrease it."
            ""
            "To find the best path, click on ""Find Best Path"" button"
            ];

    messagebox(msg, "A* Search algorithm", "info", "modal");
endfunction

astar_html();
