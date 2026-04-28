// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function str = %ce_string(ce)
    if size(ce, "*") == 0 then
        str = "{}";
    else
        str = emptystr(ce);
        for i = 1:size(ce, "*")
            val = ce{i};
            t = type(ce{i})
            select t
            case {1,2,4,5,6,8,10}
                //native arrayOf types wich can be displayed by sci2exp()
                if isempty(val)
                    str(i) = "[]";
                else
                    s = size(val);
                    if length(s) == 2 & s(1) == 1
                        x = sci2exp(val);
                        if size(x, "*") == 1 && length(x) <= 15 then
                            str(i) = x;
                        end
                    end
                    if str(i) == ""
                        [otype, onames] = typename();
                        str(i) = evstr("%"+onames(otype==type(val))+"_outline(val,0)");
                    end
                 end
            case 9
                str(i) = %h_outline(ce{i},0);                 
            case 15
                str(i) = %l_outline(ce{i},0);                 
            else
                [str(i),err] = evstr("%"+typeof(val)+"_outline(ce{i},0)");
                if err <> 0
                    str(i) = typeof(ce{i});
                end
            end
        end
    end
    s = max(length(str), "r");

    for j = 1:size(str, 2)
        f = sprintf("%%%ds\n", -s(j));
        for i = 1:size(str, 1)
            str(i, j) = sprintf(f, str(i, j))
        end
    end
endfunction
