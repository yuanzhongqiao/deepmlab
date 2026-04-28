// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function %diagram_p(scs_m)
    t =  %l_string_inc(scs_m);
    i = grep(t,"objs:");
    j = grep(t,"version =");
    i_blocks = grep(t(i+1:j-1),"Block");
    t = [t(1:i); t(i+1:j-1)(i_blocks); t(j:$)];
    mprintf("  %s\n",t);
endfunction


