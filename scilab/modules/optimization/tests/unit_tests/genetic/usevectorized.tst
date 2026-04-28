// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// https://fr.mathworks.com/help/gads/vectorizing-the-fitness-function.html

S = grand("getsd");

// Cost function, it is slow because of the sleep() call, but it is vectorized, so it can be computed for a whole population at once
fun = #(pop) -> (sleep(1); 10.0 * size(pop, 2) + sum(pop .^2 - 10.0 * cos(2 * %pi .* pop), 2));

options = init_param();
options = add_param(options, "dimension", 10);
options = add_param(options, "use_vectorized", %F);

allgafuncs = {optim_ga, optim_moga, optim_nsga, optim_nsga2};

for i = 1:size(allgafuncs, "*")
    // Compute one generation without vectorization
    options = set_param(options, "use_vectorized", %F);
    grand("setsd", S);
    tic()
    [_, foptnovec] = allgafuncs{i}(fun, 20, 1, 0.01, 0.8, %F, options);
    tnovec = toc();

    // Compute one generation with vectorization
    options = set_param(options, "use_vectorized", %T);
    grand("setsd", S);
    tic()
    [_, foptvec] = allgafuncs{i}(fun, 20, 1, 0.01, 0.8, %F, options);
    tvec = toc();

    // Results must be equal
    assert_checkequal(foptnovec, foptvec);
    // Vectorized computation must be faster then not-vectorized one (due to sleep() call in cost function)
    assert_checktrue(tnovec > tvec);
end
