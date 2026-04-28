// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [m, k] = %duration_min(varargin)
    elements = varargin;
    fname = "%duration_min";

    // If the first argument is a list, it retrieves the number of sparse
    // matrices in list
    if type(varargin(1)) == 15 then
        if nargin <> 1 then
            error(msprintf(_("%s: Wrong number of input argument: %d expected.\n"), fname, 1))
        end

        e = varargin(1);
        [m, k] = min(e(:));
        return
    end

    A1 = elements(1);
    d = A1.duration;
    [m1, n1] = size(d);

    if nargin == 1 then
    // min(A)
    // ------
        [m,k] = min(d);

    // min(A, "r"|"c"|"m")
    // -------------------
    elseif nargin == 2 & type(elements(2)) == 10
        
        if d == [] then
            m = A1
            k = []
            return
        end
        opts = elements(2);
        if ~or(opts==["c","r","m"]) then
            msg = _("%s: Wrong value for input argument #%d: [''r'' ''c'' ''m''] expected.\n")
            error(msprintf(msg, fname, 2))
        end
        [m, k] = min(d, opts);
        
    // min(A1,A2,...) or equivalently min(list(A1,A2,..))
    // --------------------------------------------------
    else
        if nargout > 1 then
            k = ones(d)
        end

        v = list(d);
        
        // Loop on the number of input arguments
        for i = 2:nargin
            An = elements(i)
            // Check if An is a sparse
            if typeof(An) <> "duration" then
                msg = _("%s: Wrong type for input argument #%d: A duration expected.\n")
                error(msprintf(msg, fname, i))
            end

            v(i) = An.duration;
        end
        
        [m,k] = min(v);
    end
    m = mlist(["duration", "duration", "format"], m, A1.format);
endfunction
