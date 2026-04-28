function h = hankel(c, r)
    arguments
        c {mustBeA(c, "double"), mustBeVector}
        r {mustBeA(r, "double"), mustBeVector} = zeros(size(c, "*"), 1)
    end

    h = %_gallery("hankel", c, r);

endfunction