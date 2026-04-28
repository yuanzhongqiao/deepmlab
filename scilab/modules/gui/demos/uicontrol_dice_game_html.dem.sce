// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function dice_game_html()
    close(100002)
    // Create a figure
    f = figure(...
        "figure_name", "Game of Dice",...
        "figure_id", 100002, ...
        "infobar_visible", "off",...
        "toolbar_visible", "off",...
        "dockable", "off",...
        "menubar", "none",...
        "default_axes", "off", ...
        "position", [10 250 800 600], ...
        "resize", "off",...
        "layout", "border", ...
        "tag", "dice_html");

    fr = uicontrol(f, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "layout", "border");

    uicontrol(fr, ...
        "style", "browser", ...
        "debug", "on", ...
        "string", SCI + "/modules/gui/demos/dice.html", ...
        "callback", "cbDice", ...
        "tag", "dice");
end

function cbDice(msg, cb)

    if msg == "loaded" then
        initConfig();
        sendConfig(%t);
        return;
    end

    select msg.type
    case "roll"
        roll();
    case "buy"
        buy(msg.data);
    case "history"
        pos = get("dice_html", "position");

        if msg.show then
            pos(3) = 1000;
        else
            pos(3) = 800;
        end

        set("dice_html", "position", pos);
        cb(struct("show", msg.show, "history", []));
    case "help"
        dice_help();
    end
endfunction

function initConfig()
    idle = [];
    idle.cumul_gain = 0;
    idle.total = 0;
    idle.last_gain = 0;
    idle.autoroll = %f;
    idle.history = [];
    idle.dice = 1;
    idle.dices = [];
    idle.msg = ["" ""];
    idle.dices($ + 1) = struct(...
        "base", 10, ...
        "cost", 1.08, ...
        "multCoef", 1, ...
        "score", 0, ...
        "value", 1, ...
        "level", 1);

    idle.dices($ + 1) = struct(...
        "base", 100, ...
        "cost", 1.08, ...
        "multCoef", 3, ...
        "score", 0, ...
        "value", 1, ...
        "level", 0);

    idle.dices($ + 1) = struct(...
        "base", 1000, ...
        "cost", 1.08, ...
        "multCoef", 9, ...
        "score", 0, ...
        "value", 1, ...
        "level", 0);

    idle.dices($ + 1) = struct(...
        "base", 10000, ...
        "cost", 1.08, ...
        "multCoef", 27, ...
        "score", 0, ...
        "value", 1, ...
        "level", 0);

    idle.dices($ + 1) = struct(...
        "base", 100000, ...
        "cost", 1.08, ...
        "multCoef", 81, ...
        "score", 0, ...
        "value", 1, ...
        "level", 0);

    set("dice", "userdata", idle);
endfunction

function data = getConfig(init)
    idle = get("dice", "userdata");

    data = [];
    data.total = idle.total;
    data.gain = idle.last_gain;
    data.msg = idle.msg;
    data.history = idle.history;
    data.init = init;

    data.dices = [];
    for i = 1:idle.dice
        d = idle.dices(i);
        dice = [];

        dice.cost = [upgrade_cost(d, 1), upgrade_cost(d, 10), upgrade_cost(d, 100)];
        dice.level = d.level;
        dice.value = d.value;
        dice.mult = d.level * d.multCoef;
        dice.score = d.score;
        data.dices(i) = dice;
    end
endfunction

function sendConfig(init)
    idle = getConfig(init);
    msg = [];
    msg.type = "config";
    msg.data = idle;
    set("dice", "data", msg);
endfunction

function c = upgrade_cost(dice, n)
    c = sum(round(dice.base * dice.cost ** (dice.level : min(dice.level + n-1, 100))));
endfunction

function roll()
    idle = get("dice", "userdata");

    n = idle.dice;
    if idle.dices(n).level == 0 then
        n = n - 1;
    end

    r = int(rand(1, n) * 6) + 1;
    [gain, msg] = roll_gain(r);

    s = 0;
    for i = 1:n
        s1 = idle.dices(i).level * idle.dices(i).multCoef * r(i);
        idle.dices(i).value = r(i);
        idle.dices(i).score = s1;
        s = s + s1;
    end

    total = s * gain;
    idle.cumul_gain = idle.cumul_gain + total;
    idle.total = idle.total + total;
    idle.msg = [msg, sprintf("%s x %d = %s", formatEng(s), gain, formatEng(total))];

    idle.history($+1) = struct("hand", msg, "dices", r, "gain", total);
    idle.history(1:$-100) = []; //max 100 results
    set("dice", "userdata", idle);

    cb(getConfig(%f));
endfunction

function [g, msg] = roll_gain(r)
    g = 1;
    rsort = gsort(r, "c", "i");
    [a, b, ?, c] = unique(rsort);
    c = gsort(c);
    s = length(rsort);

    if s >= 5 && c(1) == 5 then
        g = 500;
        msg = "FIVE !"
    elseif s >= 4 && c(1) == 4 then
        g = 100;
        msg = "Four"
    elseif s == 5 && c(1) == 3 && c(2) == 2 then
        g = 50;
        msg = "Fullhouse"
    elseif s == 5 && (and(rsort == 1:5) || and(rsort == 2:6)) then
        g = 40;
        msg = "Straight"
    elseif s >= 3 && c(1) == 3 then
        g = 20;
        msg = "Three"
    elseif s >= 4 && c(1) == 2 && c(2) == 2 then
        g = 10;
        msg = "Two pair"
    elseif s >= 2 && c(1) == 2 then
        g = 5;
        msg = "One pair"
    else
        g = 1;
        msg = ""
    end

    msg = sprintf("%s x%d", msg, g);
endfunction

function buy(data)
    idle = get("dice", "userdata");

    cost = upgrade_cost(idle.dices(data.dice), data.mult);
    idle.total = idle.total - cost;

    dice = idle.dices(data.dice);
    dice.level = min(dice.level + data.mult, 100);
    dice.mult = dice.level * dice.multCoef;
    idle.dices(data.dice) = dice;

    if data.dice == idle.dice && data.dice < 5 && dice.level >= 10 then
        idle.dice = idle.dice + 1;
    end

    set("dice", "userdata", idle);
    cb(getConfig(%f));
endfunction

function str = formatEng(x)
    if x == 0 then
        str = "0";
        return;
    end

    e = 6 * floor(log10(x) / 6);
    if e then
        y = x / (10 ^ e);
        str = sprintf("%.3fe%d", y, e)
    else
        str = sprintf("%0.f", x);
    end
endfunction

function dice_help()
    msg = ["Welcome in ""Game of Dice""";
            ""
            "This demo is based on `browser uicontrol`";
            "To access the source code: [crtl + shift + i] or openDevtools(get(""dice""))."
            ""
            "Goal: ";
            "-  Reach level 100 for each of the 5 dices";
            ""
            "Info: ";
            "After the first purchase, the game can roll alone.";
            "but you can anticipate the draw by clicking on ""Roll !""";
            ];

    messagebox(msg, "Game of Dice", "info", "modal");
endfunction

dice_game_html()
