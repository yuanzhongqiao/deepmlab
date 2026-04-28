// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


// fixed point iteration

function out = f(x)
    out = x^2-2; 
end
function out = g(x)
    out = x/2+1/x; 
end

x = kinsol(g,1,method="fixedPoint");
x = kinsol(f,1,method="Picard",jacobian=2);





