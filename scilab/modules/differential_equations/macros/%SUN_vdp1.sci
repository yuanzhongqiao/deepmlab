// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

function vdot=%SUN_vdp1(t, v)
    mu = 1;
    vdot = [v(2); mu*(1-v(1)^2)*v(2)-v(1)]
end
