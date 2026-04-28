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

function out = %_rowvarfun(fname, t, groupingVariables, opts, varargin)

    includeEmpty = opts.includeEmpty;
    method = opts.method;
    nameMethod = opts.nameMethod;

    if or(fieldnames(opts) == "includedEdge") then
        includedEdge = opts.includedEdge;
    else
        includedEdge = "left";
    end

    out = [];
    isT = istimeseries(t);
    varnames = t.props.variableNames;
    previousname = "";

    // check groupingVariables
    select type(groupingVariables)
    case 1
        if groupingVariables > size(t, 2) then
            error(msprintf(_("%s: Wrong value.\n"), fname));
        end

        jdx = 1:size(t, 2);
        jdx(groupingVariables) = [];
    case 10
        [a, index] = members(groupingVariables, varnames);
        if or(index == 0) then
            error(msprintf(_("%s: ""%s"" is not a table variable name.\n"), fname, groupingVariables(index == 0)));
        end

        kdx = [];
        v = unique(varnames, "keepOrder");
        g = unique(groupingVariables);
        for i = 1:size(v, "*")
            if find(v(i) == g) then
                kdx = [kdx, i]
            end
        end
        groupingVariables = index;
        jdx = 1:size(varnames, "*");
        jdx(kdx) = [];
    end

    if nargin > 4 then
        // check groupbins
        groupbins = varargin(1);
        defaultGroupbins = ["none","second", "minute", "hour", "day", "month", "year", "dayname", "monthname"];
        previousname = emptystr(1, size(groupbins, "*"));

        if typeof(groupbins) == "constant" then
            previousname = "disc_";

        elseif typeof(groupbins) == "string" then
            [tmp, idx] = members(groupbins, defaultGroupbins);
            if idx(idx <> 1) <> [] then
                previousname(idx <> 1) = defaultGroupbins(idx(idx <> 1)) + "_";
            end

        elseif typeof(groupbins) == "ce" then
            for k = 1:size(groupbins, "*")
                bins = groupbins{k};
                if typeof(bins) == "constant" then
                    previousname(k) = "disc_"
                elseif typeof(bins) == "string" then
                    if bins <> "none" then
                        previousname(k) = bins + "_";
                    end
                end
            end
        end
    else
        groupbins = "none";
        previousname = "";
    end
    
    [uniqueGroupvars, ki2] = unique(groupingVariables, "keepOrder");
    if typeof(groupbins) <> "ce" then
        [uniqueGroupbins, ki1] = unique(groupbins, "keepOrder");
        
    else
        uniqueGroupbins = {};
        ki1 = [];
        tmp = groupbins;

        while tmp <> {}
            val = tmp{1};
            for k = 1:size(groupbins, "*")
                if find(val == groupbins{k}) then
                    ki1 = [ki1, k];
                    break;
                end
            end

            jjdx = 1;
            for j = 2:size(tmp, "*")
                if find(val == tmp{j}) then
                    jjdx = [jjdx j];
                end
            end
            tmp(jjdx) = [];
            uniqueGroupbins{1,$+1} = val;
        end
    end

    if size(uniqueGroupbins) == size(uniqueGroupvars) & and(ki1 == ki2) then
        groupbins = uniqueGroupbins;
        groupingVariables = uniqueGroupvars;
        previousname = previousname(ki1);
    end

    [val, count, vindex] = %_groupcounts(t, groupingVariables, groupbins, includeEmpty, includedEdge)

    newval = list();
    newcount = [];
    for i = 1:size(val)
        newval(i) = [];
    end

    if fname == "varfun" then
        results = list();
        [B,k] = gsort(vindex, "g", "i");
        km = find([1; B(2:$) - B(1:$-1)] <> 0)';
        dif = km(2:$) - km(1:$-1);
        dif($+1) = length(k) - km($) + 1;
        c = [km, km + dif - 1];
        tmp = list();
        lenkm = length(km);

        for m = 1:size(method)
            func = method(m);
            for j = 1:length(jdx)
                data = t.vars(jdx(j)).data;
                data = data(k);                

                if lenkm == length(data) && type(data) == 1 then
                    mat = zeros(count);
                    for i = 1:lenkm
                        mat(i) = func(data(i));
                    end
                else
                    if or(type(data) == [1, 4, 8, 10]) then
                        mat = zeros(count);
                        res = zeros(lenkm, 1)
                        for i = 1:lenkm
                            d = data(c(i, 1):c(i, 2));
                            r = func(d);
                            if length(r) == 1 then
                                res(i) = r;
                            else
                               error(msprintf(_("%s: Method must return a scalar result.\n"), fname));
                            end
                        end
                    elseif isdatetime(data) then
                        mat = NaT(count)
                        res = NaT(lenkm, 1);
                        for i = 1:lenkm
                            d = data(c(i,1):c(i,2));
                            
                            newdt = d(1);
                            newdt.date = func(d.date);
                            newdt.time = (newdt.date - int(newdt.date))*(24*60*60) + newdt.time;
                            if length(newdt) == 1 then
                                res(i) = newdt;
                            else
                                error(msprintf(_("%s: Method must return a scalar result.\n"), fname));
                            end
                        end
                    elseif isduration(data) then
                        mat = duration(zeros(count),0,0);
                        res = duration(zeros(lenkm, 1), 0, 0);
                        for i = 1:lenkm
                            d = data(c(i,1):c(i,2));
                            
                            newdt = d(1);
                            newdt.duration = func(d.duration);
                            if length(newdt) == 1 then
                                res(i) = newdt;
                            else
                                error(msprintf(_("%s: Method must return a scalar result.\n"), fname));
                            end
                        end
                    else
                        errargs = sci2exp(["double", "boolean", "int", "datetime", "duration", "string"]);
                        error(msprintf(_("%s: Wrong type for variable %s: Must be in %s.\n"), fname, t.props.variableNames(jdx), errargs));
                    end

                    mat(count <> 0) = res;
                end
                tmp(j) = mat;
            end

            if size(tmp(1), "*") < length(count) then

                idx = find(count <> 0);
                for k = 1:size(tmp)
                    r = tmp(k);
                    a = zeros(count);
                    a(idx) = r;
                    results(k) = a;
                end
            else
                results = tmp;
            end

            if size(method) == 1 then
                if isT then
                    names = [varnames(jdx == 1), nameMethod + "_" + varnames(jdx((jdx-1) <> 0))];
                else
                    names = nameMethod + "_" + varnames(jdx);
                end
            else
                if nameMethod(m) == "fun" then
                    nameMethod(m) = nameMethod(m) + string(m);
                end
                if isT then
                    names = [varnames(jdx == 1), nameMethod(m) + "_" + varnames(jdx((jdx-1) <> 0))];
                else
                    names = nameMethod(m) + "_" + varnames(jdx);
                end
            end

            if m == 1 then
                out = table(val(:), count, results(:), "VariableNames", [previousname + varnames(groupingVariables) "GroupCount", names]);
            else
                out = [out, table(results(:), "VariableNames", names)];
            end
        end

        if isT then
            out = table2timeseries(out);
        end

    elseif fname == "rowfun" then
        outputVariable = opts.outputVariable;
        nb = opts.nb;

        if isT && and(groupingVariables <> 1) then
            jdx(jdx == 1) = []
            dt = t.vars(1).data;
        end

        for m = 1:size(method)
            res = list();
            func = method(m)
            for i = 1:nb
                execstr("tmp"+string(i) +" = []");
            end
            
            for i = 1:max(vindex)
                index = find(vindex == i);
                l = list();
                for j = 1:length(jdx)
                    l(j) = t.vars(jdx(j)).data(index);
                end
                
                execstr("[" + strcat("a" + string(1:nb)', ",") +"] = func(l(:))");
                for k = 1:nb
                    execstr("tmp"+string(k) +" = [tmp" + string(k) + "; a" + string(k)+ "]");
                end
                if m == 1 then
                    [ma1, na1] = size(a1);
                    o = ones(ma1, na1);
                    for k = 1:size(val)
                        newval(k) = [newval(k); val(k)(i)(o)];
                    end
                    newcount = [newcount; count(i)(o)]
                end
            end

            if m == 1 then
                out = table(newval(:), newcount, "VariableNames", [varnames(groupingVariables) "GroupCount"])
            end

            for i = 1:nb
                execstr("res(" + string(i) + ") = tmp"+ string(i));
            end

            if size(method) > 1 then
                if nameMethod(m) == "fun" then
                    nameMethod(m) = nameMethod(m) + string(m);
                end
                names = nameMethod(m) + "_" + outputVariable;
            else
                if nameMethod == "" then
                    names = outputVariable;
                else
                    names = nameMethod + "_" + outputVariable;
                end
            end

            out = [out table(res(:), "VariableNames", names)];

        end
    
        if isT then
            if dt <> [] then
                out = table2timeseries(out, "RowTimes", dt, "VariableNames", [varnames(1), out.props.variableNames])
            else
                out = table2timeseries(out);
            end
        end
    end
endfunction
