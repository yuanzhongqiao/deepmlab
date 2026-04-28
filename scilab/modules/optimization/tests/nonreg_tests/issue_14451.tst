// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14451 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14451
//
// <-- Short Description -->
// fsolve is no longer reentrant, causes crash
//

/*** test from the issue ***/
function y=toto(x,a)
    printf(".");
    y=(x-a);
endfunction

function y=titi(x)
    printf("o");
    [y,v,info]=fsolve(0,list(toto,x));
    // should answer y=x;
endfunction

function y=tutu(x)
    printf("|");
    [y,v,info]=fsolve(1,titi);
    // should answer 0
    printf("|\n");
endfunction

x=1;
y=tutu(x);
assert_checkequal(y, 0);


/*** test from comments ***/
function z=g(x)
    z=x^2-2;
endfunction
function y=F(x), global g;
    y=fsolve(1,g)
    y=x-y;
endfunction
assert_checkalmostequal(fsolve(1,F), sqrt(2));


function y=toto(x,a)
    printf(".");
    y=(x-a);
endfunction

function y=titi(x)
    global toto
    printf("o");
    [y,v,info]=fsolve(0,list(toto,x));
endfunction

[y,v,info]=fsolve(1,titi);
assert_checkequal(y, 0);
