// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dasssault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

// This **private** function converts a population (stored as list in Scilab genetic algorithms)
// to a matrix to be able to call vectorized cost functions
function popmat = ga_list_to_mat(poplist, toComputeOrNot, dims)

    // Using list2vec leads to performance issues:
    // - No pre-allocation
    // - Computation of values which are not mandatory in our case
    // 1) First implementation:
    // popmat = matrix(list2vec(poplist), dims, -1)';
    // And then (in e.g optim_ga): FObj(toComputeOrNot) = costfun(popmat(toComputeOrNot, :));
    // 2) Second implementation:
    // popmat = matrix(list2vec(list(poplist(toComputeOrNot))), dims, -1)';
    // And then (in e.g optim_ga): FObj(toComputeOrNot) = costfun(popmat)

    // Specific implementation
    if isempty(toComputeOrNot) then // Keep whole population
        toCompute = 1:size(poplist);
    else // Select population
        toCompute = find(toComputeOrNot);
    end
    sz = size(toCompute, "*");
    popmat = zeros(sz, dims); // Pre-allocation
    for ii = 1:sz
        popmat(ii, :) = poplist(toCompute(ii));
    end

    // And then (in e.g optim_ga): FObj(toComputeOrNot) = costfun(popmat)
    
endfunction
