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

function [val, count, vindex, uniqueVal] = %_groupcounts(t, groupvars, groupbins, includeEmpty, includedEdge)
    sizeGroupbins = size(groupbins, "*")
    sizeGroupvars = size(groupvars, "*");
    val = list();
    count = 0;
    vindex = 0;
    uniqueVal = list();

    if sizeGroupvars == 1 then
        if type(groupbins) == 1 then
            // for example: groupbins = [0 3 6 9]
            minbounds = groupbins(1:$-1);
            maxbounds = groupbins(2:$);
            
            val = [minbounds' maxbounds'];

            d = t.vars(groupvars).data
            count = zeros(size(val, 1), 1);
            vindex = zeros(size(d, 1), 1);

            if includedEdge == "left" then
                for i = 1:size(val, 1)
                    index = %t;
                    if val(i,2) == max(val)
                        f = d >= val(i,1) & d <= val(i,2);
                    else
                        f = d >= val(i,1) & d < val(i,2);
                    end
                    index = index & f;
                    count(i) = sum(index);
                    vindex = vindex + index * i;
                end

                // transform val to print
                str = "[" + string(val(:,1))+ ", "+ string(val(:,2)) + ")";
                str($) = strsubst(str($), ")", "]");   
                val = str;

            else
                // includedEdge = "right"
                for i = 1:size(val, 1)
                    index = %t;
                    if val(i,1) == min(val)
                        f = d >= val(i,1) & d <= val(i,2);
                    else
                        f = d > val(i,1) & d <= val(i,2);
                    end
                    index = index & f;
                    count(i) = sum(index);
                    vindex = vindex + index * i;
                end

                // transform val to print
                str = "(" + string(val(:,1))+ ", "+ string(val(:,2)) + "]";
                str(1) = strsubst(str(1), "(", "[");   
                val = str;
            end

            if ~includeEmpty then
                idx = count == 0;
                val(idx) = [];
                count(idx) = [];
            end

            val = list(val);
        else
            if typeof(groupbins) == "ce" then
                groupbins = groupbins{1};
            end

            d = t.vars(groupvars).data;
            select typeof(groupbins)
            case "string"
                if groupbins == "none" then
                    [uniqueVal(1), km, vindex, count] = unique(d)
                else
                    // for example: groupbins = ["second", "minute", "hour", "day", "month", "year", "dayname", "monthname"])
                    [uniqueVal(1), vindex, count] = groupBinsCheck(groupbins, d, includeEmpty);
                    if includeEmpty then
                        nb = zeros(size(uniqueVal(1), "r"), 1);
                        nb(unique(vindex)) = count;
                        count = nb;
                    end
                end

                val = uniqueVal;
            case {"datetime", "calendarDuration", "duration"}
                [groupbins, rowtimes, dt] = groupTimeCheck(groupbins, d);
                if includedEdge == "left" then
                    if size(dt, "*") > 2 then
                        dt(2:$-1) = dt(2:$-1)-1d-5;
                    end
                    str = "[ " + string(groupbins(1:$-1))+ ", "+ string(groupbins(2:$)) + " )";
                    str($) = strsubst(str($), " )", " ]");   
                    val = str;
                else
                    str = "( " + string(groupbins(1:$-1))+ ", "+ string(groupbins(2:$)) + " ]";
                    str(1) = strsubst(str(1), "( ", "[ ");   
                    val = str;
                end   

                [i_bin, count] = dsearch(rowtimes, dt);

                if ~includeEmpty then
                    idx = count == 0;
                    val(idx) = [];
                    count(idx) = [];
                else
                    idx = find(count > 0, 1);
                    val(1:idx-1)= [];
                    count(1:idx-1) =[];
                end

                val = list(val);
                vindex = i_bin';
                uniqueVal = val;

            else
                error(msprintf(_("%s: Wrong value for input argument #%d: a double, string, datetime or duration expected.\n"), "groupcounts", 3));
            end
        end
    else

        // groupvars can be vector
        // groupbins will be applied on all groupvars
        if type(groupbins) == 1 then
            // for example: groupbins = [0 3 6 9]
            minbounds = groupbins(1:$-1);
            maxbounds = groupbins(2:$);
            mat = [minbounds' maxbounds'];

            s = size(mat, 1) * ones(sizeGroupvars, 1);
            p = prod(s);

            for i = 1:sizeGroupvars
                select i
                case 1
                    val(i) = gsort(repmat(mat, prod(s(i+1:$)), 1), "lr", "i");
                case sizeGroupvars
                    val(i) = repmat(mat, prod(s(1:sizeGroupvars-1)), 1);
                else
                    val(i) = repmat(gsort(repmat(mat, prod(s(i+1:$)), 1), "lr", "i"), prod(s(1:i-1)), 1);
                end
            end

            count = zeros(size(mat, 1) * sizeGroupvars, 1);
            vindex = zeros(size(t, 1), 1);

            if includedEdge == "left" then
                for i = 1:p
                    index = %t;
                    for j = 1:sizeGroupvars
                        d = t.vars(groupvars(j)).data;
                        if val(j)(i,2) == max(val(j))
                            f = d >= val(j)(i,1) & d <= val(j)(i,2);
                        else
                            f = d >= val(j)(i,1) & d < val(j)(i,2);
                        end
                        index = index & f;
                    end
                    count(i) = sum(index);
                    vindex = vindex + index * i;
                end

                // transform val to print
                l = list();
                for i = 1:sizeGroupvars
                    v = val(i);
                    a = [];
                    for j = 1:p
                        if val(i)(j,2) == max(val(i))
                            str = "]";
                        else
                            str = ")";
                        end
                        a = [a; "[" + string(v(j, 1)) + ", "+ string(v(j, 2)) + str];
                    end
                    l(i) = a
                    uniqueVal(i) = a(count <> 0)
                end
            else
                for i = 1:p
                    index = %t;
                    for j = 1:sizeGroupvars
                        d = t.vars(groupvars(j)).data;
                        if val(j)(i,1) == min(val(j))
                            f = d >= val(j)(i,1) & d <= val(j)(i,2);
                        else
                            f = d > val(j)(i,1) & d <= val(j)(i,2);
                        end
                        index = index & f;
                    end
                    count(i) = sum(index);
                    vindex = vindex + index * i;
                end

                // transform val to print
                l = list();
                for i = 1:sizeGroupvars
                    v = val(i);
                    a = [];
                    for j = 1:p
                        if val(i)(j,1) == min(val(i))
                            str = "[";
                        else
                            str = "(";
                        end
                        a = [a; str + string(v(j, 1)) + ", "+ string(v(j, 2)) + "]"];
                    end
                    l(i) = a
                    uniqueVal(i) = a(count <> 0)
                end
            end

            val = l;    

            if ~includeEmpty then
                idx = count == 0;
                for i = 1:sizeGroupvars
                    val(i)(idx) = [];
                end
                count(idx) = [];
            end

        elseif or(typeof(groupbins) == ["datetime", "duration", "calendarDuration"]) then
            // a groupbins for all groupvars
            V = zeros(size(t, 1), sizeGroupvars);

            for i = 1:sizeGroupvars
                d = t.vars(groupvars(i)).data
                [u, rowtimes, dt] = groupTimeCheck(groupbins, d);

                if includedEdge == "left" then
                    if size(dt, "*") > 2 then
                        dt(2:$-1) = dt(2:$-1)-1d-5;
                    end
                    str = "[ " + string(u(1:$-1))+ ", "+ string(u(2:$)) + " )";
                    str($) = strsubst(str($), " )", " ]");   
                    val = str;
                else
                    str = "( " + string(u(1:$-1))+ ", "+ string(u(2:$)) + " ]";
                    str(1) = strsubst(str(1), "( ", "[ ");   
                    val = str;
                end   

                V(:,i) = dsearch(rowtimes, dt); 

                idx = find(V(:,i) == 0);
                if idx <> [] then
                    str = [str; "<undefined>"];
                    V(idx, i) = size(str, "*");
                end
                uniqueVal(i) = str;
            end

            [rV, km, vindex, nbV] = unique(V, "r");

            if includeEmpty then

                [val, vind] = %_combinations(uniqueVal);
                b = [];
                for i = 1:sizeGroupvars
                    v = [1:size(uniqueVal(i), "*")]';
                    b = [b, v(vind(i))]
                end

                count = zeros(size(b, 1), 1);
                [res, kmres, index, nbres] = unique([b; rV], "r");
                count(nbres == 2) = nbV;
            else
                count = nbV
                val = list();
                for i = 1:sizeGroupvars
                    val(i) = uniqueVal(i)(rV(:,i))
                end
            end
        else
            if sizeGroupbins == 1 then
                V = zeros(size(t, 1), sizeGroupvars);
                if groupbins == "none" || groupbins == {"none"} then
                    for i = 1:sizeGroupvars
                        d = t.vars(groupvars(i)).data
                        [uniqueVal(i), kmd, V(:,i), nb] = unique(d)
                    end
                else
                    // for example: groupbins = ["second", "minute", "hour", "day", "month", "year", "dayname", "monthname"])
                    for i = 1:sizeGroupvars
                        d = t.vars(groupvars(i)).data;
                        [uniqueVal(i), V(:, i), nb] = groupBinsCheck(groupbins, d, includeEmpty);
                    end
                end  
                    
                [rV, km, vindex, nbV] = unique(V, "r");

                if includeEmpty then
                    [val, vind] = %_combinations(uniqueVal);
                    b = [];
                    for i = 1:sizeGroupvars
                        v = [1:size(uniqueVal(i), "*")]';
                        b = [b, v(vind(i))]
                    end
                    count = zeros(size(b, 1), 1);
                    [res, kmres, index, nbres] = unique([b; rV], "r");
                    count(nbres == 2) = nbV;
                else
                    count = nbV
                    val = list();
                    for i = 1:sizeGroupvars
                        val(i) = uniqueVal(i)(rV(:,i))
                    end
                end

            else
                // matrix of groupbins (same type) or cell
                // groupbins has the same size as groupvars
                // one groupbins for one groupvars
                V = zeros(size(t, 1), sizeGroupbins);
                if type(groupbins) == 10 then
                    // possible cases: ["none", "month"], ["month", "year"], ["year", "none"]
                    for k = 1:sizeGroupbins
                        bins = groupbins(k)
                        d = t.vars(groupvars(k)).data;

                        if bins == "none" then
                            [uniqueVal(k), kmd, V(:, k), nb] = unique(d)
                        else
                            [uniqueVal(k), V(:, k), nb] = groupBinsCheck(bins, d, includeEmpty);
                        end
                    end

                elseif type(groupbins) == 17 then
                    // possible cases: {"none", "month"}, {"month", "year"}, {"year", "none"}
                    for k = 1:sizeGroupbins
                        bins = groupbins{k}
                        d = t.vars(groupvars(k)).data;
                        if type(bins) == 1 then
                            minbounds = bins(1:$-1);
                            maxbounds = bins(2:$);
                            
                            bins = [minbounds' maxbounds'];

                            if includedEdge == "left" then
                                str = "[" + string(bins(:,1))+ ", "+ string(bins(:,2)) + ")";
                                str($) = strsubst(str($), ")", "]");
                                mat = "<undefined>" + emptystr(d);

                                for i = 1:size(bins, 1)
                                    if i == size(bins, 1) then
                                        test = d>=bins(i,1) & d <= bins(i,2);
                                    else
                                        test = d>=bins(i,1) & d < bins(i,2);
                                    end
                                    mat(test) = str(i)
                                    V(:,k) = V(:,k) + test * i;
                                end
                            else
                                str = "(" + string(bins(:,1))+ ", "+ string(bins(:,2)) + "]";
                                str(1) = strsubst(str(1), "(", "[");
                                mat = "<undefined>" + emptystr(d);

                                for i = 1:size(bins, 1)
                                    if i == 1 then
                                        test = d >= bins(i,1) & d <= bins(i,2);
                                    else
                                        test = d > bins(i,1) & d <= bins(i,2);
                                    end
                                    mat(test) = str(i)
                                    V(:,k) = V(:,k) + test * i;
                                end
                            end

                            idx = find(mat == "<undefined>")
                            if idx <> [] then
                                str = [str; "<undefined>"];
                                V(idx,k) = size(str, "*");
                            end

                            uniqueVal(k) = str;

                        elseif or(typeof(bins) == ["datetime", "duration", "calendarDuration"]) then
                            [vecbins, rowtimes, dt] = groupTimeCheck(bins, d);
                            // dt(2:$) = dt(2:$)-1d-10;

                            if includedEdge == "left" then
                                if size(dt, "*") > 2 then
                                    dt(2:$-1) = dt(2:$-1)-1d-5;
                                end
                                str = "[ " + string(vecbins(1:$-1))+ ", "+ string(vecbins(2:$)) + " )";
                                str($) = strsubst(str($), " )", " ]");   
                                val = str;
                            else
                                str = "( " + string(vecbins(1:$-1))+ ", "+ string(vecbins(2:$)) + " ]";
                                str(1) = strsubst(str(1), "( ", "[ ");   
                                val = str;
                            end
            
                            V(:,k) = dsearch(rowtimes, dt); 
                            [tmp, km] = unique(V(:,k));

                            // str = "[ " + string(vecbins(1:$-1))+ ", "+ string(vecbins(2:$)) + " )";
                            // str($) = strsubst(str($), " )", " ]");

                            idx = find(V(:,k) == 0);
                            if idx <> [] then
                                str = [str; "<undefined>"];
                                V(idx, k) = size(str, "*");
                            end
                            uniqueVal(k) = str;
                        else
                            if bins == "none" then
                                [uniqueVal(k), kmd, V(:,k), nb] = unique(d)
                            else
                                [uniqueVal(k), V(:, k), nb] = groupBinsCheck(bins, d, includeEmpty);
                            end
                        end
                    end
                end

                [rV, km, vindex, nbV] = unique(V, "r");

                if includeEmpty then
                    [val, vind] = %_combinations(uniqueVal);
                    b = [];
                    for i = 1:sizeGroupvars
                        v = [1:size(uniqueVal(i), "*")]';
                        b = [b, v(vind(i))]
                    end
                    count = zeros(size(b, 1), 1);
                    [res, km, index, nbres] = unique([b; rV], "r", "keepOrder");
                    count(nbres == 2) = nbV;
                    
                else
                    val = list();
                    for k = 1:sizeGroupbins
                        val(k) = uniqueVal(k)(rV(:,k))
                    end
                    count = nbV
                end
            end
        end
    end
endfunction

function [u, vindex, count] = groupBinsCheck(bins, d, includeEmpty)
    select bins
    case "year"
        if isdatetime(d) then
            d = d.Year;
            c = 1;
        else
            d = years(floor(years(d)));
            c = years(1);
        end

    case "month"
        if isduration(d) then
            error(msprintf(_("groupbins must be used with datetime data.\n")));
        end

        d.date = d.date - d.Day + 1;
        d.time = zeros(d.time);
        d.format = "MMM-yyyy";
        c = calmonths(1);

    case "monthname"
        if isduration(d) then
            error(msprintf(_("groupbins must be used with datetime data.\n")));
        end

        d.Year = ones(d.Year);
        d.date = d.date - d.Day + 1;
        d.time = zeros(d.time);
        d.format = "MMMM";
        d = string(d);
        g = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]';
        [nb, d] = members(d, g);

    case "day"
        if isdatetime(d) then
            d.time = zeros(d.time);
            c = caldays(1);
        else
            d = days(floor(days(d)));
            c = days(1);
        end

    case "dayname"
        if isduration(d) then
            error(msprintf(_("groupbins must be used with datetime data.\n")));
        end

        d.format = "eeee";
        d = string(d);
        g = ["Sunday"; "Monday"; "Tuesday"; "Wednesday"; "Thursday"; "Friday"; "Saturday"];
        [nb, d] = members(d, g);

    case "hour"
        if isdatetime(d) then
            d.time = d.time - d.Minute*60 - d.Second;
        else
            d = hours(floor(hours(d)));
        end

        c = hours(1);

    case "minute"
        if isdatetime(d) then
            d.time = d.time - d.Second;
        else
            d = minutes(floor(minutes(d)));
        end

        c = minutes(1);

    case "second"
        if isduration(d) then
            d = seconds(floor(seconds(d)));
        end

        c = seconds(1);
    end

    monthOrdayname = or(bins == ["monthname", "dayname"]);

    if ~monthOrdayname then
        b = gsort(d, 'g', 'i');
        g = (b(1):c:b($))';
    end

    [u, km, vindex, count] = unique(d)
    if includeEmpty then
        if isdatetime(d) then
            a = d.date * 24 * 60 *60 + d.time;
            b = g.date * 24 * 60 * 60 + g.time;
        elseif isduration(d) then
            a = d.duration;
            b = g.duration;
        else
            if monthOrdayname then
                a = g(d);
            else
                a = d;
            end
            b = g;
        end
        u = g;
        [nb, vindex] = members(a, b);
    else
        // only necessary for monthname and dayname
        if monthOrdayname then
            u = g(u);
        end
    end
endfunction

function [groupbins, rowtimes, dt] = groupTimeCheck(groupbins, d)
    
    sizeGroupbins = size(groupbins, "*");
    select typeof(groupbins)
    case "datetime"
        if sizeGroupbins == 1 then
            error(msprintf(_("%s: Wrong size for input argument #%d: a vector of datetime expected.\n"), "groupcounts", 3));
        end
        if isduration(d) then
            error(msprintf(_("%s: Wrong type for input argument #%d: a duration expected.\n"), "groupcounts", 3));
        end
        if size(groupbins, 1) == 1 then
            groupbins = groupbins';
        end

        rowtimes = d.date * 24*60*60 + d.time;
        dt = groupbins.date * 24*60*60 + groupbins.time;

    case "calendarDuration"
        if isduration(d) then
            error(msprintf(_("%s: Wrong type for input argument #%d: a duration expected.\n"), "groupcounts", 3));
        end
        if sizeGroupbins <> 1 then
            error(msprintf(_("%s: Wrong size for input argument #%d: a calendarDuration scalar expected.\n"), "groupcounts", 3));
        end
        
        dura = gsort(d, "g", "i");
        dStart = dura(1);
        dEnd = dura($);
        step = groupbins;

        dv = datevec(dStart.date);
        if step.y <> 0 then
            dv([2 3 4 5 6]) = [1 1 0 0 0];
            dStart.time = 0;
            dStart.date = datenum(dv);
        elseif step.m <> 0 then
            dv([2 3 4 5 6]) = [1 1 0 0 0];
            dStart.time = 0;
            dStart.date = datenum(dv);
        elseif step.d <> 0 then //into days
            dv([3 4 5 6]) = [1 0 0 0];
            dStart.time = 0;
            dStart.date = datenum(dv);
        elseif step.t >= hours(1) then
            dv([4 5 6]) = [0 0 0];
            dStart.time = 0;
            dStart.date = datenum(dv);
        elseif step.t >= minutes(1) then
            dv([5 6]) = [0 0];
            dStart.time = 0;
            dStart.date = datenum(dv);
        elseif step.t >= seconds(1) then
            dStart.time = floor(dStart.time);
        end

        if dEnd.time <> 0 then
            dEnd.time = 0;
        end

        groupbins = (dStart:step:dEnd)';
        if groupbins($) < dEnd then
            groupbins($+1) = groupbins($) + step;
        end

        rowtimes = d.date * 24*60*60 + d.time;
        dt = groupbins.date * 24*60*60 + groupbins.time;        

    case "duration"
        if sizeGroupbins == 1 then
            dura = gsort(d, "g", "i");
            dStart = dura(1);
            dEnd = dura($);

            step = groupbins;

            if isduration(d) then
                dStart.duration = 0;
            elseif isdatetime(d) then
                dStart.time = 0;
            end

            groupbins = (dStart:step:dEnd)';
            if groupbins($) < dEnd then
                groupbins($+1) = groupbins($) + step;
            end

            if isdatetime(d) then 
                rowtimes = d.date * 24*60*60 + d.time;
                dt = groupbins.date * 24*60*60 + groupbins.time;
            else
                rowtimes = d.duration;
                dt = groupbins.duration;
            end

        else
            if isdatetime(d) then
                error(msprintf(_("%s: Wrong size for input argument #%d: a duration scalar expected.\n"), "groupcounts", 3));
            end

            if size(groupbins, 1) == 1 then
                groupbins = groupbins';
            end

            rowtimes = d.duration;
            dt = groupbins.duration;
        end
    end
endfunction
