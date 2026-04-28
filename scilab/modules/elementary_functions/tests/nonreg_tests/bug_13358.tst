// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Pierre-Aime Agnel
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 13358-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13358
//
// <-- Short Description -->
// intersect and unique are slower due to gsort behaving in o(n^2) on sorted arrays
//
// <-- INTERACTIVE TEST -->
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->

err = 0.15
seed = getdate("s");
rand("seed", seed);
nb_test = 5;
A = 1:1E5;
B = 2:2:2E5;
delta_i = [];
delta_u = [];
delta_s = [];

// Checks relative time between sort on a random table and a sorted one is within 15%
for i = 1:nb_test
    A_rand = rand(1, 1E5);
    B_rand = rand(1, 1E5);
    timer(); intersect(A, B); t_elapsed_sorted = timer()
    timer(); intersect(A_rand, B_rand); t_elapsed_rand = timer()
    delta_i = [delta_i, abs(t_elapsed_rand - t_elapsed_sorted) / (t_elapsed_rand + t_elapsed_sorted)];

    timer(); unique(A); t_elapsed_sorted = timer()
    timer(); unique(A_rand); t_elapsed_rand = timer()
    delta_u = [delta_u, abs(t_elapsed_rand - t_elapsed_sorted) / (t_elapsed_rand + t_elapsed_sorted)];

    timer(); gsort(1:1E6); t_elapsed_sorted = timer()
    timer(); gsort(rand(1,1E6)); t_elapsed_rand = timer()
    delta_s = [delta_s, abs(t_elapsed_rand - t_elapsed_sorted) / (t_elapsed_rand + t_elapsed_sorted)];
end

assert_checktrue(mean(delta_i) <= err);
assert_checktrue(mean(delta_u) <= err);
assert_checktrue(mean(delta_s) <= err);
