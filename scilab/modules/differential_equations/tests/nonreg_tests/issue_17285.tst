// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
// <-- Non-regression test for issue 17285 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17285
//
// <-- Short Description -->
// leastsq, optim, fsolve, lsqsolve kill Scilab under macOS/arm64

// code from original issue
function YP=Model2(p,xc)
    x=1:300;
    df2=(exp(-x/p))/p;
    f2=cumsum(df2);
    YP=f2(xc)
endfunction
time=[10     50     70    80     100  170  200];
value= [   0.09   0.49   0.6   0.68   0.71   0.89   0.91];
function DV=cost(pv, xv, yv)
    DV= Model2(pv,xv)-yv;
endfunction
p=77;
cmd="[fopt,xopt,gopt]=leastsq(list(cost,time,value),p)";
error_message="Operator *: Wrong dimensions for operation [7x1] * [7x1].";
assert_checkerror(cmd,error_message);

// test optim() and leastsq() calls
function [f,g,ind]=cost(x,ind)
    f = 1+z;
endfunction
function f=eq(x)
    f=x*x+z;    
endfunction

clear z
cmds = [
"optim(cost,0,algo=""qn"")"
"optim(cost,0,algo=""gc"")"
"optim(cost,0,algo=""nd"")"
"optim(cost,""b"",-1,1,0,algo=""qn"")"
"optim(cost,""b"",-1,1,0,algo=""gc"")"
"optim(cost,""b"",-1,1,0,algo=""nd"")"
"leastsq(eq,""b"",-1,1,0,algo=""qn"")"
"leastsq(eq,0,algo=""gc"")"
"leastsq(eq,0,algo=""nd"")"
"leastsq(eq,0,algo=""qn"")"
]
for i=1:size(cmds,1)
    assert_checkerror(cmds(i),"Undefined variable: z")
end

// test fsolve
function f=jeq(x)
    f=2*x+t
endfunction
clear z
assert_checkerror("fsolve(0,eq)","Undefined variable: z")
z=1;
assert_checkerror("fsolve(0,eq,jeq)","Undefined variable: t")

// test lsqrsolve
function f=res(x,m)
    f=x*x+z;    
endfunction
function f=jres(x,m)
    f=2*x+t
endfunction
clear z
assert_checkerror("lsqrsolve(0,res,1)","Undefined variable: z")
z=1;
assert_checkerror("lsqrsolve(0,res,1,jres)","Undefined variable: t")

