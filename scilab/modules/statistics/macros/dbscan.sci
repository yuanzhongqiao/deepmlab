// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [labels, core_idx] = dbscan(X, eps, min_samples, metricName, metricParams)
    arguments
        X {mustBeA(X, "double")}
        eps {mustBeA(eps, "double"), mustBeScalar, mustBePositive} = 0.5
        min_samples {mustBeA(min_samples, "double"), mustBeScalar, mustBeInteger, mustBePositive} = 5
        metricName (1,1) {mustBeA(metricName, "string")} = "euclidean"
        metricParams {mustBeA(metricParams, "double")} = []
    end

    function idx = findNeighbors(a, b, eps, name, param)
        // x = a - b;
        // d = sqrt(sum(x .* x, 2)); // euclidian distance
        if param == [] then
            d = pdist2(a, b, name);
        else
            d = pdist2(a, b, name, param);
        end
        idx = find(d <= eps);
    endfunction

    [rows, cols] = size(X);
    labels = -1 * ones(rows, 1); // -1 = noise
    isok = zeros(rows, 1);
    cluster_id = 0;
    core_idx = [];

    for i = 1:rows
        if isok(i) == 1 then
            continue
        end
        isok(i) = 1;
        seed = X(i, :);
        neighbors_idx = findNeighbors(X, seed, eps, metricName, metricParams);

        if length(neighbors_idx) < min_samples then
            labels(i) = -1; // noise
        else
            cluster_id = cluster_id + 1;
            labels(i) = cluster_id;
            core_idx = [core_idx, i];
            k = 1;
            while k <= length(neighbors_idx)
                j = neighbors_idx(k);

                if isok(j) == 0 then
                    isok(j) = 1;
                    pt = X(j, :);
                    new_neighbors_idx = findNeighbors(X, pt, eps, metricName, metricParams);

                    if length(new_neighbors_idx) >= min_samples then
                        neighbors_idx = [neighbors_idx new_neighbors_idx];
                        neighbors_idx = unique(neighbors_idx, "keepOrder");
                        core_idx = [core_idx, j];
                    end
                end
                if labels(j) == -1 then
                    labels(j) = cluster_id;
                end
                k = k + 1;
            end
        end
    end
    
    core_idx = unique(core_idx)
endfunction