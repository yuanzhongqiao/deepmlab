// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = summary(t, statistics, datavars)
    arguments
        t {mustBeA(t, ["table", "timeseries"])}
        statistics {mustBeA(statistics, "string")} = "default"
        datavars {mustBeA(datavars, "string")} = "all"
    end

    // properties of table/timeseries
    props = t.props;
    descr = props.description;
    varnames = props.variableNames;
    vardescr = props.variableDescriptions;
    varunits = props.variableUnits;

    haveStatistics = %t;
    idx = find(statistics == "none");
    if or(idx <> []) then
        haveStatistics = %f;
    else
        idx = find(statistics == "allstats");
        if or(idx <> []) then
            statistics = ["NumMissing", "Min", "Median", "Max", "Q1", "Mean", "Q3", "Std", "Var", "Mode", "Range", "Sum", "NumUnique", "Nnz"];
        end

        idx = find(statistics == "default")
        if idx <> [] then
            fields = statistics(1:idx-1);
            fields = [fields, "NumMissing", "Min", "Median", "Max", "Mean", "Std"];
            fields = [fields, statistics(idx+1:$)];
            statistics = fields;
        end

        statistics = convstr(part(statistics, 1), "u") + part(statistics, 2:$);
    end

    if datavars <> "all" then
        nb = members(datavars, varnames);
        if or(nb == 0) then
            error(msprintf(_("%s: Wrong value for input argument #%d: no valid variable name %s.\n"), fname, sci2exp(datavars(nb ==0))));
        end
        varnames = datavars;
    end

    outSt = struct();
    start = 1;
    rownames = [];

    if istimeseries(t) then
        // manage rowtimes
        name = varnames(1);
        data = t.vars(1).data;
        typ = typeof(data);
        varSt = struct();
        varSt.Size = size(data);
        varSt.Type = typ;
        varSt.StartTime = props.startTime;
        varSt.SampleRate = props.sampleRate;
        varSt.TimeStep = props.timeStep;
        varSt = doubleSummary(varSt, data, statistics);
        outSt(name) = varSt;
        start = 2;
    end

    idxNumeric = [];
    idxBoolean = [];
    idxString = [];

    for i = start:size(varnames, "*")
        name = varnames(i);
        data = t.vars(i).data;
        typ = typeof(data);
        if typ == "constant" then
            typ = "double";
        end

        varSt = struct();
        varSt.Size = size(data);
        varSt.Type = typ;
        varSt.Description = vardescr(i);
        varSt.Units = varunits(i);

        if haveStatistics then
            // double
            select typ
            case {"double", "duration", "datetime", "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64"}
                varSt = doubleSummary(varSt, data, statistics)
                idxNumeric(1, $+1) = i;

            case "boolean"
                [u, k, l, nb] = unique(data);
                varSt.True = nb(u == %t);
                varSt.False = nb(u == %f);
                idxBoolean(1, $+1) = i;

            case "string"
                [u, k, l, nb] = unique(data);
                varSt.NumMissing = sum(data == "<undefined>");
                varSt.Values = u;
                varSt.Counts = nb;
                idxString(1, $+1) = i;
            end
        end

        outSt(name) = varSt;
    end

    if nargout == 0 then
        // display summary
        // type and size
        str = typeof(t);
        out = [""; " " + str + ": " + %type_dims_outline(t, typeStr=str, forceDims=%t); ""];

        // display Description
        if descr <> "" then
            out = [out; " Description: " + descr; ""];
        end

        if str == "timeseries" then
            // istimeseries - row times
            out = [out; " RowTimes:"]
            name = varnames(1);
            varSt = outSt(name);
            out = [out; "    " + name + ": "+ varSt.Type];
            fields = fieldnames(varSt)';
            idx =  members(fields, ["Size", "Type"]);
            fields(idx == 1) = [];

            for f = fields
                out = [out; "        "+f+": " + string(varSt(f))];              
            end

            out = [out; ""];
        end

        // display Variables
        out = [out; " Variables:"]

        for i = start:size(varnames, "*")
            name = varnames(i);
            varSt = outSt(name);
            out = [out; "     " + name + ": " + varSt.Type];
            if ~isempty(varSt.Description) then
                out = [out; "        Description: " + varSt.Description];
            end
            if ~isempty(varSt.Units) then
                out = [out; "        Units: " + varSt.Units];
            end

        end

        // display Statistics
        out = strcat(out, "", "c");
        mprintf("%s\n", out);

        if haveStatistics then
            l = lines();
            lines(0,0)

            ll = list(idxNumeric, idxBoolean, idxString);
            sections = [" Statistics for numeric data:", " Statistics for booleans:", " Statistics for strings:"];
            fields = list(statistics, ["True", "False"], ["Values", "Counts"]);

            for i = 1:size(ll)
                index = ll(i);
                if ~isempty(index) then
                    mprintf("\n");
                    mprintf("%s\n", sections(i));

                    stat = fields(i);
                    mat = emptystr(size(stat, "*"), length(index));
                    
                    jdx = 1;
                    for idx = index
                        name = varnames(idx);
                        varSt = outSt(name);
                        typ = varSt.Type;
                        f = fieldnames(varSt)';
                        m =  members(f, ["Size", "Type", "Description", "Units"]);
                        f(m == 1) = [];
                        if typ == "string" then
                            for j = f
                                mat(stat == j, jdx) = sci2exp(varSt(j));
                            end
                        else
                            for j = f
                                mat(stat == j, jdx) = string(varSt(j));
                            end
                        end
                        jdx = jdx + 1;
                    end

                    tt = matrix2table(mat, "RowNames", stat, "VariableNames", varnames(index));
                    %table_p(tt)
                end
            end

            lines(l(2), l(1));
        end
    else 
        varargout(1) = outSt;
    end

endfunction

function [st, newfields] = doubleSummary(st, data, fields)

    if isdatetime(data) then
        val = data.date * 24 * 60 *60 + data.time;
    end

    for f = fields
        try
            select f
            case {"NumMissing", "NumUnique"}
                if isdatetime(data) then
                    r = sum(isnat(data));
                else
                    r = sum(isnan(data));
                end
                if f == "NumUnique" then
                    r = length(data) - r;
                end
            case "Min"
                if isdatetime(data) then
                    [_, idx] = min(val);
                    r = data(idx);
                else
                    r = min(data);
                end
            case "Max"
                if isdatetime(data) then
                    [_, idx] = max(val);
                    r = data(idx);
                else
                    r = max(data);
                end
            case "Median"
                if isduration(data) then 
                    r = milliseconds(nanmedian(data.duration));
                elseif isdatetime(data) then
                    r = data;
                    m = nanmedian(val);
                    r.date = floor(m / (24*60*60));
                    r.time = modulo(m, 24*60*60);
                elseif type(data) == 1 then
                    r = nanmedian(data);
                else
                    r = median(data);
                end
            case "Mean"
                if isduration(data) then 
                    r = milliseconds(nanmean(data.duration));
                elseif isdatetime(data) then
                    r = data;
                    m = nanmean(val);
                    r.date = floor(m / (24*60*60));
                    r.time = modulo(m, 24*60*60);
                else
                    r = nanmean(data);
                end
            case "Std"
                if isduration(data) then 
                    r = milliseconds(nanstdev(data.duration));
                elseif isdatetime(data) then
                    r = duration(0, 0, nanstdev(val));
                else
                    r = nanstdev(data);
                end
            case {"Q1", "Q3"}
                if f == "Q1" then
                    y = 25;
                else
                    y = 75;
                end
                // percentile
                if isduration(data) then 
                    r = milliseconds(perctl(data.duration, y)(1));
                elseif isdatetime(data) then
                    r = data;
                    m = perctl(val, y)(1);
                    r.date = floor(m / (24*60*60));
                    r.time = modulo(m, 24*60*60);
                else
                    r = perctl(data, y)(1);
                end
            case "Var"
                tmp = doubleSummary(st, data, "std");
                r = tmp.Std .^2;
            case "Mode"
                [x, _, _, nb] = unique(data);
                val = max(nb);
                r = x(find(nb == val))(1);
                if r == [] then
                    r = %nan;
                end
            case "Range"
                r = strange(data, "r");
            case "Sum"
                r = sum(data);
            case "Nnz"
                if isduration(data) then
                    r = data.duration <> 0;
                else
                    r = data <> 0;
                end
                r = sum(r & ~isnan(data));
            end
            st(f) = r;
        catch
            lasterror();
        end
    end
endfunction