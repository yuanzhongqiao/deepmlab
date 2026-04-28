// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// =============================================================================
// // Benchmark for ishermitian function
// =============================================================================

a=sprand(10000,10000,0.01);
l = tril(a, -1);
u = triu(a, 1);
a = diag(diag(a)) + l + l * 1i + u + u * 1i;
a=a+a';

// ishermitian vs isequal
tic();
for i = 1:100
    ishermitian(a);
end
t = toc()/100

tic();
for i = 1:100
    isequal(a, a');
end
t2 = toc()/100
