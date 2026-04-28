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

function %table_p(t)

    if t.vars == [] then
        return;
    end

    res = [];
    current_len = 0;
    col_s = 1
    l = lines();
    // l == [10 0] => potentially lines(0,0)
    nbcolsdefault = 10;    
    
    if l(1) > nbcolsdefault & l(2) == 0 then
        // display max 50 rows of t. 
        // if the number of rows is greater than 50, 
        // displays the first three lines of t and the last three separated by ...
        l(2) = 50;
    end

    nb_rows = size(t, 1);
    rowNames = t.props.rowNames;
    variableNames = t.props.variableNames;
    if rowNames <> [] then
        variableNames = ["" variableNames];
    end
    
    if l(2) <> 0 & nb_rows > 6 & nb_rows > l(2) then
        output = [rowNames([1:3, nb_rows-2:nb_rows], 1) string(t([1:3, nb_rows-2:nb_rows], :))];
    else
        output = [rowNames string(t)];
    end

    for c = 1:size(variableNames, 2)
        name = variableNames(c);
        len = length(name);
        max_len = max(length(output(: , c)));
        max_len = max(max_len, len, 3);

        current_len = current_len + max_len + 3;
        if l(1) > nbcolsdefault & current_len >= l(1) then
            if c == 1 then
                l(1) == nbcolsdefault
            else
                printf("         column %d to %d\n", col_s, c - 1);
                if mode() > 1
                    printf("\n");
                end
                res = strcat(res, "", "c");
                mprintf("%s\n", res);
                if mode() > 1
                    printf("\n");
                end
                res = [];
                col_s = c;
                current_len = max_len + 3;
            end
        end
    
        shift = floor((max_len - len) / 2);
        right = sprintf("%%%ds", len + shift);
        left = sprintf("%%-%ds", max_len);
        header = sprintf(left, sprintf(right, name));

        if c == 1 && name == "" then
            separator = strcat([""](ones(1, max_len)))
            f = sprintf("   %%%ds\\n", max_len);
        else
            separator = strcat(["_"](ones(1, max_len)));
            f = sprintf("   %%-%ds\\n", max_len);
        end

        if l(2) <> 0 && nb_rows > 6 && nb_rows > l(2) then
            left = floor((max_len-3)/2);
            subres = sprintf(f, [header ; separator ; "" ; output(1:3, c)]);
            subres($+1) = "   " + sprintf("%*s", -max_len, sprintf("%*s", left+3, "..."));
            subres = [subres;sprintf(f, output($-2:$, c))];
            res = [res subres];
        else
            res = [res sprintf(f, [header ; separator ; "" ; output(:, c)])];
        end
    end

    if l(1) > nbcolsdefault & col_s <> 1 then
        printf("         column %d to %d\n", col_s, c);
        if mode() > 1
            mprintf("\n");
        end
    end    

    res = strcat(res, "", "c");
    mprintf("%s\n", res);

endfunction
