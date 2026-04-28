// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function out=g1(t,y)
    out = [1;-1];
endfunction 

function out=g2(t,y)
    out = y;
endfunction 

function out=g3(t,y)
    out = t*y;
endfunction

function out=g4(t,y)
    out = (t+%i)*y;
endfunction
function out=g4r(t,y)
    out = t*y;
endfunction
function out=g4i(t,y)
    out = y;
endfunction

[t,y,info] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g1);
assert_checkalmostequal(info.q, [10;-10]);

sol = cvode(%SUN_vdp1,[0 10],[1 2],quadRhs=g1);
assert_checkalmostequal(size(sol.q,2), size(sol.y,2));
assert_checkalmostequal(sol.q(:,$), [10;-10]);

[t,y,info] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g2);
assert_checkalmostequal(info.q, [2.9850956;-2.5902901]);

q0=[1;2];
[t,y,info] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g2,yQ0=q0);
assert_checkalmostequal(info.q, q0+[2.9850956;-2.5902901],1e-6);

[t,y,info] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g3);
assert_checkalmostequal(info.q, [13.409174;-18.887909],1e-6);

OPT.rtol=1e-8;
OPT.atol=1e-10;
[t,y,info] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g4,options=OPT);
[tr,yr,infor] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g4r,options=OPT);
[ti,yi,infoi] = cvode(%SUN_vdp1,10,[1 2],t0=0,quadRhs=g4i,options=OPT);
assert_checkalmostequal(info.q,complex(infor.q,infoi.q),1e-6)
