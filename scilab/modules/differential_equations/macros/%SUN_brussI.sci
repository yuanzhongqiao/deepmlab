// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

function dydt = %SUN_brussI(t,y,b,ep)
    w=y(3);
    dydt = [0; 0; (b-w)/ep];
end
