// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) Samuel GOUGEON <sgougeon@free.fr>
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function rep = %r_varn(p, varname)
    if argn(2)==1 then
        if type(p.num) == 2 then
            rep = varn(p.num);
        elseif type(p.den) == 2 then
            rep = varn(p.den);
        else
            // fallback, will probably error with undefined overload
            rep = varn(p.num);
        end
    else
        rep = rlist(varn(p.num, varname), varn(p.den, varname), p.dt);
    end
endfunction
