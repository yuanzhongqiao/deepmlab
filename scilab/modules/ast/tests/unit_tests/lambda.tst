// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//

//basic case
f = #(x) -> (x + 1);

res = zeros(1, 10);
for i = 1:10
    res(i) = f(i);
end

assert_checkequal(res, 2:11);


//catch variable
d = 2
f = #(x) -> (x + d);
d = 100;

res = zeros(1, 10);
for i = 1:10
    res(i) = f(i);
end

assert_checkequal(res, 3:12);


//catch user defined function/lambda
sqrt = #(x) -> (x ^ 2); //oops
pyth = #(a, b) -> (sqrt(a ^ 2 + b ^ 2));
clear sqrt;
res = pyth(3, 4);
assert_checkfalse(res == 5);
assert_checkequal(res, (3 ^ 2 + 4 ^ 2) ^ 2);


//multiple returns
f = #(x, y) -> (varargout = list(x - y, y - x));

res1 = zeros(10, 10);
res2 = zeros(10, 10);
for i = 1:10
    for j = 1:10
        [res1(i, j), res2(i, j)] = f(i, j);
    end
end

assert_checkequal(res1, res2');


//use lambda as function parameter
function res = filter(x, f)
    res = [];
    for i = x
        if f(i) then
            res = [res i];
        end
    end
end

st = [];
for i = -10:10
    st(1, $+1) = struct("val", i);
end

res = filter(st, #(x) -> (x.val < 0));
assert_checkequal(list2vec(res.val)', -10:-1);
res = filter(st, #(x) -> (x.val > 0));
assert_checkequal(list2vec(res.val)', 1:10);


//lambda factory
function f = comp(threshold)
    f = #(x) -> (x <= threshold);
end

f1 = comp(5);
f2 = comp(15);

res1 = f1(1:20);
res2 = f2(1:20);
assert_checkequal(find(res1), 1:5);
assert_checkequal(find(res2), 1:15);


x = #(x) -> (x + 1);
f = fullfile(TMPDIR, "lambda.sod");
save(f, "x");
clear x;
load(f);
assert_checkequal(x(1), 1 + 1);
assert_checkequal(x(10), 10 + 1);

y = #(x) -> (x**2);
x = #(x) -> (x + y(x));
save(f, "x");
clear x y;
load(f);
assert_checkequal(x(1), 1 + 1**2);
assert_checkequal(x(15), 15 + 15 ** 2);
