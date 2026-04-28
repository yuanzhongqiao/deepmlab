// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->

//===============================
//      sci2exp() unit tests
//===============================
// -----
// EYE()
// -----
L = list(int8(-45), uint32(%inf) -45.7, %nan, %inf, -45.7+%i*72.3, ..
    complex(72.3,%nan), complex(2.3,%inf), complex(%nan,-54), ..
    1-%z, (2-%z)^2, (%i-%z)^2, poly(complex([1 2],[2 -3]),"z","coeff"));
for o = L
    o = o*eye();
    assert_checkequal(o, evstr(sci2exp(o)));
end

// --------
// BOOLEANS
// --------
S = [1 1 1; 1 3 1; 3 1 1; 2 5 1; 2 5 3];  // sizes
for s = S'
    i = grand(s(1),s(2), s(3), "uin", 0, 1)==1;
    assert_checkequal(i, evstr(sci2exp(i)));
end

// --------
// INTEGERS
// --------
S = [1 1 1; 1 3 1; 3 1 1; 2 5 1; 2 5 3];  // sizes
F = list(int8,uint8,int16,uint16,int32,uint32,int64,uint64);
for f = F
    if f==int64 then
        [low, high] = (f(-(2^52)), f(2^52))
    elseif f==uint64
        [low, high] = (f(0), f(2^52))
    else
        [low, high] = (f(-%inf), f(%inf))
    end
    for s = S'
        i = f(grand(s(1),s(2), s(3), "unf", double(low), double(high)))
        assert_checkequal(i, evstr(sci2exp(i)))
    end
end

// ----------------------
// REAL & COMPLEX NUMBERS
// ----------------------
tmp = format();
format("e",23)
S = [1 1 1; 1 40 1; 40 1 1; 8 5 1; 5 4 2];  // sizes
for s = S'
    re = grand(s(1),s(2), s(3), "unf", -1,1);
    rep = grand(s(1),s(2), s(3), "uin",-20,20);
    r = re.*(10.^rep);
    assert_checkequal(r, evstr(sci2exp(r)));
    im = grand(s(1),s(2), s(3),  "unf", -1,1);
    imp = grand(s(1),s(2), s(3), "uin",-20,20);
    i = im.*(10.^imp);
    c = complex(r, i);
    assert_checkequal(c, evstr(sci2exp(c)));

    // Cases with %nan or/and %inf : http://bugzilla.scilab.org/16317
    n = prod(s)
    if n > 10
        ns = ceil(n/10)
        [reM,imM] = (re,im);
        t = samwr(ns,6,1:n)
        reM(t(:,1)) = -%inf
        reM(t(:,2)) = %inf
        reM(t(:,3)) = %nan
        imM(t(:,4)) = -%inf
        imM(t(:,5)) = %inf
        imM(t(:,6)) = %nan
        rM = reM.*(10.^rep);
        assert_checkequal(rM, evstr(sci2exp(rM)));
        iM = imM.*(10.^imp);
        c = complex(rM, iM);
        assert_checkequal(c, evstr(sci2exp(c)));
    else // scalar
        c = complex(-%inf,2);    assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(%inf,2);     assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(%nan,2);     assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(2,-%inf);    assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(2,%inf);     assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(2,%nan);     assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(%inf,2);     assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(%inf,-%inf); assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(%inf,%nan);  assert_checkequal(c, evstr(sci2exp(c)));
        c = complex(%nan,-%inf); assert_checkequal(c, evstr(sci2exp(c)));
    end
end
format(tmp([2 1]))

c = {1, %t, %s, 3+%i};
s = sci2exp(c);
assert_checkequal(s, "{1,%t,%s,3+%i}");

c = c';
assert_checkequal(sci2exp(c), "{1;%t;%s;3+%i}");

c = {1, {"toto", "titi"; %t, [1 2;3 4]}; [2;4], %s};
assert_checkequal(sci2exp(c), "{1,{""toto"",""titi"";%t,[1,2;3,4]};[2;4],%s}");

clear c;
c{1,1,3} = {1 "toto"; %t %s};
assert_checkequal(sci2exp(c), "matrix({[],[],{1,""toto"";%t,%s}}, [1,1,3])");