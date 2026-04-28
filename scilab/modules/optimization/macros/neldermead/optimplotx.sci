// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//
// optimplotx --
//   Emulate the optimplotfx command of Matlab.
//   Plot the function value during an optimization process.
// Arguments, input
//   x : the current point
//   optimValues : a tlist which contains the following fields
//     funcCount" : the number of function evaluations
//     fval : the current function value
//     iteration : the current iteration
//     procedure : a string containing the current type of step
//  state : the current state of the algorithm
//    "init", "iter", "done"
// Notes:
//   The algorithm is the following.
//   At initialization of the algorithm, create an empty
//   graphic plot, retrieve the handle, and store a special
//   key "optimplotfx" in the user_data field of the handle.
//   When the plot is to update, this key is searched so that the
//   correct plot can be update (and not another).
//
function optimplotx ( x , optimValues , state )
    if ( state == "init" ) then
        // Initialize
        opfvh = scf();
        nbvar = size(x, '*')
        for i = 1:nbvar
            subplot(nbvar, 1, i);
            e = plot(0, x(i))
            e.tag = "optimplotx_"+string(i);
            e.line_style = 3;
            e.mark_mode = "on";
            e.mark_style = 0;
            e.mark_size = 10;
            e.mark_foreground = 2 + i;
            e.mark_background = 2 + i;
            e.foreground = 2 + i;
            e.parent.parent.x_label.text = "Iteration";
            e.parent.parent.y_label.text = "x(" + string(i) + ")";
        end
    else
        nbvar = length(x)
        for i = 1:nbvar
            e = get("optimplotx_"+string(i));
            e.data($+1,1:2) = [optimValues.iteration, x(i)]
            // Compute new bounds
            itermin = 0;
            itermax = optimValues.iteration;
            xmin = min(e.data(:,2));
            xmax = max(e.data(:,2));
            // Update bounds
            e.parent.parent.data_bounds = [
                itermin xmin
                itermax xmax
            ];
        end
    end
endfunction

