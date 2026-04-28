// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 8812 -->
//
// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8812
//
// <-- Short Description -->
// For the multi-selection of a listbox, (max - min) must be greather than 1.

function frame_initialization()
    uicontrol(f, "style", "frame", ...
            "position", [10 60 300 250], ...
            "backgroundcolor", [0.6 0.6 0.6]);
endfunction

function list_box(data_variables)
    // Listbox of available variable         
    var_ListBox = uicontrol(f, "style", "listbox", ... 
            "position", [20, 120, 280, 170], ...
            "backgroundcolor", [1 1 1], ...
            "ForegroundColor", [0.55 0.27 0.07], ...
            "tag", "list_box", ...
            "callback", "file_data=getDmpVar(file_data)");
    set(var_ListBox, "string", data_variables); //update variable list box
endfunction

function file_data = getDmpVar(file_data)
    // select Dump File Variables
    // get returns an array of selected values
     file_data.dmpVar = get(gcbo, "value");
     disp(file_data.dmpVar)
endfunction

function plot_data()
    uicontrol(f, "style", "pushbutton", ...
            "position", [ 35 10 80 40], ...
            "string", "PLOT", ...
            "callback", "plot_DmpVars(file_data)", ...
            "backgroundcolor", [1 1 0], ...
            "ForegroundColor", [0 0 1], ...
            "Relief", "raised", ...
            "FontSize", 20); 
endfunction

function plot_DmpVars(file_data)

    dmpVar = file_data.dmpVar;

    if length(dmpVar) ~= 2 then 
        messagebox("You must select at least 2 variables to create a subplot");
    else
        data1 = file_data.data(dmpVar(1),:)
        data2 = file_data.data(dmpVar(2),:);
        clf(2);
        scf(2); 
        subplot(211); 
        plot(data1);
        f = gcf();
        f.figure_size=[950,850];
        a = gca(); 
        a.grid = [1 1 -1];
        a.y_label.text = file_data.variables(dmpVar(1));
        subplot(212); 
        plot(data2); 
        b = gca();
        b.x_label.text="time (sec)";
        b.y_label.text=file_data.variables(dmpVar(2));
        b.grid=[1 1 -1];
    end
endfunction

f = figure(1, "position", [30,200,320,300], "backgroundcolor", [0.4 0.7 0.7], "menubar_visible", "off");


file_data = struct("variables", [], "data", [], "dmpVar", []);
varStr = ["sin(t)" "cos(t)" "tan(t)" "exp^-t" "x^3" "x" "-x" "x^2"];

t = linspace(0, 10);
d(1, :) = sin(t);
d(2, :) = cos(t);
d(3, :) = tan(t);
d(4, :) = exp(t);
d(5, :) = t.^3;
d(6, :) = t;
d(7, :) = -t;
d(8, :) = t.^2;

file_data.data = d;
file_data.variables = varStr;
frame_initialization();
list_box(file_data.variables);
plot_data();

assert_checkequal(get("list_box", "max"), 1);
assert_checkequal(get("list_box", "min"), 0);
refMsg = msprintf(_("(Max - Min) must be greater than 1 to allow the multiple selection.\n"));
assert_checkerror("set(''list_box'', ''value'', [1 3])", refMsg);
assert_checkequal(get("list_box", "value"), []);

set("list_box", "max", 2);
assert_checkequal(get("list_box", "max"), 2);
assert_checkequal(get("list_box", "min"), 0);
set("list_box", "value", [1 3]);
assert_checkequal(get("list_box", "value"), [1 3]);
assert_checkequal(file_data.dmpVar, []);
file_data.dmpVar = get("list_box", "value");
assert_checkequal(file_data.dmpVar, [1 3]);

plot_DmpVars(file_data);
// check if you have two graph [sin(t) and tan(t)]

val = [2:2:8];
set("list_box", "max", 4);
set("list_box", "value", val);
assert_checkequal(get("list_box", "value"), val);
file_data.dmpVar = get("list_box", "value");
assert_checkequal(file_data.dmpVar, val);

// check if the error message displays
//plot_DmpVars(file_data);