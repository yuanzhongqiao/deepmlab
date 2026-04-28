//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - S/E - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// DOLLAR
a=$**2;
assert_checkequal(a, $**2); // Was doing a segfault in Scilab 6 as some point
a=[1,2,3;4,5,6];
assert_checkequal(a($),6);

b = [1 2 3;4 5 6;7 8 9];
assert_checkequal(b(1,$),3);

assert_checkequal(b($,2),8);
assert_checkequal(b($,$),9);

// Add a row at the end of the matrix b
b($+1,:) = [1 1 1];
b_ref = [1 2 3;4 5 6;7 8 9;1 1 1];
assert_checkequal(b, b_ref);

// cell
c = {1 2 3;4 5 6;7 8 9};
assert_checkequal(c{1,$},3);
assert_checkequal(c(1,$),{3});
assert_checkequal(c{$,2},8);
assert_checkequal(c($,2),{8});
assert_checkequal(c{$,$},9);
assert_checkequal(c($,$),{9});

// new or empty variable
clear x;x(1:2)=42;
assert_checkequal(x, [42; 42]);
x=[]; x(1:2)=42;
assert_checkequal(x, [42; 42]);
clear x;x($+1:$+2)=42;
assert_checkequal(x, [42; 42]);
x=[]; x($+1:$+2)=42;
assert_checkequal(x, [42; 42]);

clear x; x(1:0)=42
assert_checkequal(x, []);
x=[]; x(1:0)=42
assert_checkequal(x, []);
clear x; x(1:$)=42
assert_checkequal(x, []);
x=[]; x(1:$)=42
assert_checkequal(x, []);

// END
//a=end**2;
//assert_checkequal(a, end**2); // Was doing a segfault in Scilab 6 as some point
a=[1,2,3;4,5,6];
assert_checkequal(a(end),6);

b = [1 2 3;4 5 6;7 8 9];
assert_checkequal(b(1,end),3);

assert_checkequal(b(end,2),8);
assert_checkequal(b(end,end),9);

// Add a row at the end of the matrix b
b(end+1,:) = [1 1 1];
b_ref = [1 2 3;4 5 6;7 8 9;1 1 1];
assert_checkequal(b, b_ref);

// cell
c = {1 2 3;4 5 6;7 8 9};
assert_checkequal(c{1,end},3);
assert_checkequal(c(1,end),{3});
assert_checkequal(c{end,2},8);
assert_checkequal(c(end,2),{8});
assert_checkequal(c{end,end},9);
assert_checkequal(c(end,end),{9});

// new or empty variable
clear x;x(1:2)=42;
assert_checkequal(x, [42; 42]);
x=[]; x(1:2)=42;
assert_checkequal(x, [42; 42]);
clear x;x(end+1:end+2)=42;
assert_checkequal(x, [42; 42]);
x=[]; x(end+1:end+2)=42;
assert_checkequal(x, [42; 42]);

clear x; x(1:0)=42
assert_checkequal(x, []);
x=[]; x(1:0)=42
assert_checkequal(x, []);
clear x; x(1:end)=42
assert_checkequal(x, []);
x=[]; x(1:end)=42
assert_checkequal(x, []);

// Exception cases where end is not last element
s = struct("end", 2);
M = [10, 20, 30];
C = {10, 20, 30};
assert_checkequal(s("end"), 2);
assert_checkequal(s.end, 2);
assert_checkequal(M(s.end), 20);
assert_checkequal(M(s.end + 1), 30);
assert_checkequal(M(s.end - 1), 10);
assert_checkequal(C(s.end), {20});
assert_checkequal(C(s.end + 1), {30});
assert_checkequal(C(s.end - 1), {10});
assert_checkequal(C{s.end}, 20);
assert_checkequal(C{s.end + 1}, 30);
assert_checkequal(C{s.end - 1}, 10);

// Mixing ends
a = 1:7;
b.end = 4;
a(b.end:end) = 1;
assert_checkequal(a, [1,2,3,1,1,1, 1]);

// Wrong usage as return value
function [a,b] = testMe()
    a = 0;
    b = 0;
end
errmsg = ["Illegal use of reserved keyword ''$'' or ''end''."];
assert_checkerror("[x, $] = testMe()", errmsg);
assert_checkerror("[x, end] = testMe()", errmsg);