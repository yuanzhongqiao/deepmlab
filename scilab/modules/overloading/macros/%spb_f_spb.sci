// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function c=%spb_f_spb(a,b)
    c = %sp_f_sp(a,b);
    if type(c) == 5 then //convert to bool sparse ex: [sparse([%f %f %f])sparse([%f %t %f])]
        c = c <> 0;
    end
end
