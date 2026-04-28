// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel Gougeon
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// unit test of union()
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->

// Empty - empty
// -------------
assert_checkequal(union([],[]), []);
assert_checkequal(union([],[],"r"), []);
assert_checkequal(union([],[],"c"), []);
[u,ka,kb] = union([],[]);
assert_checkequal(u, []);
assert_checkequal(ka, []);
assert_checkequal(kb, []);

// empty, a
// --------
assert_checkequal(union(1,[]),1);
assert_checkequal(union([1 2],[]),[1 2]);
assert_checkequal(union([1 2]',[]),[1 2]);
assert_checkequal(union([1 2 ; 2 0],[]),[0 1 2]);
assert_checkequal(union(cat(3,[1 2],[0 1]), 0),[0 1 2]);

assert_checkequal(union([],1),1);
assert_checkequal(union([], [1 2]),[1 2]);
assert_checkequal(union([],[1 2]'),[1 2]);

a  = [4 1 %nan -3 %inf 10 %nan -%inf %inf 1];
ref = [-%inf -3 1 4 10 %inf %nan %nan];
assert_checkequal(union(a, []), ref);
assert_checkequal(union(a, [], "r"), a);
assert_checkequal(union(a, [], "c"), ref);

assert_checkequal(union([], a), ref);
assert_checkequal(union([], a, "r"), a);
assert_checkequal(union([], a, "c"), ref);

// With Booleans
// -------------
[T, F] = (%t, %f);
a = [T T F T F T
     F F F F T T
     T F F F F T ];
b  = [F F T T F F
      T T T T T T
      T F T T T F ];
Ref = [F F F T T T
       F T T F F T
       F F T F T T ];
assert_checkequal(union(T,T),T);
assert_checkequal(union(T,F),[F T]);
assert_checkequal(union([T F]',F),[F T]);
assert_checkequal(union([T F]',F),[F T]);
assert_checkequal(union(cat(3,a,b),F),[F T]);
// "c", "r"
assert_checkequal(union(a,b,"c"),Ref);
[v, ka, kb] = union(a, b, "c");
assert_checkequal(list(v, ka, kb), list(Ref,[3 5 2 1 6], 1));

assert_checkequal(union(a',b',"r"), Ref');
[v, ka, kb] = union(a', b', "r");
assert_checkequal(list(v, ka, kb), list(Ref',[3 5 2 1 6], 1));

// With real numbers
// -----------------
a  = [2.   2.   1.   2.   0.
      0.   2.   1.   2.   1. ];
b  = [1.   0.   2.   0.   1.
      2.   0.   0.   1.   1. ];
Ref= [0.   0.   1.   1.   2.   2.
      0.   1.   1.   2.   0.   2. ];
assert_checkequal(union(a,b,"c"), Ref);
assert_checkequal(union(a',b',"r"), Ref');
[v,ka,kb] = union(a,b,"c");
assert_checkequal(list(v,ka,kb), list(Ref,[5 3 1 2],[2 1]));
[v,ka,kb] = union(a',b',"r");
assert_checkequal(list(v,ka,kb), list(Ref',[5 3 1 2],[2 1]));


// ===========
// With sparse
// ===========
es = sparse([]);
esb = sparse(%t); esb(1) = [];

// Element-wise processing
// -----------------------
// Results with sparse input(s) must be equal to those got with dense inputs,
//  but be sparse.
objects = list(es, sparse(0), sparse(5), sparse([2 %nan 0 -3 0 4]), ..
    sparse([2 0 -3 0 %inf 4]'), sparse([0 2 -%inf ; %nan 0 2]), ..
    sparse(complex([0 1 %inf -1 %nan],[3 -%inf 2 -1 0])), ..
    esb, sparse(%t), sparse(%f), sparse([%t %f %f %t %f]), ..
    sparse([%t %f %f %t %f]'), sparse([%t %f %t ; %t %t %f]));
for a = objects
    for b = objects
        uref = union(full(a), full(b));
        u = union(a, b);
        if ~((isequal(a,es) | isequal(a,esb)) & (isequal(b,es) | isequal(b,esb)))
            assert_checktrue(issparse(u));
        else
            assert_checkequal(u,[]);
        end
        assert_checkequal(full(u), uref);

        [uref, karef, kbref] = union(full(a), full(b));
        [u, ka, kb] = union(a, b);
        assert_checkequal(ka, karef);
        assert_checkequal(kb, kbref);
    end
end
// "r" and "c" processing
// ----------------------
add = list(0, %i);  // real, then complex numbers
for p = add
    a  = [2.   2.   1.   2.   0.
          0.   2.   1.   2.   1. ] + p;
    b  = [1.   0.   2.   0.   1.
          2.   0.   0.   1.   1. ] + p;
    Ref= [0.   0.   1.   1.   2.   2.
          0.   1.   1.   2.   0.   2. ] + p;
    [a, b, Ref] = (sparse(a), sparse(b), sparse(Ref));
    assert_checkequal(union(a,b,"c"), Ref);
    assert_checkequal(union(a',b',"r"), Ref');
    [v,ka,kb] = union(a,b,"c");
    assert_checkequal(list(v,ka,kb), list(Ref,[5 3 1 2],[2 1]));
    [v,ka,kb] = union(a',b',"r");
    assert_checkequal(list(v,ka,kb), list(Ref',[5 3 1 2],[2 1]));
end

// duration
A = hours([ 1 8 4 5 2 1]);
B = hours([ 9 7 4 2 1 4]);
u = union(A, B);
assert_checkequal(u, hours([1 2 4 5 7 8 9]));

[u, ka, kb] = union(A, B);
assert_checkequal(ka, [1 5 3 4 2]);
assert_checkequal(kb, [2 1]);

a  = hours([2.   2.   1.   2.   0.
      0.   2.   1.   2.   1. ]);
b  = hours([1.   0.   2.   0.   1.
      2.   0.   0.   1.   1. ]);
Ref= hours([0.   0.   1.   1.   2.   2.
      0.   1.   1.   2.   0.   2. ]);
assert_checkequal(union(a,b,"c"), Ref);
assert_checkequal(union(a',b',"r"), Ref');
[v,ka,kb] = union(a,b,"c");
assert_checkequal(list(v,ka,kb), list(Ref,[5 3 1 2],[2 1]));
[v,ka,kb] = union(a',b',"r");
assert_checkequal(list(v,ka,kb), list(Ref',[5 3 1 2],[2 1]));

// datetime
A = datetime(2025, 7, [1 8 4 5 2 1]);
B = datetime(2025, 7, [9 7 4 2 1 4]);
u = union(A, B);
assert_checkequal(u, datetime(2025, 7, [1 2 4 5 7 8 9]));

[u, ka, kb] = union(A, B);
assert_checkequal(ka, [1 5 3 4 2]);
assert_checkequal(kb, [2 1]);

A = A';
B = B';
u = union(A, B);
assert_checkequal(u, datetime(2025, 7, [1 2 4 5 7 8 9]));

[u, ka, kb] = union(A, B);
assert_checkequal(ka, [1 5 3 4 2]);
assert_checkequal(kb, [2 1]);

a  = datetime(2025, 7, 1) + hours([2.   2.   1.   2.   0.
      0.   2.   1.   2.   1. ]);
b  = datetime(2025, 7, 1) + hours([1.   0.   2.   0.   1.
      2.   0.   0.   1.   1. ]);
Ref= datetime(2025, 7, 1) + hours([0.   0.   1.   1.   2.   2.
      0.   1.   1.   2.   0.   2. ]);
assert_checkequal(union(a,b,"c"), Ref);
assert_checkequal(union(a',b',"r"), Ref');
[v,ka,kb] = union(a,b,"c");
assert_checkequal(list(v,ka,kb), list(Ref,[5 3 1 2],[2 1]));
[v,ka,kb] = union(a',b',"r");
assert_checkequal(list(v,ka,kb), list(Ref',[5 3 1 2],[2 1]));

// table
A = table([1; 8; 4; 5; 2; 1]);
B = table([9; 7; 4; 2; 1; 4]);
u = union(A, B);
assert_checkequal(u, table([1; 2; 4; 5; 7; 8; 9]));

[u, ka, kb] = union(A, B);
assert_checkequal(ka, [1 5 3 4 2]);
assert_checkequal(kb, [2 1]);

A = table([0,0,1,1,1;
      0,1,1,1,1;
      2,0,1,1,1;
      0,2,2,2,2;
      2,0,1,1,1;
      0,0,1,1,3]');
B = table([1,0,1;
     1,0,2;
     1,2,3;
     2,0,4;
     1,2,5;
     3,0,6]');
[v, ka, kb] = union(A,B);
assert_checkequal(v, [A(ka, :); B(kb, :)]);

A = table([1;3;4;2], ["d";"c";"f";"h"], [%f;%t;%t;%f]);
B = table([2;3;4;1], ["d";"c";"f";"h"], [%t;%t;%t;%t]);

[v, ka, kb] = union(A,B);
assert_checkequal(v, table([1;1;2;2;3;4], ["d";"h";"d";"h";"c";"f"], [%f;%t;%t;%f; %t;%t]));
assert_checkequal(ka, [1 4 2 3]);
assert_checkequal(kb, [4 1]);

A = table([1;3;4;2], ["d";"c";"f";"h"], [%f;%t;%t; %f], "VariableNames", ["double", "string", "boolean"]);
B = table([2;3;4;1], [%t;%t;%t;%t], ["d";"c";"f";"h"], "VariableNames", ["double", "boolean", "string"]);
[M, ka, kb] = union(A, B);
assert_checkequal(M, table([1;1;2;2;3;4], ["d";"h";"d";"h";"c";"f"], [%f;%t;%t;%f; %t;%t], "VariableNames", ["double", "string", "boolean"]));
assert_checkequal(ka, [1 4 2 3]);
assert_checkequal(kb, [4 1]);

A = table([1;0;1],"RowNames", ["a";"b";"c"]);
B = table([0 1 0]', "RowNames", ["a";"b";"c"]);
[u, ka, kb] = union(A, B);
assert_checkequal(u, table([0;1], "RowNames", ["b";"a"]));
assert_checkequal(ka, [2 1]);
assert_checkequal(kb, []);

// timeseries
A = timeseries(hours(1:6)', [1; 8; 4; 5; 2; 1]);
B = timeseries(hours([1; 2; 3; 5; 1; 7]),[9; 7; 4; 2; 1; 4]);
u = union(A, B);
assert_checkequal(string(u), string(timeseries(hours([1;1;2;2;3;4;5;6;7]), [1;9;7;8;4;5;2;1;4])));

[u, ka, kb] = union(A, B);
assert_checkequal(ka, [1 2 3 4 5 6]);
assert_checkequal(kb, [1 2 6]);

A = timeseries(hours(1:5)',[0,0,1,1,1;
      0,1,1,1,1;
      2,0,1,1,1;
      0,2,2,2,2;
      2,0,1,1,1;
      0,0,1,1,3]');
B = timeseries(hours([5; 1; 10]),[1,0,1;
     1,0,2;
     1,2,3;
     2,0,4;
     1,2,5;
     3,0,6]');

[v, ka, kb] = union(A,B);
expected = [A(ka, :); B(kb, :)];
assert_checkequal(string(v), string(expected));

A = timeseries(hours([1;3;4;2]), ["d";"c";"f";"h"], [%f;%t;%t;%f]);
B = timeseries(hours([2;3;4;1]), ["d";"c";"f";"h"], [%t;%t;%t;%t]);

[v, ka, kb] = union(A,B);
assert_checkequal(string(v), string(timeseries(hours([1;1;2;2;3;4]), ["d";"h";"d";"h";"c";"f"], [%f;%t;%t;%f; %t;%t])));
assert_checkequal(ka, [1 4 2 3]);
assert_checkequal(kb, [4 1]);

A = timeseries(hours([1;3;4;2]), ["d";"c";"f";"h"], [%f;%t;%t; %f], "VariableNames", ["double", "string", "boolean"]);
B = timeseries(hours([2;3;4;1]), [%t;%t;%t;%t], ["d";"c";"f";"h"], "VariableNames", ["double", "boolean", "string"]);
[M, ka, kb] = union(A, B);
assert_checkequal(string(M), string(timeseries(hours([1;1;2;2;3;4]), ["d";"h";"d";"h";"c";"f"], [%f;%t;%t;%f; %t;%t], "VariableNames", ["double", "string", "boolean"])));
assert_checkequal(ka, [1 4 2 3]);
assert_checkequal(kb, [4 1]);