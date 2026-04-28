// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2021 - UTC - Stéphane Mottelet
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received

function r = %SUN_sir(t,y,yp)
    r = [yp(1)+0.2*y(1)*y(2)
         yp(2)-0.2*y(1)*y(2)+0.05*y(2)  
          y(1)+y(2)+y(3)-1];
end
