// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for bezier function
// =============================================================================

P = [0 0; 1 2; 3 -1; 4 0];
t = linspace(0, 1, 100);

z = bezier(P, t);
assert_checkequal(size(z), [100 2]);
assert_checkequal(min(z(:,1)), 0);
assert_checkequal(max(z(:,1)), 4);
assert_checkequal(z(1,:), P(1,:));
assert_checkequal(z($,:), P($,:));

P = [0 0; 1 2; 2 0; -1 0];
t = linspace(0, 1, 100);

z = bezier(P, t);
assert_checkequal(size(z), [100 2]);
assert_checkequal(z(1,:), P(1,:));
assert_checkequal(z($,:), P($,:));

P = rand(5, 2);
t = linspace(0, 1, 1000);
z = bezier(P, t);
assert_checkequal(size(z), [1000 2]);
assert_checkequal(z(1,:), P(1,:));
assert_checkequal(z($,:), P($,:));

P = rand(5, 3);
t = linspace(0, 1, 500);
z = bezier(P, t);
assert_checkequal(size(z), [500 3]);
assert_checkequal(z(1,:), P(1,:));
assert_checkequal(z($,:), P($,:));

// with w
P = rand(6, 2);
w = 0.1 * rand(6, 1);
t = linspace(0, 1, 10);
z = bezier(P, t, w);
assert_checkequal(size(z), [10 2]);
assert_checkalmostequal(z(1,:), P(1,:));
assert_checkalmostequal(z($,:), P($,:));

P = rand(6, 3);
w = 0.1 * rand(6, 1);
t = linspace(0, 1, 10);
z = bezier(P, t, w);
assert_checkequal(size(z), [10 3]);
assert_checkalmostequal(z(1,:), P(1,:));
assert_checkalmostequal(z($,:), P($,:));

// t is scalar
P = [0 0; 0 1; 1 1; 1 0];
nb = 50;
z = bezier(P, nb);
assert_checkequal(size(z), [50 2]);
assert_checkalmostequal(z(1,:), P(1,:));
assert_checkalmostequal(z($,:), P($,:));