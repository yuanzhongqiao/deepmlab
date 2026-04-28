// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function bandwidth = estimate_bandwidth(X, quantile, n_samples, random_state)
    // estimate the bandwidth to use with the mean-shift algorithm (only with kernel == "flat")
    arguments
        X {mustBeA(X, "double")}
        quantile {mustBeA(quantile, "double"), mustBeScalar, mustBeInRange(quantile, 0, 1)} = 0.3
        n_samples {mustBeA(n_samples, "double"), mustBeScalar, mustBeInteger} = min(500, size(X, 1))
        random_state {mustBeA(random_state, "double"), mustBeScalar, mustBeInteger} = -1
    end

    [N, D] = size(X);

    if random_state <> -1 then
        grand("setsd", random_state);
    end

    // Select a subsample
    if nargin >= 3 then
        indices = grand(1, "prm", 1:N);
        if n_samples <= N
            indices = indices(1:n_samples);
        else
            n_samples = N;
        end
        Xs = X(indices, :);
    else
        Xs = X;
    end

    k = max(1, round(quantile * n_samples)); // k-th nearest neighbor
    dists_k = zeros(n_samples, 1);

    for i = 1:n_samples
        Xi = Xs(i, :);
        all_dists = [];
        for j = 1:n_samples
            all_dists($+1) = norm(Xi - Xs(j, :), 2);
        end
        all_dists = gsort(all_dists, "g", "i");
        dists_k(i) = all_dists(k); // distance to k-th nearest neighbor
    end

    bandwidth = mean(dists_k);
endfunction