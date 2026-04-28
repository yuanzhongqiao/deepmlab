// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

function dydt = %SUN_bruss(t,y,a,b,ep)
    u=y(1); v=y(2); w=y(3);
    dydt = [a-(w+1)*u+v*u*u; w*u-v*u*u; (b-w)/ep-w*u];
end
