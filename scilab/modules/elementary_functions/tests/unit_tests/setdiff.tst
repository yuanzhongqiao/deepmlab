// ===================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
// Copyright (C) 2018 - 2020 - Samuel GOUGEON - Le Mans Université
//
//  This file is distributed under the same license as the Scilab package
// ===================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
// ===================================================================
//
// unit tests of setdiff(), except for
//    booleans: => tested in setdiff_boolean.tst
//    sparses : => tested in setdiff_sparse.tst
//
a = [223;111;2;4;2;2];
b = [2;3;21;223;123;22];
REF_K = [4 ; 2];
for f = list(double, int8, uint8, int16, uint16, int32, uint32, int64, uint64)
    REF_V = f([4 ; 111]);
    [v,k]= setdiff(f(a), f(b));
    assert_checkequal(v, REF_V);
    assert_checkequal(k, REF_K);
end

// ===================================================================

REF_V = ['111' ; '4'];
REF_K = [2; 4];
[v,k] = setdiff(string(a),string(b));
assert_checkequal(v, REF_V);
assert_checkequal(k, REF_K);

// ===================================================================
s  = 7;
s2 = 5;
r  = [14   0  4  7   8  15   7  17  15  12];
r2 = [ 2  11  1  0  15   7  10   5];
c  = r';
c2 = r2';
m  = [
   1  3  2  0  0  0  1  2  1  3
   1  3  2  1  3  1  2  3  1  0
];
m2  = [
   0  3  1  1  3  2  0  2  0
   2  0  0  2  2  1  2  2  3
 ];
h = cat(3, m(:,1:6), m2(:,1:6));
h2 = cat(3, m([2 1],1:6), m2([2 1],1:6));
L  = list(s,  r,  c,  m,  h);
L2 = list(s2, r2, c2, m2, h2);

for fun = list(double, string)

    // With a=[] , orien = none|"r"|"c"
    // --------------------------------
    for i = 1:length(L)
        o = fun(L(i));
        [va, ka] = setdiff([], o);
        assert_checkequal(va, []);
        assert_checkequal(ka, []);
    
        [va, ka] = setdiff([], o, "r");
        assert_checkequal(va, []);
        assert_checkequal(ka, []);
        [va, ka] = setdiff([], o, "c");
        assert_checkequal(va, []);
        assert_checkequal(ka, []);
    end

    // With b=[] , orien = none|"r"|"c"
    // --------------------------------
    for i = 1:length(L)
        o = fun(L(i));
        [va, ka] = setdiff(o,[]);
        [var,kar]= unique(o);
        assert_checkequal(va, var);
        assert_checkequal(ka, kar);

        if ndims(o)>2
            [var,kar] = unique(matrix(permute(o,[2 1 3]),6,-1)', "r");
        else
            [var,kar] = unique(o, "r");
        end
        [va, ka] = setdiff(o, [], "r");
        assert_checkequal(va, var);
        assert_checkequal(ka, kar);
        [va, ka] = setdiff(o, [], "c");
        if ndims(o)>2
            [var,kar] = unique(matrix(o,2,-1), "c");
        else
            [var,kar] = unique(o, "c");
        end
        assert_checkequal(va, var);
        assert_checkequal(ka, kar);
    end
end

// "r" and "c" options
// -------------------
for f = list(string, double, int8, uint8, int16, uint16, int32, uint32, int64, uint64)
    if f==string then
        vref = ["12" "14" "17" "4" "8"];
        kvref = [ 10    1    8   3   5];
    else
        vref = [4  8  12  14  17];
        kvref = [3  5  10   1   8];
    end
    // With row vectors
    [rr,k] = setdiff(f(r), f([r2 0 2]), "r");
    assert_checkequal(rr, f(r));
    assert_checkequal(k, 1);
    [rc,k] = setdiff(f(r), f(r2), "c");
    assert_checkequal(rc, f(vref));
    assert_checkequal(k,  kvref);

    // With column vectors
    [rc,k] = setdiff(f(r'), f([r2 0 2]'), "c");
    assert_checkequal(rc, f(r'));
    assert_checkequal(k, 1);
    [rr,k] = setdiff(f(r'), f(r2'), "r");
    assert_checkequal(rr, f(vref'));
    assert_checkequal(k,  kvref');

    // With matrices
    [mc,k] = setdiff(f(m), f(m2), "c");
    assert_checkequal(mc, f([0  1  2  3
                             1  1  3  3]));
    assert_checkequal(k,    [4  1  8  2]);
    [mr,k] = setdiff(f(m'), f(m2'), "r");
    assert_checkequal(mr, f([0  1  2  3
                             1  1  3  3]'));
    assert_checkequal(k,    [4  1  8  2]');

    // With hypermatrices
    [hc,k] = setdiff(f(h), f(h2), "c");
    assert_checkequal(hc, f([0  3
                             2  2]));
    assert_checkequal(k,    [7 11]);

    hr  = permute(h, [2 1 3]);
    h2r = permute(h2,[2 1 3]);
    [hr,k] = setdiff(f(hr), f(h2r), "r");
    assert_checkequal(hr, f([0  2
                             3  2]));
    assert_checkequal(k,    [7 11]');
end

// duration
A = hours([ 1 8 4 5 2 1]);
B = hours([ 1 7 4]);
s = setdiff(A, B);
assert_checkequal(s, hours([2 5 8]));

[s, ka] = setdiff(A, B);
assert_checkequal(s, hours([2 5 8]));
assert_checkequal(ka, [5 4 2]);

s = setdiff(A', B');
assert_checkequal(s, hours([2; 5; 8]));

[s, ka] = setdiff(A', B');
assert_checkequal(s, hours([2; 5; 8]));
assert_checkequal(ka, [5; 4; 2]);

A = hours([1 2 2 1;3 1 2 2]);
B = hours([0 3 0 3;0 2 1 0]);
ref = hours([1 1 2 2;2 3 1 2]);
[s, k] = setdiff(A, B, "c");
assert_checkequal(s, ref);
assert_checkequal(k, [4 1 2 3]);

[s, k] = setdiff(A, B, "r");
assert_checkequal(s, A);
assert_checkequal(k, [1;2]);

// datetime
A = datetime(2025, 8, [ 1 8 4 5 2 1]);
B = datetime(2025, 8, [ 1 7 4]);
s = setdiff(A, B);
assert_checkequal(s, datetime(2025, 8, [2 5 8]));

[s, ka] = setdiff(A, B);
assert_checkequal(s, datetime(2025, 8, [2 5 8]));
assert_checkequal(ka, [5 4 2]);

s = setdiff(A', B');
assert_checkequal(s, datetime(2025, 8, [2; 5; 8]));

[s, ka] = setdiff(A', B');
assert_checkequal(s, datetime(2025, 8, [2; 5; 8]));
assert_checkequal(ka, [5; 4; 2]);

A = datetime(2025, 7, 1) + hours([1 2 2 1;3 1 2 2]);
B = datetime(2025, 7, 1) + hours([0 3 0 3;0 2 1 0]);
ref = datetime(2025, 7, 1) + hours([1 1 2 2;2 3 1 2]);
[s, k] = setdiff(A, B, "c");
assert_checkequal(s, ref);
assert_checkequal(k, [4 1 2 3]);

[s, k] = setdiff(A, B, "r");
assert_checkequal(s, A);
assert_checkequal(k, [1;2]);

// table
A = table([1; 8; 4; 5; 2; 1]);
B = table([9; 7; 4; 2; 1; 4]);
s = setdiff(A, B);
assert_checkequal(s, table([5; 8]));

[s, k] = setdiff(A, B);
assert_checkequal(k, [4; 2]);

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
[s, k] = setdiff(A,B);
assert_checkequal(s, A(k, :));

A = table([1;3;4;2], ["d";"c";"f";"h"], [%f;%t;%t;%f]);
B = table([2;3;4;1], ["d";"c";"f";"h"], [%t;%t;%t;%t]);

[s, k] = setdiff(A,B);
assert_checkequal(s, A(k, :));

A = table([1;3;4;2], ["d";"c";"f";"h"], [%f;%t;%t; %f], "VariableNames", ["double", "string", "boolean"]);
B = table([2;3;4;1], [%t;%t;%t;%t], ["d";"c";"f";"h"], "VariableNames", ["double", "boolean", "string"]);
[s, k] = setdiff(A,B);
assert_checkequal(s, A(k, :));

// timeseries
// timeseries
A = timeseries(hours(1:6)', [1; 8; 4; 5; 2; 1]);
B = timeseries(hours([1; 2; 3; 5; 1; 7]), [9; 7; 4; 2; 1; 4]);
s = setdiff(A, B);
assert_checkequal(s, timeseries(hours([2;4;6]), [8;5;1]));

[s, k] = setdiff(A, B);
assert_checkequal(k, [2;4;6]);

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
[s, k] = setdiff(A,B);
assert_checkequal(s, A(k, :));

A = timeseries(hours([1;3;4;2]), ["d";"c";"f";"h"], [%f;%t;%t;%f]);
B = timeseries(hours([2;3;4;1]), ["d";"c";"f";"h"], [%t;%t;%t;%t]);

[s, k] = setdiff(A,B);
assert_checkequal(s, A(k, :));

A = timeseries(hours([1;3;4;2]), ["d";"c";"f";"h"], [%f;%t;%t;%f], 'VariableNames', ["Time", "string", "boolean"]);
B = timeseries(hours([2;3;4;1]), [%t;%t;%t;%t], ["d";"c";"f";"h"], 'VariableNames', ["Time", "boolean", "string"]);
[s, k] = setdiff(A, B);
assert_checkequal(s, A(k, :));


// ===================================================================
// Error messages
msg = "%s: Wrong number of input arguments: %d to %d expected.\n";
assert_checkerror("setdiff()", msg , [], "setdiff", 2, 3);
