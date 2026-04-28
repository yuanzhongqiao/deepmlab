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

function %calendarDuration_p(dura)
    if dura.y == [] then
        return;
    end

    res = [];
    current_len = 0;
    col_s = 1;
    nbcolsdefault = 10;
    l = lines();

    if l(1) > nbcolsdefault & l(2) == 0 then
        // display max 50 rows of dura. 
        // if the number of rows is greater than 50, 
        // displays the first three lines of dura and the last three separated by ...
        l(2) = 50;
    end

    nb_rows = size(dura.y, 1);
    if l(2) <> 0 & and(nb_rows > [6, l(2)]) then
        output = string(dura([1:3, nb_rows-2:nb_rows], :));
    else
        output = string(dura);
    end

    for c = 1:size(dura.y, 2)
        max_len = max(length(output(: , c)));
        current_len = current_len + max_len + 3;
        if l(1) > nbcolsdefault & current_len >= l(1) then
            if c == 1 then
                l(1) == nbcolsdefault
            else
                printf("         column %d to %d\n\n", col_s, c - 1);

                res = strcat(res, "", "c");
                res = strcat(res, "\n");

                printf(res);
                printf("\n\n");

                if mode() > 1
                    printf("\n");
                end

                res = [];
                col_s = c;
                current_len = max_len + 3;
            end
        end

        f = sprintf("   %%%ds\\n", max_len);
        if l(2) <> 0 && and(nb_rows > [6, l(2)]) then
            left = floor((max_len-3)/2);
            subres = sprintf(f, output(1:3, c));
            subres($+1) = "   " + sprintf("%*s", -max_len, sprintf("%*s", left+3, "..."));
            subres = [subres;sprintf(f, output($-2:$, c))];
            res = [res subres];
        else
            res = [res sprintf(f, output(:, c))];
        end
    end

    if l(1) > nbcolsdefault & col_s <> 1 then
        printf("         column %d to %d\n", col_s, c);
        if mode() > 1
            mprintf("\n");
        end
    end 

    res = strcat(res, "", "c");
    res = strcat(res, "\n");

    printf(res);
    printf("\n");
endfunction
