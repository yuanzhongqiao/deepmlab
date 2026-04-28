// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for gradient function
// =============================================================================

assert_checkequal(gradient([]), []);
assert_checkequal(gradient([], []), []);

x = 1:10;
dx = gradient(x.^2);
assert_checkequal(dx, [3 2.*x(2:$-1) 19]);

x = 0:0.5:5;
dx = gradient(x.^2, 0.5);
assert_checkequal(dx, [0.5 2.*x(2:$-1) 9.5]);

dxx = gradient(x.^2, x);
assert_checkequal(dxx, dx);

x = 1:10;x = x';
dx = gradient(x.^2);
assert_checkequal(dx, [3; 2.*x(2:$-1); 19]);

x = 0:0.5:5;x = x';
dx = gradient(x.^2, 0.5);
assert_checkequal(dx, [0.5; 2.*x(2:$-1); 9.5]);

dxx = gradient(x.^2, x);
assert_checkequal(dxx, dx);

x = matrix(1:10, 5, 2)';
dx = gradient(x.^2);
assert_checkequal(dx, [3 4 6 8 9; 13 14 16 18 19]);

dx = gradient(x.^2, 1);
assert_checkequal(dx, [3 4 6 8 9; 13 14 16 18 19]);

x = linspace(-%pi, %pi, 1e3);
y = cos(x);
df = -sin(x);

dx = gradient(y, 0.0062895);
assert_checkalmostequal(dx(2:$-1), df(2:$-1), [], 1.e-4);

// f(x,y) = x.^2 + y.^2
x = 1:5;
y = [1;2];
[X,Y] = meshgrid(x, y);
f = X.^2 + Y.^2;
[dfx, dfy] = gradient(f);
assert_checkequal(dfx, [3 4 6 8 9; 3 4 6 8 9]);
assert_checkequal(dfy, 3.*ones(2,5));

[dfx, dfy] = gradient(f, x, y);
assert_checkequal(dfx, [3 4 6 8 9; 3 4 6 8 9]);
assert_checkequal(dfy, 3.*ones(2,5));

[dfx, dfy] = gradient(f, x, y');
assert_checkequal(dfx, [3 4 6 8 9; 3 4 6 8 9]);
assert_checkequal(dfy, 3.*ones(2,5));

// f(x,y) = x.^2 + 3xy + y.^2
x = -2:0.2:2;
[X, Y] = meshgrid(x);
f = X.^2 + 3 * X .* Y + Y.^2;
[dx, dy] = gradient(f, 0.2);
i = find(X == 1 & Y == 2);
assert_checkalmostequal([dx(i), dy(i)], [8 6.8], [], 1.e-10);

// f(x,y,z) = x.^2y + yz + sin(z)
[x, y, z] = meshgrid(-2:2, -2:2, -2:2);
f = x.^2 .* y + y .* z + sin(z);
[dx, dy, dz] = gradient(f);
t = x == 1 & y == 2 & z == 0;
assert_checkalmostequal([dx(t), dy(t), dz(t)], [4 1 2.8414710], [], 1.e-6);

[x, y, z] = meshgrid(-2:2, -2:0.2:2, -2:0.5:2);
f = x.^2 .* y + y .* z + sin(z);
[dx, dy, dz] = gradient(f, 1, 0.2, 0.5);
t = x == 1 & y == 2 & z == 0;
assert_checkalmostequal([dx(t), dy(t), dz(t)], [4 1 2.9588511], [], 1.e-6);

// f(x,y,z,w) = (x+y)*(z-w)
[y,x,z,w]= ndgrid(-1:0.1:1, -3:3, -2:0.5:2, 2:0.4:4);
f = (x + y) .* (z - w);
[dx, dy, dz, dw] = gradient(f, 1, 0.1, 0.5, 0.4);
// (2,0,1,2)
t = x == 2 & y == 0 & z == 1 & w == 2;
assert_checkalmostequal([dx(t), dy(t), dz(t), dw(t)], [-1 -1 2 -2], [], 1.e-8);

dxx = gradient(f, 1);
assert_checktrue(dx == dxx);

[dxx, dyy] = gradient(f, 1, 0.1);
assert_checktrue(dx == dxx);
assert_checktrue(dy == dyy);

[dxx, dyy, dzz] = gradient(f, 1, 0.1, 0.5);
assert_checktrue(dx == dxx);
assert_checktrue(dy == dyy);
assert_checktrue(dz == dzz);

assert_checktrue(gradient(f, 1) == dx);