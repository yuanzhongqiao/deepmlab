// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = gradient(f, h, varargin)
    arguments
        f {mustBeA(f, "double")}
        h {mustBeA(h, "double")} = 1
        varargin
    end

    if isempty(f) then
        varargout = list([], []);
        return
    end

    nd = ndims(f);
    lhs = max([nargout, 1]);
    if lhs > nd then
        error(msprintf(_("%s: Wrong number to output arguments: %d expected.\n"), "gradient", nd));
    end

    iscol = %f;

    if isvector(f) then
        n = length(f);
        if iscolumn(f) then
            iscol = %t;
            f = f.';
        end
    end

    s = size(f);
    dim = [2 1 3:nd];
    n = s(dim(1));

    if isempty(h) then
        error(msprintf(_("%s: Wrong value for input argument #%d: a non-empty matrix expected.\n"), "gradient", 2));
    elseif isscalar(h) then
        H = h .* (1:n);
    else
        if ~isvector(h) | size(h, "*") <> n then
            error(msprintf(_("%s: Wrong size for input argument #%d: a vector of length %d expected.\n"), "gradient", 2, n));
        end
        H = h;
    end

    H = list(H);

    if nargin > 2 then
        nbh = length(varargin)
        if lhs <> nbh + 1 then
            error(msprintf(_("%s: Wrong number of output arguments: %d expected.\n"), "gradient", nbh + 1));
        end
        
        for k = 1:nbh
            h = varargin(k);
            if typeof(h) <> "constant" then
                error(msprintf(_("%s: Wrong type for input argument #%d: A double expected.\n"), "gradient", k+2));
            end
            n = s(dim(k+1));
            if isempty(h) then
                error(msprintf(_("%s: Wrong value for input argument #%d: a non-empty matrix expected.\n"), "gradient", 2));
            elseif isscalar(h) then
                h = h .* (1:n);
            else
                if ~isvector(h) | size(h, "*") <> n then
                    error(msprintf(_("%s: Wrong size for input argument #%d: a vector of length %d expected.\n"), "gradient", 2, n));
                end
            end
            H(k+1) = h;
        end
        for k = nbh+2:nd
            n = s(dim(k));
            H(k) = 1:n;
        end
    else
        for k = 2:nd
            n = s(dim(k));
            H(k) = h .* (1:n);
        end
    end

    if isvector(f) then
        HH1 = matrix(H(1), 1,-1);
        HH2 = HH1.';
    else
        k = 1:nd;
        execstr("[" + strcat("HH"+ string(k), ",")+ "] = ndgrid(H(:));");
        for i = k
            execstr("HH" + string(i) + " = permute(HH" + string(i) + ", [2 1 3:nd]);")
        end
            
        if nd == 2 then
            HH1 = HH1(1:s(1), 1:s(2));
            HH2 = HH2(1:s(1), 1:s(2));
        end
    end
  
    for k = 1:lhs
        n = size(f, dim(k));
        g = zeros(f);
        args = emptystr(7, nd) + ":";
        args(:, dim(k)) = ["1"; "2"; "n"; "n-1"; "2:n-1"; "3:n"; "1:n-2"];
        args = strcat(args, ",", "c");
        kk = string(k);       

        if n > 1 then
            execstr("g("+ args(1)+") = (f("+ args(2)+") - f("+ args(1)+"))./(HH"+kk+"("+ args(2)+") - HH"+kk+"("+ args(1)+"));" + ...
                "g("+args(3)+") = (f("+ args(3)+") - f("+ args(4)+"))./(HH"+kk+"("+ args(3)+") - HH"+kk+"("+ args(4)+"))")
        end
        if n > 2 then
            execstr("g("+ args(5)+") = (f("+ args(6)+") - f("+ args(7)+"))./(HH"+kk+"("+ args(6)+") - HH"+kk+"("+ args(7)+"));")
        end

        varargout(k) = g;
    end

    if iscol then
        varargout(1) = varargout(1).';
    end

endfunction
