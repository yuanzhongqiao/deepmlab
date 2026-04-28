// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Bruno JOFRET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.
function demo_optimshape()

    // Create a figure to be able to see the optimisation steps
    // First axes: Shapes / Second axes: cost function values
    fig = figure( ...
        "figure_id", 100002, ...
        "background", -2, ...
        "axes_size", [1000 450], ...
        "menubar_visible", "on", ...
        "menubar", "none", ...
        "default_axes", "off", ...
        "layout", "border", ...
        "tag", "optimshape_demo"); 

    // New menu
    m = uimenu(fig, ...
        "label" , gettext("File"));

    uimenu(m, ...
        "label"     , gettext("Close"), ...
        "callback"  , "close(get(""optimshape_demo"")); clear(""demo_optimshape"")", ...
        "tag"       , "close_menu");

    demo_viewCode("optimShape.dem.sce");

    // left frame
    fleft = uicontrol(fig, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "layout", "gridbag", ...
        "constraints", createConstraints("border", "left", [150 0]));

    h = 135;
    f1 = uicontrol(fleft, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "border", createBorder("matte", 1, 1, 1, 1, "#dddddd"), ...
        "constraints", createConstraints("gridbag", [1 1 1 1], [1 1], "none","center", [0 0], [150 h]));

    h = h - 32;
    uicontrol(f1, ...
        "style", "text", ...
        "string", "Points", ...
        "backgroundcolor", [1 1 1], ...
        "fontweight", "bold", ...
        "position", [5 h 70 25]);

    uicontrol(f1, ...
        "style", "popupmenu", ...
        "string", string(3:8)', ...
        "value", 3, ...
        "tag", "optimshape_nbpoints", ...
        "callback", "optimshape_cb_custom", ...
        "position", [75 h 70 25]);

    h = h - 40;
    uicontrol(f1, ...
        "style", "radiobutton", ...
        "string", "Random", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "optimshape_random", ...
        "groupname", "optimshape_group", ...
        "callback", "optimshape_cb_custom", ...
        "value", 1, ...
        "position", [75 h 70 25]);

    h = h - 25;
    uicontrol(f1, ...
        "style", "radiobutton", ...
        "string", "Regular", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "optimshape_regular", ...
        "groupname", "optimshape_group", ...
        "callback", "optimshape_cb_custom", ...
        "position", [75 h 70 25]);

    uicontrol(f1, ...
        "style", "text", ...
        "string", "Shape", ...
        "backgroundcolor", [1 1 1], ...
        "fontweight", "bold", ...
        "position", [5 h+15 70 25]);

    h = h - 35;
    uicontrol(f1, ...
        "style", "pushbutton", ...
        "icon", "media-playback-start", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "optimshape_play", ...
        "tooltipstring", _("Play"), ...
        "callback", "optimshape_cb_play", ...
        "relief", "groove", ...
        "position", [20 h 50 25]);

    uicontrol(f1, ...
        "style", "pushbutton", ...
        "icon", "process-stop", ...
        "backgroundcolor", [1 1 1], ...
        "tag", "optimshape_stop", ...
        "tooltipstring", _("Stop"), ...
        "Callback_Type",10, ...
        "callback", "optimshape_cb_stop", ...
        "relief", "groove", ...
        "position", [80 h 50 25]);

    // central frame
    fc = uicontrol(fig, ...
        "style", "frame", ...
        "tag", "optimshape_plot", ...
        "constraints", createConstraints("border", "center"));
    
endfunction

function optimshape_cb_play()
    // set focus
    uicontrol(gcbo.parent)

    set("optimshape_play", "enable", "off");
    set("optimshape_nbpoints", "enable", "off");
    set("optimshape_random", "enable", "off");
    set("optimshape_regular", "enable", "off");

    nbPoints = evstr(get("optimshape_nbpoints", "string")(get("optimshape_nbpoints", "value")));
    fc = get("optimshape_plot");
    delete(fc.children);

    newaxes(fc);
    subplot(1, 2, 1);
    xlabel("X");
    ylabel("Y");
    xtitle("Shape");
    a = gca();
    a.axes_visible = "on";
    a.box = "on";
    a.clip_state = "clipgrf";
    // Target shape
    xpoly(0, 0);
    e = gce();
    e.foreground = color("red");
    e.mark_foreground = color("red");
    e.closed = "on";
    e.mark_mode = "on";
    e.mark_size = 3;
    e.tag = "TargetShape";
    // Current optimisation step shape
    xpoly(0, 0);
    e = gce();
    e.foreground = color("green");
    e.mark_foreground = color("green");
    e.closed = "on";
    e.mark_mode = "on";
    e.mark_size = 3;
    e.tag = "CurrentShape"
    legend(["Target", "Current"]);

    // Optimisation settings
    opt = optimset("Display", "final", ...
                "PlotFcns" , optimshapeplot, ...
                "TolX", 1e-5, ...
                "MaxIter", 1e5, ...
                "MaxFunEvals", 1e6);

    if get("optimshape_random", "value") then
        // ** Random Shape
        bounds = [0, 0; 10, 10];
        XTarget = rand(2, nbPoints);
    else
        // ** Circle Shape
        bounds = [-12, -12; 12, 12];
        v = linspace(0, 2*%pi, nbPoints + 1);
        XTarget = [ sin(v(1:$-1));
                cos(v(1:$-1))]
    end

    // Update graphics
    a.data_bounds = bounds;
    e = get("TargetShape")
    e.data = matrix(XTarget, [2, nbPoints])' .* 10;

    // Initial point
    XStart = rand(2, nbPoints);
    [Xopt fval] = fminsearch(list(costfunction, nbPoints, XTarget), XStart, opt);

    set("optimshape_demo", "info_message", _("Completed!"))
    set("optimshape_play", "enable", "on");
    set("optimshape_nbpoints", "enable", "on");
    set("optimshape_random", "enable", "on");
    set("optimshape_regular", "enable", "on");
end

function optimshape_cb_stop()
    set("optimshape_demo", "info_message", "Optimization stopped!");
    set("optimshape_play", "enable", "on");
    set("optimshape_nbpoints", "enable", "on");
    set("optimshape_random", "enable", "on");
    set("optimshape_regular", "enable", "on");
    abort;
endfunction

function optimshape_cb_custom()
    set("optimshape_demo", "info_message", "");
endfunction

function optimshapeplot(x, optimValues, state)
    if (state == "init") then
        // Initialise second axes: cost function values
        subplot(1, 2, 2);
        a = gca();
        a.tag = "costfunction";
        xlabel("Iteration");
        ylabel("Function value");
        xtitle("Current Function Value");
        plot(0, optimValues.fval);
        e = gce().children;
        e.mark_mode = "on";
        e.mark_style = 9;
        e.mark_size = 10;
        e.mark_background = 6;
        e.tag = "CostFunctionValue";
    else
        // Update value
        e = get("CostFunctionValue");
        e.data($+1,1:2) = [optimValues.iteration optimValues.fval];
        // Update axes
        // Compute new bounds
        itermin = 0;
        itermax = optimValues.iteration;
        d = e.data(:,2);
        fmin = min(d);
        fmax = max(d);
        a = get("costfunction");
        a.data_bounds = [
            itermin fmin
            itermax fmax
        ];
        // Title
        a.title.text = msprintf("Current Function Value: %e", optimValues.fval)
    end
endfunction

function g = costfunction(X, nbPoint, XTarget)
    
    Xc = matrix(X, [2, nbPoint]);
    // Compute cost value
    g = sum((Xc - XTarget).^2)

    // Update shape graphics
    e = get("CurrentShape");
    e.data = Xc' .* 10;
endfunction

demo_optimshape();
