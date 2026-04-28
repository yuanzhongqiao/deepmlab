// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function s=%h_outline(x,verbose)
    if isscalar(x)        
        if verbose == 0
            s = %type_dims_outline(x, typeStr=x.type);    
        else
            s = %type_dims_outline(x, typeStr=x.type)+" with properties:";
        end
    else
         s = %type_dims_outline(x);
    end
endfunction
