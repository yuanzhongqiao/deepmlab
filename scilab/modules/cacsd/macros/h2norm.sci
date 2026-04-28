// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA -
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [nh]=h2norm(g,tol)
    //
    //                 /+00
    //     2           |          *
    //  |g| =1/(2*%pi).|trace[g(jw).g(jw)]dw
    //     2           |
    //                 /-00

    arguments
        g {mustBeA(g, ["r", "lss"])}
        tol (1,1) {mustBeA(tol, "double"), mustBeReal, mustBePositive}= 1000*%eps
    end

    if g.dt<>"c" & g.dt<>[] then
        msg = gettext("%s: Wrong type for argument #%d: In continuous or undefined time domain expected.\n")
        error(msprintf(msg,"h2norm",1))
    end

    select typeof(g)
    case "state-space" then
        if norm(g.D)>0 then
            msg = gettext("%s: Wrong value for input argument #%d: Proper system expected.\n")
            error(msprintf(msg, "h2norm", 1)),
        end;
        sp = spec(g.A),
        if max(real(sp))>=-tol then
            msg = gettext("%s: Wrong value for input argument #%d: Stable system expected.\n")
            error(msprintf(msg, "h2norm", 1)),
        end,
        w=obs_gram(g.A,g.C,"c"),
        nh=abs(sqrt(sum(diag(g.B'*w*g.B)))),return,
    case "rational" then
        num = g.num;
        den = g.den;
        s = poly(0,varn(den))
        [t1,t2] = size(num)
        for i = 1:t1,
            for j = 1:t2,
                n = num(i,j)
                d = den(i,j),
                if coeff(n)==0 then
                    nh(i,j) = 0
                else
                    if degree(n) >= degree(d) then
                        msg = gettext("%s: Wrong value for input argument #%d: Proper system expected.\n")
                        error(msprintf(msg, "h2norm", 1)),
                    end
                    pol = roots(d),
                    if max(real(pol))>-tol then
                        msg = gettext("%s: Wrong value for input argument #%d: Stable system expected.\n")
                        error(msprintf(msg, "h2norm", 1))
                    end,
                    nt = horner(n,-s)
                    dt = horner(d,-s)
                    nh(i,j) = residu(n*nt,d,dt)
                end,
            end
        end
        nh=sqrt(sum(nh)),return,
    end
endfunction
