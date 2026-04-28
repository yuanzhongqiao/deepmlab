// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function dydx = diffxy(x, y, N, dim)

    arguments
        x {mustBeA(x, "double")}
        y {mustBeA(y, "double")}
        N {mustBeA(N, "double"), mustBeReal, mustBeInteger, mustBePositive, mustBeScalar} = 1
        dim {mustBeA(dim, ["double", "string"]), mustBeScalarOrEmpty} = find(size(y) > 1, 1)
    end

    if isempty(y) | isscalar(y) then
        dydx = [];
        return
    end

    nd = ndims(y);

    if typeof(dim) == "string" then
        select dim
        case "r"
            dim = 1;
        case "c"
            dim = 2;
        else
            error(msprintf(_("%s: Wrong value for input argument #%d: Must be in the set %s.\n"), "diffxy", 4, sci2exp({1, 2, "r", "c"})));
        end
    else
        if dim < 1 | dim <> round(dim) then
            error(msprintf(_("%s: Wrong value for input argument #%d: Non-negative numbers expected.\n"), "diffxy", 4));
        end

        if (dim <> -1 & dim > nd) then
            dydx = [];
            return
        end
    end

    size_y = size(y, dim);
    if size_y < 2 then
        dydx = [];
        return;
    elseif size_y == 2 then
        idx0 = 2;
        idx1 = 1;

        args = emptystr(3, nd) + ":";
        args(:, dim) = ["1"; "2"; "$"];
        args = strcat(args, ",", "c");
    else
        idx0 = 2:size_y-1;
        idx1 = 1:size_y-2;
        idx2 = 3:size_y;

        args=emptystr(7, nd) + ":";
        args(:, dim) = ["2:size_y-1"; "1:size_y-2"; "3:size_y"; "1"; "2"; "$"; "$-1"];
        args = strcat(args, ",", "c");
    end

    dydx = y;

    if isscalar(x) then
        hm = x;
        hp = x;
    elseif isvector(x) then
        if isvector(y) then
            sx = size(x);
            sy = size(y);
            if prod(sx) <> prod(sy) then
                error(msprintf(_("%s: Wrong size for input argument #%d: Must be of size %d.\n"), "diffxy", 1, size_y));
            end

            if sx <> sy then
                // x is column vector and y is row vector and vice versa
                x = matrix(x, sy);
            end
            x0 = x(idx0);
            hm = x0 - x(idx1);
            if size_y <> 2 then
                hp = x(idx2) - x0;
            end
        else
            if size(x, "*") <> size_y then
                error(msprintf(_("%s: Wrong size for input argument #%d: Must be of size %d.\n"), "diffxy", 1, size_y));
            end

            if dim == 1 then
                o = ones(1, size(y, 2));
            else
                o = ones(size(y, 1), 1);
            end
            x0 = x(idx0);
            hm = (x0 - x(idx1)).*.o;
            if size_y <> 2 then
                hp = (x(idx2) - x0).*.o;
            end
        end
    else
        if or(size(x) ~= size(y)) then
            error("same dimensions expected.\n");
        end

        execstr("hm = x("+args(1,:)+") - x("+args(2,:)+");" + ...
        "if size_y <> 2 then hp = x("+args(3,:)+") - x("+args(1,:)+"); end");
    end

    if size_y == 2 then
        for i = 1:N
            execstr("vm = (dydx("+args(2,:)+") - dydx("+args(1,:)+"))./hm;" + ...
                "dydx("+args(1,:)+") = vm("+args(1,:)+");" + ...
                "dydx("+args(3,:)+") = dydx("+args(1,:)+");");
        end
    else
        for i = 1:N
            execstr("dydx0=dydx("+args(1,:)+");" + ...
                "vm = (dydx0 - dydx("+args(2,:)+"))./hm;" + ...
                "vp = (dydx("+args(3,:)+") - dydx0)./hp;" + ...
                "dydx("+args(1,:)+") = (hm .* vp + hp .* vm) ./ (hp + hm);" + ...
                "dydx("+args(4,:)+") = 2 * vm("+args(4,:)+") - dydx("+args(5,:)+");" + ...
                "dydx("+args(6,:)+") = 2 * vp("+args(6,:)+") - dydx("+args(7,:)+");");

        end
    end

endfunction