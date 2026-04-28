// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function %h_p(h)
    if size(h,"*")>1 then
        t="";
        T=matrix(h.type,size(h))
        for k=1:size(h,2)
            t=t+part(T(:,k),1:max(length(T(:,k)))+1)
        end
    else
        t = %l_string_inc(h);
    end
    if ~isempty(t) then
        printf("  %s\n",t)
    end
endfunction
