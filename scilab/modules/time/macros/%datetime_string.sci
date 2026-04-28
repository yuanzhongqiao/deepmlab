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

function out = %datetime_string(dt)
    s = dt.time;
    h = floor (s / 3600);
    s = s - 3600 * h;
    mi = floor (s / 60);
    s = s - 60 * mi;
    vv = datevec(dt.date);
    [n, col] = size(dt.date);
    dy = matrix(vv(:,1), size(dt.date));
    dm = matrix(vv(:,2), size(dt.date));
    dd = matrix(vv(:,3), size(dt.date));

    out = emptystr(n, col)

    if dt.format == [] then
        hasTime = or(dt.time <> 0);

        for c = 1:col
            d = dt.date(:, c);
            t = dt.time(:, c);
            hasMS = or(modulo(t, 1));

            test = d == -1;
            out(test, c) = sprintf("NaT\n");

            test = d == 0 & ~hasTime;
            out(test, c) = sprintf("NaT\n");

            test = d == 0 & hasTime & hasMS;
            if or(test) then
                out(test, c) = sprintf("%02d:%02d:%06.3f \n", h(test, c), mi(test, c), s(test, c));
            end

            test = d == 0 & hasTime & ~hasMS;
            if or(test) then
                out(test, c) = sprintf("%02d:%02d:%02d\n", h(test, c), mi(test, c), s(test, c));
            end

            test = d <> -1 & d <> 0 & ~hasTime;
            if or(test) then
                out(test, c) = sprintf("%04d-%02d-%02d\n", dy(test, c), dm(test, c), dd(test, c));
            end

            test = d <> -1 & d <> 0 & hasTime & ~hasMS;
            if or(test) then
                out(test, c) = sprintf("%04d-%02d-%02d %02d:%02d:%02d\n", dy(test, c), dm(test, c), dd(test, c), h(test, c), mi(test, c), s(test, c));
            end

            test = d <> -1 & d <> 0 & hasTime & hasMS
            if or(test) then
                out(test, c) = sprintf("%04d-%02d-%02d %02d:%02d:%06.3f\n", dy(test, c), dm(test, c), dd(test, c), h(test, c), mi(test, c), s(test, c));
            end
        end

            

        
        // for c = 1:size(dt.date, 2)
        //     hasMS = or(modulo(dt.time(:, c), 1));

        //     for r = 1:n
        //         d = dt.date(r, c);
        //         if d == -1 then
        //             out(r, c) = sprintf("NaT\n");
        //             continue;
        //         end

        //         if d == 0 then
        //             if dt.time(r,c) == 0 then
        //                 out(r, c) = "NaT";
        //             else
        //                 if hasMS then
        //                     out(r, c) = sprintf("%02d:%02d:%06.3f\n", h(r, c), mi(r, c), s(r, c));
        //                 else
        //                     out(r, c) = sprintf("%02d:%02d:%02d\n", h(r, c), mi(r, c), s(r, c));
        //                 end
        //             end
        //         else
        //             //v = datevec(d);
        //             v = vv(r + (c - 1) * n, :)
        //             if hasTime then
        //                 if hasMS then
        //                     out(r, c) = sprintf("%04d-%02d-%02d %02d:%02d:%06.3f\n", v(1), v(2), v(3), h(r, c), mi(r, c), s(r, c));
        //                 else
        //                     out(r, c) = sprintf("%04d-%02d-%02d %02d:%02d:%02d\n", v(1), v(2), v(3), h(r, c), mi(r, c), s(r, c));
        //                 end
        //             else
        //                 out(r, c) = sprintf("%04d-%02d-%02d\n", v(1), v(2), v(3));
        //             end
        //         end
        //     end
        // end
    else

        mount_list1 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]';
        mount_list2 = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]';

        outputFormat = dt.format;
        reg_list = list(...
            ["yyyy", "yy", "y"], ...
            ["MMMM", "MMM", "MM", "M"], ...
            ["dd", "d"], ...
            ["HH", "H"], ..
            ["mm"], ...
            ["ss.SSS", "ss"], ...
            ["[e]{4}" "[e]{3}"], ...
            ["hh:mm:ss a", "h:mm:ss a", "hh:mm a", "h:mm a"]);

        reg_replace = list(...
            ["%04d", "%02d", "%d"], ...
            ["%s", "%s", "%02d", "%d"], ...
            ["%02d", "%d"], ...
            ["%02d", "%d", "%02d", "%d"], ...
            ["%02d"], ...
            ["%06.3f", "%02d"], ...
            ["%s", "%s"], ...
            ["%s" "%s" "%s" "%s"]);

            //"%02d:%02d:%02d %s" "%d:%02d:%02d %s" "%02d:%02d %s" "%d:%02d %s"
        index = [];
        for l = 1:length(reg_list)
            idx = [];
            for i = 1:size(reg_list(l), "*")
                idx = strindex(outputFormat, "/" + reg_list(l)(i) + "/", "r");
                if idx <> [] then
                    break;
                end
            end

            if idx <> [] then
                index(l, :) = [l, i, idx];
            end
        end

        [_, order] = gsort(index(:, 3), "g", "i");
        index = index(order, :);
        idx_remove = index(:, 1) == 0;
        index(idx_remove, :) = [];
        order(idx_remove) = [];
        tmp = find(index(:,1) == 8);
        if tmp <> [] then
            index(tmp+1:$, :) = []
            order(tmp+1:$) = [];
        end
        
        // for i = 1:size(index, 1)
        //     if index(i, 3) <> -1 then
        //         outputFormat = strsubst(outputFormat, "/" + reg_list(index(i, 1))(index(i, 2)) + "/", reg_replace(index(i, 1))(index(i, 2)), "r");
        //     end
        // end

        fmt = "";
        for i = 1:size(index, 1)
            if index(i, 3) <> -1 then
                i1 = index(i,3);
                if i == size(index, 1) then
                    i2 = $;
                else
                    i2 = index(i+1,3)-1;
                end
                fmt = fmt + strsubst(part(outputFormat, i1:i2), "/" + reg_list(index(i, 1))(index(i, 2)) + "/", reg_replace(index(i, 1))(index(i, 2)), "r");
            end
        end
        outputFormat = fmt

        dy = matrix(vv(:,1), size(dt.date));
        dm = matrix(vv(:,2), size(dt.date));
        dd = matrix(vv(:,3), size(dt.date));

        for c = 1:size(dt.date, 2)
            d = dt.date(:, c);
            test = d == -1;
            out(test, c) = "NaT";

            w = d;
            w(test) = [];
            if w == [] then
                continue;
            end

            datetime_items = [dy(:,c), dm(:,c), dd(:,c), h(:,c), mi(:,c), s(:,c)];
            datetime_items(test, :) = [];

            args = list();
            for i = 1:length(order)
                if order(i) == 7 then ///e+
                    if index(i, 2) == 1 then //eeee
                        [_, args(i)] = weekday(w, "en_US", "long");
                    else // eee
                        [_, args(i)] = weekday(w, "en_US");
                    end
                elseif order(i) == 8 then //AM PM
                    hh = datetime_items(:, 4);
                    AMPM = "AM" + emptystr(hh);

                    idx = find(hh > 11);
                    if idx <> [] then
                        time = hh(idx);
                        jdx = find(time <> 12);
                        if jdx <> [] then
                            time(jdx) = time(jdx) - 12;
                        end
                        hh(idx) = time;
                        AMPM(idx) = "PM";
                    end

                    idx = find(hh == 0);
                    if idx <> [] then
                        hh(idx) = 12;
                    end

                    select index(i, 2)
                    case 1
                        args(i) = sprintf("%02d:%02d:%02d %s\n", hh, datetime_items(:, 5), datetime_items(:, 6), AMPM);
                    case 2
                        args(i) = sprintf("%d:%02d:%02d %s\n", hh, datetime_items(:, 5), datetime_items(:, 6), AMPM);
                    case 3
                        args(i) = sprintf("%02d:%02d %s\n", hh, datetime_items(:, 5), AMPM);
                    case 4
                        args(i) = sprintf("%d:%02d %s\n", hh, datetime_items(:, 5), AMPM);
                    end
                elseif order(i) == 2  && index(i, 2) == 1 then ///MMMM
                    args(i) = mount_list2(datetime_items(:, order(i)));
                elseif order(i) == 2  && index(i, 2) == 2 then //MMM
                    args(i) = mount_list1(datetime_items(:, order(i)));
                elseif order(i) == 1 && index(i, 2) == 2 then //yy
                    args(i) = modulo(datetime_items(:, order(i)), 100);
                else
                    args(i) = datetime_items(:, order(i));
                end

            end

            tmp = sprintf(outputFormat + "\n", args(:));
            out(d <> -1, c) = tmp;
        end
    end
endfunction
