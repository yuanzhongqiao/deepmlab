// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function uiimport(action)

    fname = "uiimport";
    if nargin > 1 then
        error(msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), fname, 0, 1));
    end

    if isdef("action","l") then
        if type(action) <> 10 then
            error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), fname, 1));
        end

        select action
        case "selectfile"
            uiimport_cbselect();
            return
        case "variable"
            data = uiimport_variable();
            ans = resume(data);
            return
        case "function"
            uiimport_function();
            return
        case "help"
            doc("uiimport")
            return
        case "preview"
            uiimport_preview();
            return
        case "allselect"
            uiimport_allselect();
            return
        case "noneselect"
            uiimport_noneselect();
            return
        case "selectcolumn"
            uiimport_selectcolumn();
            return
        case "changename"
            uiimport_changecolname();
            return
        case "timevariable"
            uiimport_timevar();
            return
        case "timeref"
            uiimport_timeref();
            return
        case "convert"
            uiimport_convertto();
            return
        case "inputformat"
            uiimport_updateinputformat();
            return
        case "outputformat"
            uiimport_updateoutputformat();
            return
        case "resetinput"
            uiimport_resetinputformat();
            return
        case "resetoutput"
            uiimport_resetoutputformat();
            return
        case "customdelimiter"
            uiimport_custom_delimiter();
            return
        case "customheader"
            uiimport_custom_header();
            return
        else
            if ~isfile(action) then
                error(msprintf(_("%s: Wrong value for input argument #%d: A filename expected.\n"), fname, 1));
            end

            if and(fileext(action) <> [".csv" ".txt"]) then
                error(msprintf(_("%s: Wrong file type: csv or txt file expected.\n"), fname));
            end

            win = get("uiimport");
            if ~isempty(win) then
                //set visible
                set(win, "visible", "on");
                m = messagebox(["The file import will erase previous data."; "Do you want to continue ?"], "Warning", "warning", ["Yes", "No"], "modal");
                if m == 1 then
                    close(win);
                else
                    return;
                end
            end

            data = struct("path", action, "opts", [], "numheaderlines", []);
        end
    else
        win = get("uiimport");
        if ~isempty(win) then
            //set visible
            set(win, "visible", "on");
            return;
        end

        data = struct("path", "", "opts", [], "numheaderlines", []);
    end

    
    uiimport_gui(data);
endfunction

// -----------------------------------------------------------------------------
function uiimport_gui(data)

    w = 1100; //800;
    h = 675; //640; //600;

    fig = figure(...
        "figure_name", _("Import data"), ...
        "dockable", "off", ...
        "axes_size", [w h], ...
        "infobar_visible", "off", ...
        "toolbar_visible", "off", ...
        "menubar_visible", "off", ...
        "default_axes", "off", ...
        "background", -2, ...
        "resize", "off", ...
        "layout", "border", ...
        "tag", "uiimport", ...
        "userdata", data, ...
        "icon", "text-csv", ...
        "visible", "off");

    l = uicontrol(fig, ...
        "style", "frame", ...
        "tag", "uiimport_var", ...
        "border", createBorder("matte", 0, 0, 0, 2, "#dddddd"), ...
        "backgroundcolor", [1 1 1], ...
        "constraints", createConstraints("border", "left", [260 0]));

    outer = uicontrol(fig, ...
        "style", "frame", ...
        "border", createBorder("line", "#dddddd"), ...
        "constraints", createConstraints("border", "bottom", [0 5]));

    uicontrol(outer, ...
        "style", "frame", ...
        "backgroundcolor", [0 120 215]./255, ...
        "tag", "uiimport_progressbar", ...
        "position", [0 0 0 5]);

    c = uicontrol(fig, ...
        "style", "frame", ...
        "layout", "border", ...
        "backgroundcolor", [1 1 1], ...
        "constraints", createConstraints("border", "center"));

    uicontrol(c, ...
        "style", "frame", ...
        "tag", "uiimport_preview", ...
        "backgroundcolor", [1 1 1], ...
        "scrollable", "on", ...
        "layout", "gridbag", ...
        "constraints", createConstraints("border", "center"));

    y = h - 35; //605;
    x = 5;
    ad = 35;
    uicontrol(l, ...
        "style", "pushbutton", ...
        "tag", "uiimport_selectfile", ...
        "tooltipstring", _("Select a file"), ...
        "icon", "document-open", ...
        "relief", "flat", ...
        "backgroundcolor", [1 1 1], ...
        "callback", "uiimport(""selectfile"")", ...
        "position", [x y 25 25]);

    x = x + ad;
    // "variable-new", ...
    uicontrol(l, ...
        "style", "pushbutton", ...
        "tooltipstring", _("Import as variable"), ...
        "icon", "media-playback-start", ...
        "relief", "flat", ...
        "callback", "uiimport(""variable"")", ...
        "enable", "off", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_btnvariable", ...
        "position", [x y 25 25]);

    x = x + ad;
    // edit-copy
    uicontrol(l, ...
        "style", "pushbutton", ...
        "tooltipstring", _("Create a function"), ...
        "icon", "accessories-text-editor", ...
        "relief", "flat", ...
        "callback", "uiimport(""function"")", ...
        "enable", "off", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_btnfunction", ...
        "position", [x y 25 25]);

    x = x + ad;
    uicontrol(l, ...
        "style", "pushbutton", ...
        "tag", "uiimport_help", ...
        "tooltipstring", _("Help"), ...
        "icon", "help-browser", ...
        "relief", "flat", ...
        "backgroundcolor", [1 1 1], ...
        "callback", "uiimport(""help"")", ...
        "position", [x y 25 25]);

    y = y - 5
    uicontrol(l, ...
        "style", "frame", ...
        "position", [0 y 260 2], ...
        "border", createBorder("matte", 0, 0, 2, 0, "#dddddd"));

    y = y - 32;
    uicontrol(l, ...
        "style", "text", ...
        "string", _("File information"), ...
        "fontweight", "bold", ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 y 250 27]);

    y = y - 20;
    uicontrol(l, ...
        "style", "text", ...
        "string", "Number of Rows", ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 y 135 22]);

    uicontrol(l, ...
        "style", "text", ...
        "string", "", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_nbrows", ...
        "position", [152 y 100 22]);

    y = y - 22;
    uicontrol(l, ...
        "style", "text", ...
        "string", "Number of Columns", ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 y 135 22]);

    uicontrol(l, ...
        "style", "text", ...
        "string", "", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_nbcols", ...
        "position", [152 y 100 22]);

    y = y -22;
    uicontrol(l, ...
        "style", "text", ...
        "string", "Header size", ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 y 135 22]);

    uicontrol(l, ...
        "style", "edit", ...
        "string", "", ...
        "tag", "uiimport_nbheader", ...
        "callback", "uiimport(""customheader"")", ...
        "position", [150 y 60 22]);

    uicontrol(l, ...
        "style", "text", ...
        "string", "lines", ...
        "backgroundcolor", [1 1 1], ...
        "position", [218 y 40 22]);

    y = y - 26;
    uicontrol(l, ...
        "style", "text", ...
        "string", _("Delimiter"), ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 y 135 25]);

    uicontrol(l, ...
        "style", "popupmenu", ...
        "string", [_("Comma"), _("Space"), _("Tab"), _("Semicolon"), _("Pipe"), _("Colon"), _("Custom")], ...
        "userdata", [",", " ", ascii(9), ";", "|", ":", ""], ...
        "value", 1, ...
        "tag", "uiimport_delim", ...
        "callback", "uiimport(""preview"")", ...
        "backgroundcolor", [1 1 1], ...
        "position", [150 y 105 22]);

    y = y - 25;
    fr_custom_delim = uicontrol(l, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_fr_custom_delim", ...
        "visible", "off", ...
        "position", [0 y 255 25]);

    uicontrol(fr_custom_delim, ...
        "style", "text", ...
        "string", _("Symbol"), ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 0 135 25]);

    uicontrol(fr_custom_delim, ...
        "style", "edit", ...
        "string", "", ...
        "tag", "uiimport_custom_delim", ...
        "callback", "uiimport(""customdelimiter"")", ...
        "position", [150 0 105 22]);

    //y = y - 25;
    fr_decim = uicontrol(l, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_fr_decim", ...
        "position", [0 y 255 25]);

    uicontrol(fr_decim, ...
        "style", "text", ...
        "string", _("Decimal"), ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 0 135 25]);

    uicontrol(fr_decim, ...
        "style", "popupmenu", ...
        "string", [_("Point"), _("Comma")], ...
        "userdata", [".", ","], ...
        "value", 1, ...
        "tag", "uiimport_decim", ...
        "callback", "uiimport(""preview"")", ...
        "backgroundcolor", [1 1 1], ...
        "position", [150 0 105 22]);

    y = y - 10;
    ll = uicontrol(l, ...
        "style", "frame", ...
        "layout", "border", ...
        "tag", "uiimport_frimport", ...
        "backgroundcolor", [1 1 1], ...
        "visible", "off", ...
        "position", [2 0 255 y]);

    ftop = uicontrol(ll, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "constraints", createConstraints("border", "top", [0 30]));

    uicontrol(ftop, ...
        "style", "text", ...
        "string", _("Import Columns"), ...
        "fontweight", "bold", ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 2 170 28]);

    uicontrol(ftop, ...
        "style", "pushbutton", ...
        "icon", "select_all", ...
        "tooltipstring", "Select all", ...
        "backgroundcolor", [1 1 1], ...
        "callback", "uiimport(""allselect"")", ...
        "relief", "flat", ....
        "position", [200 2 25 25]);
    
    uicontrol(ftop, ...
        "style", "pushbutton", ...
        "icon", "deselect_all", ...
        "tooltipstring", "Select none", ...
        "backgroundcolor", [1 1 1], ...
        "callback", "uiimport(""noneselect"")", ...
        "relief", "flat", ....
        "position", [230 2 25 25]);

    fc = uicontrol(ll, ...
        "style", "frame", ...
        "layout", "gridbag", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_import", ...
        "constraints", createConstraints("border", "center"));

    sw = get(0,"screensize_px")(3);
    sh = get(0,"screensize_px")(4);

    s = fig.figure_size;
    w = (sw - s(1)) / 2
    h = (sh - s(2)) / 2
    fig.figure_position = [w h];

    if data.path == "" then
        fig.visible = "on";
        uiimport_cbselect();
    else
        set("uiimport", "figure_name", data.path);
        p = progressionbar("Import data ...");
        p.tag = "uiimport_progressionbar";
        uiimport_preview();
        fig.visible = "on";
        if is_handle_valid(p) then
            delete(p)
        end
    end
    
endfunction

// -----------------------------------------------------------------------------

function uiimport_progress(val)
    pos = get("uiimport_progressbar", "position");
    pos(3) = 1024 * val;
    set("uiimport_progressbar", "position", pos);
endfunction

// -----------------------------------------------------------------------------

function res = uiimport_variable()
    data = get("uiimport", "userdata");
    path = data.path;
    if isempty(path) || ~isfile(path) then
        return;
    end

    p = progressionbar("Import variable to workspace...");
    opts = data.opts;
    varNames = data.varnames(data.keepcols);
    varNamesRef = opts.variableNames(data.keepcols);
    convert = data.convert(data.keepcols);
    outputfmt = data.outputFormat(data.keepcols);
    variableTypes = opts.variableTypes(data.keepcols)

    if data.rowtimes == "No" then
        d = readtable(path, data.opts, "VariableNames", varNamesRef);
    else
        idx = find(data.rowtimes == varNames);
        if convert(idx) <> "" then
            convert_fcn = get("uiimport_convert", "userdata");
            jdx = find(convert(idx) == get("uiimport_convert", "string"));
            d = readtimeseries(path, data.opts, "VariableNames", varNamesRef, "RowTimes", varNamesRef(idx), "ConvertTime", convert_fcn(jdx));
            convert(idx) = "";
        else
            if variableTypes(idx) == "double" then
                m = messagebox("Unable to create a variable. You must choose the conversion method.", "Warning", "warning", "Ok", "modal");
                delete(p)
                return
            end
            d = readtimeseries(path, data.opts, "VariableNames", varNamesRef, "RowTimes", varNamesRef(idx));
        end
        [a, k] = members(d.Properties.VariableNames, varNamesRef);
        varNames = varNames(k);
        convert = convert(k);
        outputfmt = outputfmt(k);
    end
    
    if or(varNamesRef <> varNames) then
        d.Properties.VariableNames = varNames;
    end
    
    idx = find(convert <> "")
    if idx <> [] then
        convert_fcn = get("uiimport_convert", "userdata");
        for i = idx
            jdx = find(convert(idx) == get("uiimport_convert", "string"));
            d(varNames(i)) = convert_fcn(jdx)(d(varNames(i)));
        end
    end

    idx = find(outputfmt <> "")
    if idx <> [] then
        for i = idx
            d(varNames(i)).format = outputfmt(i);
        end
    end
    disp(d);
    delete(p);
    res = d;
endfunction

// -----------------------------------------------------------------------------

function uiimport_cbselect()

    data = get("uiimport", "userdata");
    path = data.path;
    
    if path == "" then
        path = pwd();
    else
        path = fileparts(path);
    end

    path = uigetfile(["*.txt" "Text files";"*.csv" "CSV files"], path, "Choose a file", %f);
    if ~isempty(path) then
        data = struct("path", path, "opts", [], "x", [], "numheaderlines", []);
        data.path = path;
        set("uiimport", "figure_name", path, "userdata", data);
        p = progressionbar("Import data ...");
        p.tag = "uiimport_progressionbar";
        uiimport_preview();
        if is_handle_valid(p) then
            delete(p);
        end
    end
endfunction

// -----------------------------------------------------------------------------

function uiimport_function()

    data = get("uiimport", "userdata");
    path = data.path;

    x = "import_" + basename(path);
    x = strsubst(x, "/-|\.|\s/", "_", "r");
    filename = fullfile(fileparts(path), x + ".sce");

    if isfile(filename) then
        m = messagebox("This file exists already. Do you want to overwrite it ?", "Warning", "warning", ["Yes", "No"], "modal");
        if m == 1 then
            deletefile(filename);
        else
            return
        end
    end

    opts = data.opts;
    varNames = data.varnames(data.keepcols);
    varNamesRef = opts.variableNames(data.keepcols);
    convert = data.convert(data.keepcols);
    outputfmt = data.outputFormat(data.keepcols);
    variableTypes = opts.variableTypes(data.keepcols)

    str = [];
    str($+1) = sprintf("clear %s;", x(1));
    str($+1) = "";
    str($+1) = sprintf("function [data] = %s(filename)", x(1));

    p = "";
    if data.numheaderlines <> [] then
        p = sprintf(", ""NumHeaderLines"", %s", sci2exp(data.numheaderlines));
    end

    if opts.decimal <> [] then
        str($+1) = sprintf("    opts = detectImportOptions(filename, ""Delimiter"", ""%s"", ""Decimal"", ""%s"""+ p +");", opts.delimiter, opts.decimal);
    else
        str($+1) = sprintf("    opts = detectImportOptions(filename, ""Delimiter"", ""%s"""+ p +");", opts.delimiter);
    end

    if or(opts.inputFormat <> data.formatRef) then
        str($+1) = sprintf("    opts.inputFormat = %s;", sci2exp(opts.inputFormat));
    end
    
    if data.rowtimes == "No" then
        str($+1) = sprintf("    data = readtable(filename, opts, ""VariableNames"", %s);", sci2exp(varNamesRef));
    else
        idx = find(data.rowtimes == varNames);
        if convert(idx) <> "" then
            str($+1) = sprintf("    data = readtimeseries(filename, opts, ""VariableNames"", %s, ""RowTimes"", ""%s"", ""ConvertTime"", %s);", sci2exp(varNamesRef), varNamesRef(idx), convert(idx));
            convert(idx) = "";
        else
            if variableTypes(idx) == "double" then
                m = messagebox("Unable to create a variable. You must choose the conversion method.", "Warning", "warning", "Ok", "modal");
                return
            end
            str($+1) = sprintf("    data = readtimeseries(filename, opts, ""VariableNames"", %s, ""RowTimes"", ""%s"");", sci2exp(varNamesRef), varNamesRef(idx));
        end
        variableNames = varNamesRef;
        vartime = variableNames(idx);
        variableNames(idx) = [];
        variableNames = [vartime variableNames];
        [a, k] = members(variableNames, varNamesRef);
        
        varNames = varNames(k);
        convert = convert(k);
        outputfmt = outputfmt(k);
    end

    // rename columns
    if or(varNamesRef <> varNames) then
        str($+1) = sprintf("    data.Properties.VariableNames = %s;", sci2exp(varNames));
    end

    idx = find(convert <> "")
    if idx <> [] then
        for i = idx
            str($+1) = sprintf("    data(%s) = %s(data(%s));", sci2exp(varNames(i)), convert(i), sci2exp(varNames(i)));
        end
    end

    idx = find(outputfmt <> "")
    if idx <> [] then
        for i = idx
            str($+1) = sprintf("    data(%s).format = ""%s"";", sci2exp(varNames(i)), outputfmt(i));
        end
    end

    str($+1) = "endfunction";
    str($+1) = "";

    str($+1) = sprintf("data = %s(""%s"");", x(1), path);


    filename = fullfile(fileparts(path), x + ".sce");
    mputl(str, filename);
    scinotes(filename)

endfunction

// -----------------------------------------------------------------------------

function uiimport_selectcolumn()
    tag = gcbo.tag;
    index = get(tag, "userdata");
    value = get(tag, "value");
    data = get("uiimport", "userdata");
    keepcols = data.keepcols;
    
    if value then
        enable = "on";
        keepcols = [keepcols, index];
    else
        enable = "off";
        keepcols(keepcols == index) = [];
    end

    keepcols = gsort(keepcols, 'g', 'i');
    data.keepcols = keepcols;
    
    set("edit" + string(index), "enable", enable);

    // update time reference
    opts = data.opts;
    varNames = data.varnames(keepcols);
    varTypes = opts.variableTypes(keepcols);

    varTypes_idx = varTypes == "double" | varTypes == "datetime" | varTypes == "duration";
    timevar = ["No", varNames(varTypes_idx)];

    timecol_obj = get("uiimport_timevar");
    idx = find(timevar == timecol_obj.string(timecol_obj.value));
    if idx == [] then
        enable = "on";
        if size(timevar, "*") == 1 then
            enable = "off";
        end
        data.rowtimes = "No";
        set("uiimport_timevar", "string", timevar, "value", 1, "enable", enable);
        // hide convert to or input format
        set("uiimport_timereflayer", "value", 1);
        set("uiimport_timeref", "visible", "off");
    else
        set("uiimport_timevar", "string", timevar, "value", idx);
    end

    // update preview
    set("uiimport_col" + string(index), "visible", value);

    if get("uiimport_btnvariable", "enable") == "off" then
        set("uiimport_btnvariable", "enable", "on");
        set("uiimport_btnfunction", "enable", "on");
    end

    set("uiimport", "userdata", data);

endfunction

// -----------------------------------------------------------------------------

function uiimport_changecolname()
    tag = gcbo.tag;
    index = get(tag, "userdata");
    data = get("uiimport", "userdata");
    str = get(tag, "string");

    // update name in opts
    opts = data.opts;
    varNames = data.varnames;
    oldvarName = varNames(index);
    
    if str == "" then
        set(tag, "string", oldvarName);
        return
    end

    varNames(index) = str;
    data.varnames = varNames;

    // update timevar popupmenu
    timevar = get("uiimport_timevar", "string")
    idx = find(timevar == oldvarName);
    if idx <> [] then
        timevar(idx) = str;
        value = get("uiimport_timevar", "value");
        set("uiimport_timevar", "string", timevar, "value", value);
    end

    if data.rowtimes == oldvarName then
        data.rowtimes = str;
    end

    // update preview
    set("header" + string(index), "string", str);

    set("uiimport", "userdata", data);

endfunction

// -----------------------------------------------------------------------------

function uiimport_allselect()
    data = get("uiimport", "userdata");
    nbcol = data.nbcols;

    data.keepcols = 1:nbcol;
    for i = 1:nbcol
        set("var" + string(i), "value", 1);
        set("edit" + string(i), "enable", "on");
    end

    opts = data.opts;
    varNames = data.varnames;
    varTypes = opts.variableTypes;
    timevar = ["No", varNames(varTypes == "double" | varTypes == "datetime" | varTypes == "duration")];
    timecol_obj = get("uiimport_timevar");
    idx = find(timevar == timecol_obj.string(timecol_obj.value))
    if idx == [] then
        set("uiimport_timevar", "string", timevar, "value", 1, "enable", "on");
        // hide convert to or input format
        set("uiimport_timereflayer", "value", 1);
    else
        set("uiimport_timevar", "string", timevar, "value", idx);
    end

    // update preview
    set("uiimport_preview", "visible", "off");
    for i = 1:nbcol
        set("uiimport_col" + string(i), "visible", "on");
    end
    set("uiimport_preview", "visible", "on");

    set("uiimport_btnvariable", "enable", "on");
    set("uiimport_btnfunction", "enable", "on");

    set("uiimport", "userdata", data);
    
endfunction

// -----------------------------------------------------------------------------

function uiimport_noneselect()
    data = get("uiimport", "userdata");
    nbcol = data.nbcols;

    data.keepcols = [];
    for i = 1:nbcol
        set("var" + string(i), "value", 0);
        set("edit" + string(i), "enable", "off");
    end

    timevar = ["No"];
    
    set("uiimport_timevar", "string", timevar, "value", 1, "enable", "on");
    set("uiimport_timereflayer", "value", 1);
    set("uiimport_timeref", "visible", "off");

    set("uiimport_preview", "visible", "off");

    // update preview
    for i = 1:nbcol
        set("uiimport_col" + string(i), "visible", "off");
    end

    set("uiimport_preview", "visible", "on");
    set("uiimport_btnvariable", "enable", "off");
    set("uiimport_btnfunction", "enable", "off");

    set("uiimport", "userdata", data);
    
endfunction

// -----------------------------------------------------------------------------

function uiimport_timevar()
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));

    data = get("uiimport", "userdata");

    if timevar == "No" then
        set("uiimport_timereflayer", "value", 1);
        set("uiimport_timeref", "visible", "off");
        return
    end
    
    opts = data.opts;
    idx = find(data.varnames == timevar);

    varType = opts.variableTypes(idx);

    if varType == "double" then
        set("uiimport_timereflayer", "value", 3);
        if data.convert(idx) <> "" then
            set("uiimport_convert", "value", find(get("uiimport_convert", "string") == data.convert(idx)));
        else
            set("uiimport_convert", "value", 1);
        end
        //data.convert = get("uiimport_convert", "userdata")(get("uiimport_convert", "value"));
    else
        inputfmt = opts.inputFormat(idx);
        outputfmt = data.outputFormat(idx);
        set("uiimport_timereflayer", "value", 2);
        set("uiimport_inputformat", "string", inputfmt);
        set("uiimport_outputformat", "string", inputfmt);
    end

    set("uiimport_timeref", "visible", "on", "value", bool2s(data.rowtimes == timevar));

    set("uiimport", "userdata", data);

endfunction

// -----------------------------------------------------------------------------
function uiimport_timeref()
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));
    data = get("uiimport", "userdata");

    value = gcbo.value;
    if value then
        data.rowtimes = timevar;
    else
        data.rowtimes = "No";
    end
    set("uiimport", "userdata", data);
    
endfunction


// -----------------------------------------------------------------------------

function uiimport_updateinputformat()
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));
    inputfmt = get("uiimport_inputformat", "string");

    // data structure
    data = get("uiimport", "userdata");
    opts = data.opts;
    idx = find(data.varnames == timevar);

    if inputfmt == opts.inputFormat(idx) then
        return
    end
    
    // update preview
    x = data.x;
    p = x(:, idx);
    jdx = find(p <> "...");

    vartype = opts.variableTypes(idx);
    outputfmt = data.outputFormat(idx);

    try
        if vartype == "datetime" then
            p(jdx) = string(datetime(p(jdx), "InputFormat", inputfmt, "OutputFormat", outputfmt));
        else
            p(jdx) = string(duration(p(jdx), "InputFormat", inputfmt, "OutputFormat", outputfmt));
        end

        frcol = get("uiimport_col" + string(idx));
        jdx = find(frcol.children.tag == "");
        frcol.children(jdx($:-1:1)).string = p;

        opts.inputFormat(idx) = inputfmt;
        data.opts = opts;
        set("uiimport", "userdata", data);

    catch
        errclear();
        m = messagebox(["The input format """ + inputfmt + """ cannot be applied."; "The previous input format is reapplied."], "Warning", "warning", "Ok", "modal");
        set("uiimport_inputformat", "string", opts.inputFormat(idx))
        uicontrol(get("uiimport_format"));
    end
endfunction

// -----------------------------------------------------------------------------

function uiimport_resetinputformat()
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));
    data = get("uiimport", "userdata");
    opts = data.opts;
    idx = find(data.varnames == timevar);

    fmtRef = data.formatRef(idx);
    vartype = opts.variableTypes(idx);
    outputfmt = data.outputFormat(idx);

    x = data.x;
    p = x(:, idx);
    jdx = find(p <> "...");

    if vartype == "datetime" then
        p(jdx) = string(datetime(p(jdx), "InputFormat", fmtRef, "OutputFormat", outputfmt));
    else
        p(jdx) = string(duration(p(jdx), "InputFormat", fmtRef, "OutputFormat", outputfmt));
    end

    frcol = get("uiimport_col" + string(idx));
    jdx = find(frcol.children.tag == "");
    frcol.children(jdx($:-1:1)).string = p;

    set("uiimport_inputformat", "string", fmtRef)

    opts.inputFormat(idx) = fmtRef;
    data.opts = opts;
    set("uiimport", "userdata", data);
endfunction

// -----------------------------------------------------------------------------

function uiimport_resetoutputformat()
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));
    data = get("uiimport", "userdata");
    opts = data.opts;
    idx = find(data.varnames == timevar);

    fmtRef = data.formatRef(idx);
    vartype = opts.variableTypes(idx);
    inputfmt = opts.inputFormat(idx);

    x = data.x;
    p = x(:, idx);
    jdx = find(p <> "...");

    if vartype == "datetime" then
        p(jdx) = string(datetime(p(jdx), "InputFormat", inputfmt, "OutputFormat", fmtRef));
    else
        p(jdx) = string(duration(p(jdx), "InputFormat", inputfmt, "OutputFormat", fmtRef));
    end

    frcol = get("uiimport_col" + string(idx));
    jdx = find(frcol.children.tag == "");
    frcol.children(jdx($:-1:1)).string = p;

    set("uiimport_outputformat", "string", fmtRef)

    data.outputFormat(idx) = fmtRef;
    set("uiimport", "userdata", data);
endfunction


// -----------------------------------------------------------------------------

function uiimport_updateoutputformat()
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));
    outputfmt = get("uiimport_outputformat", "string");

    // data structure
    data = get("uiimport", "userdata");

    opts = data.opts;
    idx = find(data.varnames == timevar);

    if outputfmt == data.outputFormat(idx) then
        return
    end

    inputfmt = opts.inputFormat(idx);

    // update preview
    x = data.x;
    p = x(:, idx);
    jdx = find(p <> "...");

    vartype = opts.variableTypes(idx);

    try
        if vartype == "datetime" then
            p(jdx) = string(datetime(p(jdx), "InputFormat", inputfmt, "OutputFormat", outputfmt));
        else
            p(jdx) = string(duration(p(jdx), "InputFormat", inputfmt, "OutputFormat", outputfmt));
        end

        frcol = get("uiimport_col" + string(idx));
        jdx = find(frcol.children.tag == "");
        frcol.children(jdx($:-1:1)).string = p;

        data.outputFormat(idx) = outputfmt;
        set("uiimport", "userdata", data);
    catch
        errclear();
        m = messagebox(["The output format """ + outputfmt + """ccannot be applied."; "The previous output format is reapplied."], "Warning", "warning", "Ok", "modal");
        set("uiimport_outputformat", "string", data.outputFormat(idx))
        uicontrol(get("uiimport_format"));
    end

endfunction

// -----------------------------------------------------------------------------

function uiimport_convertto()
    convert_to = get("uiimport_convert", "string")(get("uiimport_convert", "value"));
    timevar = get("uiimport_timevar", "string")(get("uiimport_timevar", "value"));
    
    // data structure
    data = get("uiimport", "userdata");
    

    opts = data.opts;
    idx = find(data.varnames == timevar);

    x = data.x;
    p = x(:, idx);

    if convert_to == "No" then
        data.convert(idx) = "";
        if data.rowtimes == timevar then
            data.rowtimes = "";
            set("uiimport_timeref", "value", 0);
        end
    else
        convert_fcn = get("uiimport_convert", "userdata")(get("uiimport_convert", "value"));
        data.convert(idx) = convert_to;
        jdx = find(p <> "...");
        p(jdx) = string(convert_fcn(strtod(p(jdx))));
    end

    frcol = get("uiimport_col" + string(idx));
    jdx = find(frcol.children.tag == "");
    frcol.children(jdx($:-1:1)).string = p;

    set("uiimport", "userdata", data);
endfunction

// -----------------------------------------------------------------------------

function uiimport_delimiter(delim)
    if delim == 7 && get("uiimport_fr_custom_delim", "visible") == "off" then
        // custom choice
        set("uiimport_fr_custom_delim", "visible", "on");
        pos = get("uiimport_fr_decim", "position");
        pos(2) = pos(2) - 25;
        set("uiimport_fr_decim", "position", pos);
        pos = get("uiimport_frimport", "position");
        pos(4) = pos(4) - 25;
        set("uiimport_frimport", "position", pos)
    elseif delim <> 7 && get("uiimport_fr_custom_delim", "visible") == "on" then
        set("uiimport_fr_custom_delim", "visible", "off");
        pos = get("uiimport_fr_decim", "position");
        pos(2) = pos(2) + 25;
        set("uiimport_fr_decim", "position", pos);
        pos = get("uiimport_frimport", "position");
        pos(4) = pos(4) + 25;
        set("uiimport_frimport", "position", pos)

        set("uiimport_custom_delim", "string", "");
        set("uiimport_delim", "userdata", [get("uiimport_delim", "userdata")(1:$-1), ""])
    end

    if get("uiimport_custom_delim", "string") <> "" then
        d = get("uiimport_custom_delim", "string");
        symbol = get("uiimport_delim", "userdata");
        // check if the new delimiter already exists in symbol list
        idx = find(symbol == d);
        if idx <> [] then
            if idx <> 7 then
                set("uiimport_delim", "value", idx);
                set("uiimport_fr_custom_delim", "visible", "off")

                pos = get("uiimport_fr_decim", "position");
                pos(2) = pos(2) + 25;
                set("uiimport_fr_decim", "position", pos);
                pos = get("uiimport_frimport", "position");
                pos(4) = pos(4) + 25;
                set("uiimport_frimport", "position", pos)

                set("uiimport_custom_delim", "string", "");
                set("uiimport_delim", "userdata", [get("uiimport_delim", "userdata")(1:$-1), ""])
            else
                return
            end
        else
            if size(symbol, "*") == 6 then
                // add new delimiter
                set("uiimport_delim", "userdata", [symbol, d]);
            else
                // modify delimiter if last delimiter is not new delimiter
                if symbol($) <> d then
                    set("uiimport_delim", "userdata", [symbol(1:$-1), d]);
                end
            end
        end
    end
endfunction

// -----------------------------------------------------------------------------

function uiimport_custom_delimiter()
    data = get("uiimport", "userdata");
    val = get("uiimport_delim", "value");
    delim = get("uiimport_delim", "userdata")(val);
    if delim <> data.opts.delimiter then
        uiimport_delimiter(val);
        uiimport_preview();
    end
endfunction

// -----------------------------------------------------------------------------

function uiimport_custom_header()
    data = get("uiimport", "userdata");
    val = strtod(get("uiimport_nbheader", "string"));
    if val <> data.numheaderlines then
        data.numheaderlines = val;
        set("uiimport", "userdata", data);
        uiimport_preview();
    end
endfunction


// -----------------------------------------------------------------------------

function uiimport_preview()
    //global %uiimport_cancel;

    set("uiimport_btnvariable", "enable", "off");
    set("uiimport_btnfunction", "enable", "off");

    data = get("uiimport", "userdata");
    path = data.path;

    if isempty(path) || ~isfile(path) then
        return;
    end

    if data.opts == [] then
        try
            opts = detectImportOptions(path, "NumHeaderLines", data.numheaderlines);
            if opts.variableNames <> [] & size(opts.variableNames, "*") <> size(opts.variableTypes, "*") then
                delete(get("uiimport_progressionbar"));
                messagebox("Problem during the import. Choose another delimiter or decimal separator.", "Warning", "warning", "Ok", "modal");
                data.opts = opts;
                set("uiimport", "userdata", data);
                fc = get("uiimport_import");
                set("uiimport_frimport", "visible", "off");
                delete(fc.children);
                fp = get("uiimport_preview");
                delete(fp.children);
                return
            end
        catch
            delete(get("uiimport_progressionbar"));
            set("uiimport_nbcols", "string", "Not defined");
            set("uiimport_nbrows", "string", "Not defined");
            set("uiimport_nbheader", "string", "0");
            data.numheaderlines = 0;
            set("uiimport", "userdata", data);
            set("uiimport_frimport", "visible", "off");
            fc = get("uiimport_import");
            delete(fc.children);
            fp = get("uiimport_preview");
            fp.visible = "off";
            delete(fp.children)
            fp.visible = "on";
            //set focus
            uicontrol(get("uiimport"))
            messagebox("Problem during the import. Choose another delimiter or decimal separator or specify the number of lines of header.", "Warning", "warning", "Ok", "modal");
            return;
        end

        nbrows = size(opts.datalines, "*") + size(opts.header, "*");
        if opts.datalines(1) <> size(opts.header, "*") + 1 then
            // has variableNames
            nbrows = nbrows + 1;
        end

        data.nbrows = nbrows;
        delim = opts.delimiter;
        decim = opts.decimal;
        val = find(get("uiimport_delim", "userdata") == delim)
        if delim <> "" && val == [] then
            val = 7;
            set("uiimport_custom_delim", "string", delim);
        end
        set("uiimport_delim", "value", val);

        if val == 1 then
            set("uiimport_decim", "value", 1);
        else
            value = find(get("uiimport_decim", "userdata") == decim)
            set("uiimport_decim", "value", value)
        end
        
        set("uiimport_nbrows", "string", string(nbrows));
    else
        val = get("uiimport_delim", "value");
        delim = get("uiimport_delim", "userdata")(val);
        decim = get("uiimport_decim", "value")
        decim = get("uiimport_decim", "userdata")(decim);
        try
            opts = detectImportOptions(path, "Delimiter", delim, "Decimal", decim, "NumHeaderLines", data.numheaderlines);
            if opts.variableNames <> [] & size(opts.variableNames, "*") <> size(opts.variableTypes, "*") then
                return
            end
        catch
            uiimport_delimiter(val);
            set("uiimport_nbrows", "string", "Not defined");
            set("uiimport_nbcols", "string", "Not defined");
            set("uiimport_nbheader", "string", "0");
            set("uiimport_frimport", "visible", "off");
            fc = get("uiimport_import");
            delete(fc.children);
            fp = get("uiimport_preview");
            fp.visible = "off";
            delete(fp.children)
            fp.visible = "on";
            //set focus
            uicontrol(get("uiimport"))
            return;
        end
    end

    uiimport_delimiter(val);

    if opts.variableNames == [] then
        opts.variableNames = "Var" + string(1:size(opts.variableTypes, "*"));
    end

    nbcols = size(opts.variableNames, "*");
    data.nbcols = nbcols;
    data.opts = opts;
    data.formatRef = opts.inputFormat;
    data.outputFormat = opts.inputFormat;
    data.convert = emptystr(1, nbcols);
    set("uiimport_nbcols", "string", string(nbcols));
    set("uiimport_nbheader", "string", string(size(opts.header, "*")));

    c = get("uiimport_preview");
    c.visible = "off";
    delete(c.children);

    // parent = c.parent;
    // fr = uicontrol(parent, ...
    //     "style", "frame", ...
    //     "layout", "gridbag", ...
    //     "tag", "uiimport_cancel", ...
    //     "backgroundcolor", [1 1 1], ...
    //     "constraints", createConstraints("border", "center"));

    // uicontrol(fr, ...
    //     "style", "pushbutton", ...
    //     "string", _("Cancel preview"), ...
    //     "callback_type", 10, ...
    //     "callback", "global %uiimport_cancel;%uiimport_cancel=%t;", ...
    //     "constraints", createConstraints("gridbag", [1 1 1 1], [1, 1]));

    varnames = opts.variableNames;
    l = opts.datalines;

    dots = %f;
    if l($)-l(1)+1 > 31 then
        txt = mgetl(path);
        txt = txt([l(1):l(1)+14 l($)-14:l($)])
        dots = %t;
    else
        txt = mgetl(path);
        txt = txt(l);
    end
       
    try
        x = csvTextScan(txt, delim, decim, "string");
    catch
        fc = get("uiimport_import");
        set("uiimport_frimport", "visible", "off");
        delete(fc.children)
        c.visible = "on";
        messagebox("Problem during the import. Choose another delimiter or decimal separator or specify the number of lines of header.", "Warning", "warning", "Ok", "modal");
        return;
    end

    if opts.emptyCol <> [] then
        x(:, opts.emptyCol) = [];
    end

    if size(x, "c") <> size(varnames, "c") then
        messagebox("Problem during the import. Choose another delimiter or decimal separator.", "Warning", "warning", "Ok", "modal");
        data.opts = opts;
        set("uiimport", "userdata", data),
        fc = get("uiimport_import");
        set("uiimport_frimport", "visible", "off");
        delete(fc.children),
        c.visible = "on";
        return
    end

    hasHeader = %f;
    if varnames <> [] then
        hasHeader = %t;
    end

    if dots then
        x = [x(1:14,:); "..." + emptystr(1, size(x, 2)); x(15:$, :)];
    end

    data.x = x;

    timevar = ["No", varnames(opts.variableTypes == "double" | opts.variableTypes == "datetime" | opts.variableTypes == "duration")];
    data.rowtimes = timevar(1);
    data.varnames = varnames;

    limit = size(varnames, "c");

    fc = get("uiimport_import");
    set("uiimport_frimport", "visible", "off");
    delete(fc.children)
    pfdsize = 24*limit+17;
    if pfdsize >= 237 then
        pfdsize = 237;
    end

    fcheckbox = uicontrol(fc, ...
        "style", "frame", ...
        "layout", "gridbag", ...
        "border", createBorder("line", "#c6c6c6"), ...
        "backgroundcolor", [1 1 1], ...
        "scrollable", "on", ...
        "tag", "uiimport_namescolumns", ...
        "constraints", createConstraints("gridbag", [1 1 1 1], [1, 0], "horizontal", "upper", [0 0], [1, pfdsize]));

    for i = 1:limit
        constraints = createConstraints("gridbag", [1 i 1 1], [0.02, 0], "horizontal", "upper", [2, 1]);
        uicontrol(fcheckbox, ...
            "style", "checkbox", ...
            "tag", "var" + string(i), ...
            "margins", [3 2 0 0], ...
            "value", 1, ...
            "backgroundcolor", [1 1 1], ...
            "callback", "uiimport(""selectcolumn"")", ...
            "userdata", i, ...
            "constraints", constraints);

        constraints = createConstraints("gridbag", [2 i 1 1], [0.98, 0], "horizontal", "upper", [10, 1]);
        uicontrol(fcheckbox, ...
            "style", "edit", ...
            "tag", "edit" + string(i), ...
            "string", varnames(i), ...
            "margins", [3 0 0 4], ...
            "callback", "uiimport(""changename"")", ...
            "userdata", i, ...
            "constraints", constraints);
    end

    uicontrol(fc, ...
        "style", "text", ...
        "string", _("Time reference / Columns format"), ...
        "fontweight", "bold", ...
        "backgroundcolor", [1 1 1], ...
        "margins", [5 5 0 0], ...
        "constraints", createConstraints("gridbag", [1 2 1 1], [1, 0], "horizontal", "upper", [5 5], [1, 25]));

    uicontrol(fc, ...
        "style", "popupmenu", ...
        "string", timevar, ...
        "margins", [0 1 0 1], ...
        "value", 1, ...
        "callback", "uiimport(""timevariable"")", ...
        "tag", "uiimport_timevar", ...
        "backgroundcolor", [1 1 1], ...
        "constraints", createConstraints("gridbag", [1 3 1 1], [1, 0], "horizontal", "upper", [0 0], [1, 22]));

    uicontrol(fc, ...
        "style", "checkbox", ...
        "string", "Time reference", ...
        "margins", [0 1 0 1], ...
        "backgroundcolor", [1 1 1], ...
        "visible", "off", ...
        "tag", "uiimport_timeref", ...
        "callback", "uiimport(""timeref"")", ...
        "constraints", createConstraints("gridbag", [1 4 1 1], [1, 0], "horizontal", "upper", [0 0], [1, 22]));


    frlayer = uicontrol(fc, ...
        "style", "layer", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "uiimport_timereflayer", ...
        "constraints", createConstraints("gridbag", [1 5 1 1], [1 0], "horizontal", "upper", [0 2], [1 93]))

    frconvertto = uicontrol(frlayer, ...
        "style", "frame", ....
        "backgroundcolor", [1 1 1], ...
        "visible", "off", ...
        "tag", "uiimport_convert_to");

    uicontrol(frconvertto, ...
        "style", "text", ...
        "string", _("Convert to"), ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 70 135 23]);
        
    uicontrol(frconvertto, ...
        "style", "popupmenu", ...
        "string", [_("No"), _("seconds"), _("minutes"), _("hours"), _("days"), _("years")], ...
        "userdata", list("", seconds, minutes, hours, days, years), ...
        "value", 1, ...
        "callback", "uiimport(""convert"")", ...
        "tag", "uiimport_convert", ...
        "backgroundcolor", [1 1 1], ...
        "position", [148 70 105 22]);

    fr_inputformat = uicontrol(frlayer, ...
        "style", "frame", ....
        "backgroundcolor", [1 1 1], ...
        "visible", "off", ...
        "tag", "uiimport_format"); 

    uicontrol(fr_inputformat, ...
        "style", "text", ...
        "string", _("Input Format"), ...
        "backgroundcolor", [1 1 1], ...
        "position", [3 72 135 20]);

    uicontrol(fr_inputformat, ...
        "style", "edit", ...
        "string", "", ...
        "tag", "uiimport_inputformat", ...
        "callback", "uiimport(""inputformat"")", ...
        "position", [3 47 225 23]);

    uicontrol(fr_inputformat, ...
        "style", "pushbutton", ...
        "icon", "view-refresh", ...
        "backgroundcolor", [1 1 1], ...
        "callback", "uiimport(""resetinput"")", ...
        "position", [232 47 23 23]);

    uicontrol(fr_inputformat, ...
        "style", "text", ...
        "string", _("Output Format"), ...
        "backgroundcolor", [1 1 1], ...
        "position", [5 25 135 20]);

    uicontrol(fr_inputformat, ...
        "style", "edit", ...
        "string", "", ...
        "tag", "uiimport_outputformat", ...
        "callback", "uiimport(""outputformat"")", ...
        "position", [3 0 225 23]);

    uicontrol(fr_inputformat, ...
        "style", "pushbutton", ...
        "icon", "view-refresh", ...
        "backgroundcolor", [1 1 1], ...
        "callback", "uiimport(""resetoutput"")", ...
        "position", [232 0 23 23]);

    uicontrol(frlayer, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1]);

    frlayer.value = 1;

    constraints = createConstraints("gridbag", [1 5 1 1], [1, 1]);
    uicontrol(fc, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "constraints", constraints);

    set("uiimport_frimport", "visible", "on");
    data.opts = opts;
    data.keepcols = 1:limit;
    set("uiimport", "userdata", data)

    
    for i = 1:limit
        // if %uiimport_cancel then
        //     break;
        // end

        progress = i / limit;
        constraints = createConstraints("gridbag", [i 1 1 1], [1, 0], "horizontal", "upper");

        if hasHeader then
            h = varnames(i);
        else
            h = sprintf("col%d", i);
        end

        if i == 1 then
            margins = [0 5 0 0];
        elseif i == limit then
            margins = [0 0 0 5];
        else
            margins = [0 0 0 0];
        end

        frcol = uicontrol(c, ...
            "style", "frame", ...
            "layout", "gridbag", ...
            "backgroundcolor", [1 1 1], ...
            "tag", "uiimport_col" + string(i), ...
            "margins", margins, ...
            "constraints", constraints);
        
        constraints = createConstraints("gridbag", [1 1 1 1], [1, 0], "horizontal", "upper", [10, 10]);

        uicontrol(frcol, ...
            "style", "text", ...
            "string", h, ...
            "horizontalalignment", "center", ...
            "relief", "solid", ...
            "tag", "header" + string(i), ...
            "margins", [2 0 0 0], ...
            "backgroundcolor", [1 1 1], ...
            "constraints", constraints)

        for j = 1:size(x, "r")
            constraints = createConstraints("gridbag", [1 j+1 1 1], [1, 0], "horizontal", "upper", [6 6]);

            if x(j,i) == "" then
                x(j,i) = " ";
            end

            uicontrol(frcol, ...
                "style", "text", ...
                "horizontalalignment", "center", ...
                "backgroundcolor", [1 1 1], ...
                "string", x(j,i), ...
                "constraints", constraints);
        end

        uiimport_progress(progress);
    end

    //to push lines to top
    constraints = createConstraints("gridbag", [1 size(x, "r")+1 size(x, "c") 1], [1, 1], "both", "upper");
    uicontrol(c, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "constraints", constraints);

    //delete(fr);

    // if %uiimport_cancel then
    //     //delete created children to keep interface clean
    //     delete(c.children)
    // else
        set("uiimport_btnvariable", "enable", "on");
        set("uiimport_btnfunction", "enable", "on");
    // end

    // clearglobal %uiimport_cancel;
    set("uiimport", "userdata", data)
    c.visible = "on";
    uiimport_progress(0);
    
endfunction
