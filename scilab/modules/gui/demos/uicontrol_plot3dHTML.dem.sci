// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function uicontrol_plot3dHTML()
    close(100002)
    // Create a figure
    demo_plot3d = figure( ...
        "dockable", "off", ...
        "infobar_visible", "off", ...
        "toolbar_visible", "off", ...
        "toolbar", "none", ...
        "menubar_visible", "on", ...
        "menubar", "none", ...
        "default_axes", "off", ...
        "layout", "border", ...
        "tag", "uicontrol_plot3dhtml", ...
        "visible", "off");

    demo_plot3d.figure_id       = 100002;
    demo_plot3d.background      = -2;
    demo_plot3d.color_map       = jet(128);
    demo_plot3d.figure_name     = gettext("Control Plot3d (HTML)");
    demo_plot3d.axes_size       = [900 450];

    fakeframe_height = 10;

    // New menu
    h = uimenu(demo_plot3d, ...
        "label" , gettext("File"));

    uimenu(h, ...
        "label"     , gettext("Close"), ...
        "callback"  , "demo_plot3d=findobj(""figure_id"",100002);delete(demo_plot3d);", ...
        "tag"       , "close_menu");

    demo_viewCode(SCI+ "/modules/gui/demos/uicontrol_plot3dHTML.dem.sci");

    frame_left = uicontrol(demo_plot3d, ...
        "style", "frame", ...
        "constraints", createConstraints("border", "left", [250, 0]), ...
        "backgroundcolor", [1 1 1], ...
        "layout", "border");

    uicontrol(frame_left, ...
        "style", "browser", ...
        "debug", "on", ...
        "string", SCI + "/modules/gui/demos/uicontrol_plot3d.html", ...
        "callback", "cbBrowser", ...
        "tag", "browser");

    //Plot
    frame_plot = uicontrol(demo_plot3d, ...
        "style", "frame", ...
        "layout", "border", ...
        "constraints", createConstraints("border", "center"));


    newaxes(frame_plot);
    demo_plot3d.immediate_drawing = "off";
    plot3d();

    a = gca();
    a.tag                   = "plot";
    a.title.text            = "My Beautiful Plot";
    a.title.font_size       = 5;
    a.rotation_angles(1)    = 70;

    a.x_label.text          = "X";
    a.y_label.text          = "Y";
    a.z_label.text          = "Z";

    demo_plot3d.immediate_drawing     = "on";

    demo_plot3d.visible     = "on";
endfunction

function cbBrowser(msg, cb)

    if msg == "loaded" then

        return;
    end

    select (msg.type)
    case "init"
        initGui();
    case "update"
        updatePlot(msg.data);
    case "updateonlyangle"
        updatePlotAngle(msg.data);
    end

endfunction

function c = getScilabColor(colorid)
    f = gcf();
    select colorid
    case -2
        c = "#FFFFFF";
    case -1
        c = "#000000";
    else
        c = float2rgb(f.color_map(colorid, :));
    end
endfunction

function idx = getHTMLColor(c)
    c = rgb2float(c);
    select c
    case [0 0 0]
        idx = -1;
    case [255 255 255]
        idx = -2;
    else
        idx = color(c(1), c(2), c(3))
    end
endfunction

function rgb = float2rgb(c)
    rgb = sprintf("#%02X%02X%02X", c .* 255);
endfunction

function res = rgb2float(c)
    res = [0 0 0];
    [_, _, _, hex] = regexp(c, "/#([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})/");
    if size(hex, "*") == 3 then
        res = hex2dec(hex);
    end
endfunction

function r = findColorMap()
    f = gcf();

    colors = f.color_map(1:2, :);

    c = jet(128);
    if c(1:2, :) == colors then
        r = "Jet";
        return;
    end

    c = hot(128);
    if c(1:2, :) == colors then
        r = "Hot";
        return;
    end

    c = gray(128);
    if c(1:2, :) == colors then
        r = "Gray";
        return;
    end

    c = parula(128);
    if c(1:2, :) == colors then
        r = "Parula";
        return;
    end

    r = "Jet"; //default value @ init
endfunction

function initGui()
    f = gcf();
    a = gca();
    p = a.children($);
    b = get("browser");

    st = [];
    st.alpha = a.rotation_angles(1);
    st.theta = a.rotation_angles(2);
    st.colormap = findColorMap();
    st.background = getScilabColor(f.background);
    st.axes = getScilabColor(a.background);
    st.showtics = and(a.axes_visible == "on");
    st.showtitle = a.title.visible == "on";
    st.showlabels = a.x_label.visible == "on" && a.y_label.visible == "on" && a.z_label.visible == "on";
    st.showedges = p.color_mode > 0;
    st.title = a.title.text;

    data.type = "update";
    data.data = st;
    b.data = data;
endfunction

function r = getBoolString(v)
    if v then
        r = "on";
    else
        r = "off";
    end
end

function updatePlot(st)
    f = gcf();
    a = gca();
    p = a.children($);

    a.rotation_angles = [st.alpha st.theta];

    execstr(sprintf("f.color_map = %s(128);", convstr(st.colormap)));

    f.background = getHTMLColor(st.background);
    a.background = getHTMLColor(st.axes);

    a.axes_visible = getBoolString(st.showtics);
    a.title.visible = getBoolString(st.showtitle);
    a.x_label.visible = getBoolString(st.showlabels);
    a.y_label.visible = getBoolString(st.showlabels);
    a.z_label.visible = getBoolString(st.showlabels);
    if st.showedges then
        p.color_mode = 1;
    else
        p.color_mode = -1;
    end

    a.title.text = st.title;
endfunction

function updatePlotAngle(st)
    a = gca();
    a.rotation_angles = [st.alpha st.theta];
endfunction