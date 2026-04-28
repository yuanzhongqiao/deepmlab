//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020-2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//

function %_spCompJacobian_p(spch)
    str = %l_string_inc(spch)
    if ~isempty(str)
        mprintf("  %s\n", str);
    end
endfunction
