// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = colormap(varargin)

    setCmap = %T; // if %F then this function is called only to get a colormap
    h = [];
    m = [];

    if nargin == 0 then // cmap = colormap(): get current figure colormap
        h = gcf();
        setCmap = %F;
    end


    if nargin == 1 then
        if type(varargin(1)) == 9 then // cmap = colormap(h): get figure colormap
            hPos = 1;
            h = varargin(1);
            setCmap = %F;
        else // cmap = colormap(m): set current figure colormap
            h = gcf();
            mPos = 1;
            m = varargin(1);
        end
    end

    if nargin == 2 then // cmap = colormap(h, m); set figure colormap
        hPos = 1;
        h = varargin(1);
        mPos = 2;
        m = varargin(2);
    end

    if nargin > 2 then
        error(msprintf(gettext("%s: Wrong number of input argument(s): %d to %d expected.\n"), "colormap", 0, 2));
    end

    // Test h value
    if type(h) <> 9 | (h.type <> "Figure" && h.type <> "Axes") then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: a ''Figure'' or an ''Axes'' handle expected.\n"), "colormap", hPos));
    elseif size(h, "*") <> 1 then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: a ''Figure'' or an ''Axes'' handle expected.\n"), "colormap", hPos));
    end

    if setCmap then

        // Test m value
        if type(m) == 10 then // function name or 'default'
            if size(m, "*") <> 1 then
                error(msprintf(gettext("%s: Wrong size for input argument #%d: a string expected.\n"), "colormap", mPos));
            end
        elseif or(type(m) == [13, 130]) then // function
            // No way to check size
        elseif type(m) == 1 then
            if size(m, 2) <> 3 then
                error(msprintf(gettext("%s: Wrong size for input argument #%d: a Nx3 matrix expected.\n"), "colormap", mPos));
            end
        else
            error(msprintf(gettext("%s: Wrong type for input argument #%d: a string, a function, or a Nx3 matrix expected.\n"), "colormap", mPos));
        end

        ierr = 0;
        if type(m) == 10 then // Function name
            if m == "default" then // Default colormap
                cmapValues = gdf().color_map;
            else
                ierr = execstr("cmapValues = " + m + "();", "errcatch");
            end
        else // Function
            ierr = execstr("cmapValues = m();", "errcatch");
        end

        if ierr <> 0 then
            error(msprintf(gettext("%s: Error while generating colormap:\n%s"), "colormap", lasterror()))
        end

        if size(cmapValues, 2) <> 3 then
            error(msprintf(gettext("%s: Wrong number of columns for generated colormap: 3 expected but got %d.\n"), "colormap", size(cmapValues, 2)))
        end
    
        // Set colormap
        h.color_map = cmapValues;
    end


    // Output argument management
    varargout = list();
    if nargout == 1 | setCmap == %F then
        varargout(1) = h.color_map;
    end

endfunction
