// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %props_p(p)
    fields = fieldnames(p)';
    len = max(length(fields)) + 3;
    for f = fields
        if f == "userdata" then
            continue;
        end

        field = convstr(part(f, 1), "u") + part(f, 2:$);
        if isempty(p(f)) then
            printf("%*s: %s\n", len, field, "[]");
        else
            if type(p(f)) == 10 then
                printf("%*s: %s\n", len, field, "[" + strcat("''" + string(p(f)) + "''", "  ") + "]");
            else
                printf("%*s: %s\n", len, field, string(p(f)));
            end
        end
    end
endfunction
