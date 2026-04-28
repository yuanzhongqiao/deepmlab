// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 1993 - INRIA - Serge Steer
// Copyright (C) 1993 - INRIA - Habib Jreij
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2017 - 2022 - Samuel GOUGEON - Le Mans Université
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [x, y, ok, gc] = edit_curv(varargin)
// Modification interactive d'une courbe graphique
//%Syntaxe
//  [x, y, ok, gc] = edit_curv(y)
//  [x, y, ok, gc] = edit_curv(x, y)
//  [x, y, ok, gc] = edit_curv(x, y, job, tit, gc)
//  [x, y, ok, gc] = edit_curv(axes, ..)
//  [x, y, ok, gc] = edit_curv(hcurve)
//  [x, y, ok, gc] = edit_curv(hcurve, job)
//  [x, y, ok, gc] = edit_curv(hcurve, job, ..)
//%Parametres
//  x    :  vecteur des abscisses donnees (eventuellement [])
//  y    :  vecteur des ordonnees donnees (eventuellement [])
//  hcurve :  handle de la courbe polyline à modifier
//  job   :  mot de 1 à 4 lettres (sans ordre) indiquant les
//           operations permises :
//          "a" : ajout de points possible.
//          "d" : deletion de points possible.
//          "x" : les points peuvent être déplacés horizontalement.
//          "y" : les points peuvent être déplacés verticalement.
//          Par défaut, tout est permis ("adxy").
//  tit   : liste de trois chaines de caracteres
//          tit(1) : titre du repère
//          tit(2) : légende de l'axe des abscisses
//          tit(3) : légende de l'axe des ordonnees
//  gc    : list(dataBounds, ticksNumb, lineStyles)
//          dataBounds = [xmin ymin xmax ymax]
//          ticksNumb = [nx, Nx, ny, Ny]
//          lineStyles = [line_style, colorIndex, thickness, mark_style]
//  x     : vecteur des abscisses resultat
//  y     : vecteur des ordonnees resultat
//  ok    : vaut %t si la sortie as ete demandee par le menu Ok
//           et  %f si la sortie as ete demandee par le menu Abort
//%menus
//  Ok    : sortie de l'editeur et retour de la courbe editee
//  Undo  : annulation de la précédente modification
//  Redo  : rétablissement de la précédente annulation
//  Abort : sortie de l'editeur et retour aux données initiales
//  Read  : lecture de la courbe à partir d'un fichier d'extension .xy
//  Save  : sauvegarde binaire (sur un fichier d'extension .xy) de la
//          courbe
//  Clear : effacement de la courbe (x=[] et y=[]) (sans quitter l'editeur)
//  Bounds: changement des bornes du graphique
//  Reframe: set axes bounds to data limits
//!
    fname = "edit_curv"
    [lhs, rhs] = argn(0)
    ok = %t
    i = 1; // index of current argument
    ownFigure = %t;  // %T the figure must be deleted at end
    hadChildren = %f // If %T, then we'll restore .data_bounds and grids
                   

    // CHECHING INPUT ARGUMENTS, DEFAULT INITIALIZATIONS
    // -------------------------------------------------
    // x and y, or axes or hcurve
    // --------------------------
    if rhs==0 then
        [x, y] = ([], [])
        //scf()
    else
        // hAxes
        c = varargin(1)
        if isdef("c","l") & type(c)==9 & c.type=="Axes"
            ax = c
            sca(ax)
            varargin(1) = null(), i = i+1
            ownFigure = %f
            hadChildren = ax.children <> []
            clear c
        end
        // x | hCurve
        if length(varargin) > 0
            c = varargin(1)
            if ~isdef("c","l") // undefined = skipped
                x = %nan
            elseif type(c)==9
                if c.type <> "Polyline"
                    msg = _("%s: Argument #%d: Graphic handle of type ''%s'' expected.\n")
                    if i==1
                        error(msprintf(msg, fname, i, _("Axes or Polyline")))
                    else // i==2
                        error(msprintf(msg, fname, i, "Polyline"))
                    end
                else
                    ownFigure = %f
                    hdl = c(1)
                    x = c.data(:,1)
                    y = c.data(:,2)
                    // Sets as current axes hdl's one:
                    ax = hdl
                    while ax.type <> "Axes"
                        ax = ax.parent
                    end
                    sca(ax)
                end
            else
                if type(c)<>1 | ~isreal(c,0)
                    msg = _("%s: Argument #%d: Real numbers expected.\n")
                    error(msprintf(msg, fname, i))
                end
                x = c(:)
            end
            varargin(1) = null(), i = i+1
        end
        if ~isdef("x","l") then
            x = %nan
        end
        // y
        if ~isdef("y","l") then
            if length(varargin) > 0
                c = varargin(1)
                if ~isdef("c","l")   // skipped
                    [x, y] = ([], [])
                    varargin(1) = null(), i = i+1
                elseif type(c)==10
                    if x <> x // %nan
                        [x, y] = ([], [])
                    else
                        y = x
                        x = (1:length(y))'
                    end
                elseif type(c)==1 & isreal(c,0)
                    y = c(:)
                    varargin(1) = null(), i = i+1
                else
                    msg = _("%s: Argument #%d: Real numbers expected.\n")
                    error(msprintf(msg, fname, i))
                end
            else
                if x <> x // %nan
                    [x, y] = ([], [])
                else
                    y = x
                    x = (1:length(y))'
                end
            end
        end
        if isnan(x)
            x = (1:length(y))'
        else
            Lmin = min(length(x), length(y))
            x = x(1:Lmin)
            y = y(1:Lmin)
        end
    end

    // job
    // ---
    if length(varargin) > 0 then
        if type(varargin(1))==0
            job = "adxy"
        else
            job = varargin(1)
            if type(job) <> 10
                msg = _("%s: Argument #%d: String expected.\n")
                error(msprintf(msg, fname, i))
            end
            job = job(1)    // no error if size("*") <> 1
            job = strsubst(job, "/[^adxy]/", "", "r")
            if job==""
                msg = _("%s: Argument #%d: Must be in the set {%s}.\n")
                error(msprintf(msg, fname, i, "a,d,x,y"));
            end
        end
        varargin(1) = null(), i = i+1
    else
        job = "adxy"
    end
    add  = grep(job, "a") <> []
    del  = grep(job, "d") <> []
    modx = grep(job, "x") <> []
    mody = grep(job, "y") <> []

    // tit
    // ---
    if length(varargin) > 0 then
        tit = varargin(1)
        if ~isdef("tit","l")
            tit = []
        else
            if type(tit) <> 10
                msg = _("%s: Argument #%d: String expected.\n")
                error(msprintf(msg, fname, i))
            end
            if size(tit,"*")>3
                tit = tit(1:3)
            else
                tit = [tit(:) ; emptystr(3-size(tit,"*"), 1)]
            end
        end
        varargin(1) = null(), i = i+1
    else
        tit = [" ", " ", " "]
    end

    // gc
    // --
    if length(varargin) > 0 then
        gc = varargin(1)
        if type(gc) <> 15 | length(gc) < 2 then
            msg = _("%s: Argument #%d: A list expected.\n")
            error(msprintf(msg, fname, i))
        end
        if type(gc(1)) <> 0
            rect = gc(1)
            [xmn ymn xmx ymx] = (rect(1), rect(2), rect(3), rect(4));
            dx  = xmx - xmn;
            dy  = ymx - ymn;
        end
        if type(gc(2)) <> 0
            ticksNumb = gc(2)
        end
        if length(gc) > 2
            lineStyle  = gc(3)(1)
            lineColor  = gc(3)(2)
            lineThickness = gc(3)(3)
            mark_style = gc(3)(4)
        else
            [lineStyle, lineColor, lineThickness, mark_style] = ..
                                                  (%nan,%nan,%nan,%nan)
        end
    end

    // OTHER INITIALIZATIONS
    // ---------------------
    // Initialisation des bornes initiales du graphique
    if ~ownFigure then
        db = gca().data_bounds;
    else
        scf()
        db = [];
    end
    // Default gc
    if ~isdef("rect","l") then
        if length(x)<>0 then
            if db==[]
                [xmn xmx ymn ymx]= (min(x), max(x), min(y), max(y));
            else
                [xmn xmx] = (min([x(:); db(1)]), max([x(:); db(2)]));
                [ymn ymx] = (min([y(:); db(3)]), max([y(:); db(4)]));
            end
            dx = xmx - xmn;
            dy = ymx - ymn;
            if dx==0 then dx = max(xmx/2,1), end
            if db==[]
                xmn = xmn - dx/10;
                xmx = xmx + dx/10;
            end
            if dy==0 then dy = max(ymx/2,1), end
            if db==[]
                ymn = ymn - dy/10;
                ymx = ymx + dy/10;
            end
        else
            if db==[]
                xmn=0; ymn=0; xmx=1; ymx=1; dx=1; dy=1
            else
                [xmn xmx ymn ymx] = (db(1), db(2), db(3), db(4));
                dx = xmx - xmn;
                dy = ymx - ymn;
            end
        end
        rect = [xmn,ymn,xmx,ymx];
    end
    if ~isdef("ticksNumb","l") then
        ticksNumb = [2 10 2 10];
    end
    if ~isdef("lineStyle","l") then
        lineStyles = [%nan %nan %nan %nan] // style, color, thickness, markStyle]
        [lineStyle, lineColor, lineThickness, mark_style] = ..
                                              (%nan,%nan,%nan,%nan)
    end
    if ~isdef("gc", "l") then
        gc = list(rect, ticksNumb, lineStyles);
    end

    // Toolbar & Menus:
    curwin = gcf().figure_id;
    toolbarIni = gcf().toolbar_visible;
    gcf().toolbar_visible = "off";
    shh_old = get(0).showhiddenhandles
    set(get(0), "showhiddenhandles","on")
    ch = gcf().children
    tmp = ch.type=="uimenu"
    uimenus_visible_old = ch(tmp).visible   // to restore when quitting edit_curv
    ch(tmp).visible = "off"
    set(get(0), "showhiddenhandles", shh_old)
    menu_d = ["Load", "Save", "Clear", "Reframe", "Bounds"]
    menu_e = ["Ok","Undo (Ctrl-Z)","Redo (Ctrl-Y)","Abort"]
    menus  = list(["Control","Data"],menu_e,menu_d)
    [w, rpar] = ("menus(2)(", ")")
    Control = w(ones(menu_e))+string(1:size(menu_e,"*")) + rpar(ones(menu_e))
    w = "menus(3)("
    Data = w(ones(menu_d))+string(1:size(menu_d,"*")) + rpar(ones(menu_d))
    execstr("Control_" + string(curwin) + "=Control");
    execstr("Data_" + string(curwin) + "=Data");
    if ownFigure then
        menubar(curwin, menus)
    else
        names = menus(1)
        for k = 1:size(names,"*")
            addmenu(curwin, names(k), menus(k+1), list(0, names(k)))
        end
    end

    // Set the current figure and axes
    edit_curv_figure = gcf();
    figure_name_old = edit_curv_figure.figure_name;
    edit_curv_figure.figure_name = "edit_curv";

    edit_curv_axes = gca();
    axes_old_data_bounds = edit_curv_axes.data_bounds
    axes_old_axes_visible = edit_curv_axes.axes_visible
    axes_old_grid = edit_curv_axes.grid
    axes_old_grid_position = edit_curv_axes.grid_position
    axes_old_title = edit_curv_axes.title.text
    axes_old_xlabel = edit_curv_axes.x_label.text
    axes_old_ylabel = edit_curv_axes.y_label.text

    edit_curv_axes.data_bounds  = [rect(1),rect(2);rect(3),rect(4)]
    edit_curv_axes.axes_visible = "on";
    edit_curv_axes.grid = [4 4];
    edit_curv_axes.grid_position = "foreground";
    if tit <> [] then
        xtitle(tit(1),tit(2),tit(3))
    end
    if ~isdef("hdl","l")
        xpoly(x, y);    // possibly with []
        hdl = gce();
        old_userdata = []
    else
        old_thickness  = hdl.thickness
        old_mark_mode  = hdl.mark_mode
        old_mark_style = hdl.mark_style
        old_mark_size  = hdl.mark_size
        old_userdata   = hdl.userdata
    end
//  [lineStyle, lineColor, lineThickness, mark_style] = 
    if isnan(lineStyle), lineStyle = hdl.line_style, end
    if isnan(lineColor), lineColor = hdl.foreground, end
    if isnan(lineThickness), lineThickness = 2, end
    if isnan(mark_style), mark_style = 1, end     // "+"
    hdl.line_style = lineStyle
    hdl.foreground = lineColor
    hdl.thickness = lineThickness
    hdl.mark_mode = "on"
    hdl.mark_style = mark_style
    hdl.mark_size = 2

    // Initialize the historization for undo/redo actions
    [xInit, yInit] = (x,y);
    hdl.userdata = list([x y])
    iHistory = 1;   // index in history of actions
    
    eps = 0.01      // accuracy for point clicking detection
    symbsiz = 0.2

    // ---------
    // MAIN LOOP
    // ---------
    while %t then
        [n1,n2] = size(x);
        npt = n1*n2 ;

        [btn,xc,yc,win,Cmenu] = get_click();

        c1 = [xc,yc];
        if btn==1025     then Cmenu="Redo (Ctrl-Y)", end
        if btn==1026     then Cmenu="Undo (Ctrl-Z)", end
        if Cmenu=="Quit" then Cmenu="Abort",end
        if Cmenu==[]     then Cmenu="edit",end
        if Cmenu=="Exit" then Cmenu="Ok",end

        select Cmenu
        case "Ok" then    //    -- ok menu
            rect = matrix(edit_curv_axes.data_bounds',1,4);
            lineStyles = [hdl.line_style, hdl.foreground, ..
                          hdl.thickness,  hdl.mark_style];
            gc   = list(rect, ticksNumb, lineStyles);
            if ownFigure
                delete(edit_curv_figure)
            else
                set("hdl", hdl)
                restoreFigure()
            end
            return

        case "Abort" then //    -- abort menu
            x = xInit
            y = yInit
            if ownFigure
                delete(edit_curv_figure)
            else
                restoreFigure()
            end
            ok = %f
            return

        case "XClose" then //** the user manually closes the win
            x = xInit
            y = yInit
            ok = %f;
            return

        case "Undo (Ctrl-Z)" then
            if iHistory > 1
                iHistory = iHistory - 1
                tmp = hdl.userdata(iHistory)
                [x, y] = (tmp(:,1), tmp(:,2))
            else
                [x, y] = (xInit, yInit)
            end
            hdl.data = [x y];

        case "Redo (Ctrl-Y)" then
            if iHistory < length(hdl.userdata)
                iHistory = iHistory + 1
                tmp = hdl.userdata(iHistory)
                [x, y] = (tmp(:,1), tmp(:,2))
                hdl.data = [x y];
            end

        case "Reframe"
            ierr = execstr("replot()", "errcatch"); // Catch errors to avoid to break loop
            if ierr <> 0 then
                msg = lasterror();
                disp(msg)
            end

        case "Bounds" then
            while %t
                [ok,xmn1,xmx1,ymn1,ymx1]=getvalue(_("Please input new limits"),..
                ["xmin"; "xmax"; "ymin"; "ymax"],..
                list("vec",1, "vec",1, "vec",1, "vec",1),..
                string([xmn; xmx; ymn; ymx]))
                if ~ok then break,end
                if xmn1 > xmx1 | ymn1 > ymx1 then
                    messagebox(_("Limits are not acceptable."),"modal");
                else
                    xmn = xmn1;
                    xmx = xmx1;
                    ymn = ymn1;
                    ymx = ymx1;
                    break
                end
            end
            if ok then
                dx = xmx - xmn;
				dy = ymx - ymn
                if dx==0 then dx = max(xmx/2,1), xmn = xmn-dx/10; xmx = xmx+dx/10; end
                if dy==0 then dy = max(ymx/2,1), ymn = ymn-dy/5;  ymx = ymx+dy/10; end
                rect=[xmn, ymn, xmx, ymx];
                edit_curv_axes.data_bounds=[rect(1), rect(2); rect(3), rect(4)]
            end

        case "Clear" then
            hdl.data = []
            [x, y] = ([],[])
            iHistory = addToHistory(x, y)

        case "Load" then
            [x,y]=readxy()
            mx=min(prod(size(x)), prod(size(y)))
            if mx<>0 then
                xmx = max(x); xmn = min(x)
                ymx = max(y); ymn = min(y)
                dx = xmx - xmn;
				dy = ymx - ymn

                if dx==0 then dx = max(xmx/2,1), xmn = xmn-dx/10;xmx = xmx+dx/10; end
                if dy==0 then dy = max(ymx/2,1), ymn = ymn-dy/5; ymx = ymx+dy/10; end
            else
                xmn = 0; ymn = 0; xmx = 1; ymx = 1; dx = 1; dy = 1
            end
            rect=[xmn, ymn, xmx, ymx];
            edit_curv_axes.data_bounds=[rect(1),rect(2);rect(3),rect(4)]
            if x <> [] & y <> [] then
                hdl.data = [x y];
            else
                hdl.data = []
                [x, y] = ([], [])
            end

        case "Save" then
            savexy(x,y)

        case "edit" then
            npt = size(x, "*")
            if npt<>0 then
                dist=((x-ones(npt,1)*c1(1))/dx).^2+((y-ones(npt,1)*c1(2))/dy).^2
                [m,k]=min(dist);
                m = sqrt(m)
            else
                m=3*eps
            end
            if m < eps then                 //on deplace le point
                xs=x; ys=y
                [x,y] = movept(x, y)
                iHistory = addToHistory(x,y)
            else
                if add then
                    xs=x; ys=y                  //on rajoute un point de cassure
                    [x,y] = addpt(c1,x,y)
                    hdl.data = [x y];
                    iHistory = addToHistory(x,y)
                end
            end
        end
    end
endfunction


function [btn,xc,yc,win,Cmenu] = get_click(flag)
    //** 05/01/09 : update for Scilab 5.1: (close code is now -1000)

    if ~or(winsid()==curwin) then
        Cmenu = "Quit";
        return        ;
    end

    if argn(2) == 1 then
        [btn, xc, yc, win, str] = xclick(flag);
    else
        [btn, xc, yc, win, str] = xclick();
    end

    if btn == -1000 then //** user close the window [X]
        if win == curwin then
            Cmenu = "XClose";
        else
            Cmenu = "Open/Set";
        end
        return ;
    end

    if btn == -2 then //** user select a dynamic menu
        xc = 0; yc = 0;
        execstr("Cmenu=" + part(str, 9:length(str) - 1) );
        execstr("Cmenu=" + Cmenu);
        return;
    end

    Cmenu = [];
endfunction


function [x,y] = addpt(c1,x,y)
    // permet de rajouter un point de cassure
    hdl;
    // Curve's initialization
    if x==[] then
        [x, y] = (c1(1), c1(2))
        return
    end

    // Point insertion in existing curve
    npt = prod(size(x))
    c1 = c1'
    // recherche des intervalles en x contenant l'abscisse designee
    kk = []
    if npt > 1 then
        kk = find((x(1:npt-1)-c1(1)*ones(x(1:npt-1)))..
                .*(x(2:npt)-c1(1)*ones(x(2:npt)))<=0)
    end
    if  kk <> [] then
        //    recherche du segment sur lequel on a designé un point
        [pp, d, i] = ([], [], 0)
        for k = kk
            i = i+1
            pr = projaff(x(k:k+1),y(k:k+1),c1)
            if (x(k)-pr(1))*(x(k+1)-pr(1)) <= 0 then
                pp = [pp pr]
                d1 = rect(3) - rect(1)
                d2 = rect(4) - rect(2)
                d = [d norm([d1;d2].\(pr-c1))]
            end
        end
        if d <> [] then
            [m,i] = min(d)
            if m < eps
                k = kk(i)
                pp = pp(:,i)
                x = x([1:k k:npt]);
                x(k+1) = pp(1);
                y = y([1:k k:npt]);
                y(k+1) = pp(2);
                return
            end
        end
    end
    d1 = rect(3) - rect(1)
    d2 = rect(4) - rect(2)
    if norm([d1;d2].\([x(1);y(1)]-c1)) < norm([d1;d2].\([x(npt);y(npt)]-c1)) then
        //  -- mise a jour de x et y
        x(2:npt+1) = x
        x(1) = c1(1)
        y(2:npt+1) = y
        y(1) = c1(2)
    else
        //  -- mise a jour de x et y
        x(npt+1) = c1(1)
        y(npt+1) = c1(2)
    end
endfunction

function [x,y] = movept(x,y)
    //on bouge un point existant
    hdl;
    rep(3) = -1
    while rep(3)==-1 do
        rep = xgetmouse();
        xc = rep(1);
        yc = rep(2);
        if ~modx then xc = x(k); end
        if ~mody then yc = y(k); end
        x(k) = xc;
        y(k) = yc;
        hdl.data = [x y];
        c2 = [xc; yc]
    end
    // "SUPPR has been pressed => we delete the point
    if rep(3)==127 & del
        hdl.data(k,:) = [];
        x(k) = [];
        y(k) = [];
        hdl.data = [x y];
    end
endfunction

function iHistory = addToHistory(x,y)
    iHistory = iHistory + 1
    hdl;
    hdl.userdata(iHistory) = [x y]
    L = length(hdl.userdata)
    if L > iHistory
        // We cut the tail coming from undo actions
        for i = iHistory+1:L
            hdl.userdata(i) = null()
        end
    end
endfunction

function [x,y] = readxy()

    function xy = findPolyline(children)
        xy = [];
        for i = 1:length(children)
            select children(i).type,
            case "Polyline" then
                xy = children(i).data;
                return
            case "Axes" then
                xy = findPolyline(children(i).children);
                return
            case "Compound" then
                xy = findPolyline(children(i).children);
                return
            end
        end
    endfunction

    x = x
    y = y
    fn = uigetfile(["*.scg";"*.sod";"*.xy"], "", _("Select a file to load"));
    if fn <> "" then
        [pth, fnm, ext] = fileparts(fn);
        flname = fnm + ext;

        select ext
        case ".scg" then
            loaded_figure=figure("visible", "off");
            if execstr("xload(fn, loaded_figure.figure_id)","errcatch") == 0 then
                loaded_figure.visible = "off";
                scf(edit_curv_figure);
                xy = findPolyline(loaded_figure.children);
                delete(loaded_figure);
                if xy <> [] then
                    [x, y] = (xy(:,1), xy(:,2))
                else
                    msg = _("%s: The file ''%s'' does not contains any ''Polyline'' graphic entity.\n")
                    messagebox(msprintf(msg, "edit_curve", flname))
                    return
                end
            else
                msg = _("%s: Cannot open file ''%s'' for reading.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal")
                return
            end
        case ".xy" then
            if execstr("xy = read(fn,-1,2)","errcatch") == 0 then
                [x, y] = (xy(:,1), xy(:,2))
            else
                msg = _("%s: Cannot open file ''%s'' for reading.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal")
                return
            end
        case ".sod" then
            if execstr("load(fn)","errcatch") == 0 then
                [x, y] = (xy(:,1), xy(:,2))
            else
                msg = _("%s: Cannot open file ''%s'' for reading.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal")
                return
            end
        else
            messagebox(_("Error in file format."), "modal");
            return
        end
    end
endfunction


function savexy(x,y)
    fn = uiputfile(["*.sod";"*.xy"], "", _("Select a file to write"));
    if fn <> "" then
        [pth, fnm, ext] = fileparts(fn);


        flname = fnm + ext;
        xy = [x y];
        fil = fn;

        select ext
        case "" then
            fil = fil + ".xy";
            ext = ".xy";
        case ".xy" then
            // empty case fil = fn
        case ".sod" then
            // empty case fil = fn
        else
            fil = pth + fnm + ".xy";
            ext = ".xy";
        end

        select ext
        case ".sod" then
            if execstr("save(fil,""xy"")","errcatch")<>0 then
                msg = _("%s: The file ''%s'' cannot be written.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        case ".xy" then
            isErr = execstr("write(fil,xy)","errcatch")
            if isErr == 240 then
                mdelete(fil); // write cannot overwrite an existing file
                isErr = execstr("write(fil,xy)","errcatch");
            end
            if isErr <> 0 then
                msg = _("%s: The file ''%s'' cannot be written.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        end
    end
endfunction

// ------------------------------------------------------------------

function restoreFigure()
    gcf().figure_name = figure_name_old;
    gcf().toolbar_visible = toolbarIni;
    // Menus
    set(get(0), "showhiddenhandles","on")
    tmp = gcf().children
    tmp = tmp(tmp.type=="uimenu")
    delete(tmp(1:2))
    tmp = gcf().children
    tmp = tmp(tmp.type=="uimenu")
    tmp.visible = uimenus_visible_old
    set(get(0), "showhiddenhandles", shh_old)
    
    // Axes
    edit_curv_axes
    if hadChildren then
        edit_curv_axes.data_bounds = axes_old_data_bounds
        edit_curv_axes.axes_visible = axes_old_axes_visible
        edit_curv_axes.grid = axes_old_grid
        edit_curv_axes.grid_position = axes_old_grid_position
    end
    edit_curv_axes.title.text = axes_old_title
    edit_curv_axes.x_label.text = axes_old_xlabel
    edit_curv_axes.y_label.text = axes_old_ylabel
    
    // Curve styles
    hdl
    if isdef("old_thickness")
        hdl.thickness  = old_thickness
        hdl.mark_mode  = old_mark_mode
        hdl.mark_style = old_mark_style
        hdl.mark_size  = old_mark_size
    end
    hdl.userdata = old_userdata
endfunction
