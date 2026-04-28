// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

$(document).ready(() => {
    $("#gridx, #gridy").change(function() {
        checkInput($(this));
        let x = parseInt($("#gridx").val());
        let y = parseInt($("#gridy").val());

        $("#startx").val(Math.min($("#startx").val(), x));
        $("#starty").val(Math.min($("#starty").val(), y));
        $("#finishx").val(Math.min($("#finishx").val(), x));
        $("#finishy").val(Math.min($("#finishy").val(), y));
        updateStartAndFinish();
        createGrid();
    })

    $("#startx, #starty, #finishx, #finishy").change(function() {
        checkInput($(this));
        updateStartAndFinish();
        redraw();
    })

    $("#finishrandom").click(function() {
        randomPos("finish");
    });

    $("#startrandom").click(function() {
        randomPos("start");
    });

    $("#compute").click(() => {
        compute(false);
    });

    $("#clear").click(() => {
        clearGUI();
    })

    $(".center").click((e) => {
        changeCellCost(e.offsetX, e.offsetY, 1);
        e.preventDefault();
    });

    $(".center").on("contextmenu", (e) => {
        changeCellCost(e.offsetX, e.offsetY, -1);
        e.preventDefault();
    });

    $("#help").click(() => {
        showHelp();
    });

    $("#cellrandom").click(() => {
        createGrid();
    });

    //init
    $("#main").data("colors", ["#f4e784", "#f4cc85", "#f3b086", "#f39587", "#f37a87", "#f25e88", "#f24389"]);
    $("#main").data("start", [parseInt($("#startx").val()), parseInt($("#starty").val())]);
    $("#main").data("finish", [parseInt($("#finishx").val()), parseInt($("#finishy").val())]);
    updateGUI();
    createGrid();
    compute(true);

});

function showHelp() {
    toScilab({type: "help"});
}

function clearGUI() {
    let data = $("#main").data();
    let rows = data.grid[0];
    let cols = data.grid[1];
    let costs = new Array(rows).fill(0).map(() => new Array(cols).fill(0));
    $("#main").data("costs", costs);

    redraw();
}

function changeCellCost(x, y, offset) {
    let data = $("#main").data();
    let j = (x - data.startX) / (data.cellSize + 1);
    let i = (y - data.startY) / (data.cellSize + 1);
    i = Math.floor(i);
    j = Math.floor(j);

    if (i < 0 || i >= data.grid[0]) return;
    if (j < 0 || j >= data.grid[1]) return;

    let max = $(".colors .color").length;
    data.costs[i][j] =  ((data.costs[i][j] + offset) % max + max) % max;
    $("#main").data(data)
    redraw();
}

function updateGUI() {
    let colors = $("#main").data("colors");
    colors.forEach((c, i) => {
        addColorFrame(i+1, c);
    });

    $(".colors").append($("<li>")
        .addClass("color-frame")
        .append($("<div>")
            .addClass("color")
            .css("background-color", "black")
        )
        .append($("<span>")
            .addClass("cost")
            .html("&infin;")
        )
    )
}

function addColorFrame(value, color) {
    $(".colors").append($("<li>")
        .addClass("color-frame")
        .append($("<div>")
            .addClass("color")
            .css("background-color", color)
        )
        .append($("<input>")
            .addClass("cost")
            .attr("type", "number")
            .attr("value", `${value}`)
            .attr("min", "1")
            .attr("max", "100")
        )
    )
}

function randomPos(e) {
    let xmax = parseInt($(`#${e}x`).attr("max"));
    let ymax = parseInt($(`#${e}y`).attr("max"));

    let newx = Math.floor(Math.random() * xmax) + 1;
    let newy = Math.floor(Math.random() * ymax) + 1;
    $(`#${e}x`).val(`${newx}`);
    $(`#${e}y`).val(`${newy}`);
    updateStartAndFinish();
    redraw();
}

function checkInput(input) {
    let v = parseInt(input.val());
    let min = parseInt(input.attr("min"))
    let max = parseInt(input.attr("max"))
    if (isNaN(v)) {
        v = parseInt(input.attr("min"));
    }

    v = Math.max(min, v);
    v = Math.min(max, v);
    input.val(`${v}`)
}

function redraw() {
    let data = $("#main").data();
    let rows = data.grid[0];
    let cols = data.grid[1];
    let costs = data.costs;
    let start = data.start;
    let finish = data.finish;

    let w = $(".center").width();
    let h = $(".center").height();

    let startX = parseInt($("#startx").val());
    let startY = parseInt($("#starty").val());
    let finishX = parseInt($("#finishx").val());
    let finishY = parseInt($("#finishy").val());

    // even value
    w += w % 2;
    h += h % 2;

    //clear canvas
    let c = $(".canvas");
    c.attr("width", w);
    c.attr("height", h);
    let ctx = getContext();

    let cellW = Math.floor((w - 40) / cols);
    let cellH = Math.floor((h - 40) / rows);
    let cellSize = Math.min(cellW, cellH);
    cellSize -= cellSize % 2 == 0 ? 1 : 0; //always odd
    let totalW = cellSize * cols + cols - 1;
    let totalH = cellSize * rows + rows - 1;
    let pointX = (w - totalW) / 2;
    let pointY = (h - totalH) / 2;
    pointX = Math.floor(pointX);
    pointY = Math.floor(pointY);

    //border
    ctx.beginPath();
    ctx.lineWidth = 1;
    ctx.strokeStyle = "#000000";
    drawRect(ctx, pointX, pointY, totalW, totalH);
    ctx.stroke();

    //grid
    for (let i = 0; i < rows; ++i) {
        for (let j = 0; j < cols; ++j) {
            let x = j * cellSize + 1;
            let y = i * cellSize + 1;
            ctx.beginPath();
            ctx.lineWidth = 1;
            ctx.strokeStyle = "#FFFFFF";
            drawRect(ctx, x + pointX + j - 1, y + pointY + i - 1, cellSize, cellSize);
            ctx.stroke();

            let cost = costs[i][j];
            if ((i == startX - 1 && j == startY - 1) || (i == finishX - 1 && j == finishY - 1)) {
                ctx.fillStyle = "#ffffff";
            } else if (cost == 0) {
                ctx.fillStyle = "#000000";
            } else {
                ctx.fillStyle = data.colors[cost-1];
            }

            ctx.fillRect(x + pointX + j - 1, y + pointY + i - 1, cellSize, cellSize)

            if (i == start[0] - 1 && j == start[1] - 1) {
                drawImage(pointX + x + cellSize / 2 + j, pointY + y + cellSize / 2 + i, "start");
            }

            if (i == finish[0] - 1 && j == finish[1] - 1) {
                drawImage(pointX + x + cellSize / 2 + j, pointY + y + cellSize / 2 + i, "finish");
            }
        }
    }

    //save computed values
    $("#main").data("cellSize", cellSize);
    $("#main").data("startX", pointX);
    $("#main").data("startY", pointY);
}

function createGrid() {
    let rows = parseInt($("#gridx").val());
    let cols = parseInt($("#gridy").val());

    $("#main").data("grid", [rows, cols]);
    $("#startx").attr("max", rows);
    $("#starty").attr("max", cols);
    $("#finishx").attr("max", rows);
    $("#finishy").attr("max", cols);

    let costs = createRandom2D(rows, cols);
    let startX = parseInt($("#startx").val());
    let startY = parseInt($("#starty").val());
    let finishX = parseInt($("#finishx").val());
    let finishY = parseInt($("#finishy").val());
    costs[startX - 1][startY - 1] = 1;
    costs[finishX - 1][finishY -1] = 1;
    $("#main").data("costs", costs);
    redraw();
}

function updateStartAndFinish() {
    let startX = parseInt($("#startx").val());
    let startY = parseInt($("#starty").val());
    let finishX = parseInt($("#finishx").val());
    let finishY = parseInt($("#finishy").val());

    $("#main").data("start", [startX, startY]);
    $("#main").data("finish", [finishX, finishY]);
}

function drawImage(x, y, name) {
    let ctx = getContext();
    let img = new Image();
    img.onload = () => {
        ctx.drawImage(img, x - 12, y - 12, 24, 24);
    }
    img.src = `./images/${name}.png`;
}

function compute(retry) {
    let data = $("#main").data();
    let rows = data.grid[0];
    let cols = data.grid[1];

    let st = {};
    st.grid = data.grid;
    st.start = [parseInt($("#startx").val()), parseInt($("#starty").val())]
    st.finish = [parseInt($("#finishx").val()), parseInt($("#finishy").val())]
    st.map = [];
    st.costs = [];

    let defcosts = [];
    $(".colors li input").each(function() {defcosts.push(parseInt($(this).val()))});

    for (let i = 0; i < rows; ++i) {
        st.map[i] = [];
        st.costs[i] = [];
        for (let j = 0; j < cols; ++j) {
            let cost = data.costs[i][j];
            st.map[i][j] = cost != 0;
            st.costs[i][j] = cost != 0 ? defcosts[cost-1] : 0;
        }
    }

    st.map[st.start[0] - 1][st.start[1] - 1] = true;
    st.map[st.finish[0] - 1][st.finish[1] - 1] = true;

    toScilab({type: "compute", data: st}, (res) => {
        if (res.length == 0) {
            if (retry) {
                createGrid();
                compute(retry);
                console.log("retry");
            } else {
                alert("No path was found");
                return;
            }
        } else {
            drawPath(res);
        }
    })
}

function drawPath(res) {
    redraw();
    let ctx = getContext();

    //start
    drawEnd(res[0], res[1]);

    for (let i = 1; i < res.length -1; ++i) {
        drawStart(res[i-1], res[i]);
        drawEnd(res[i], res[i+1]);
    }

    //end
    drawStart(res[res.length-2], res[res.length-1]);
}

function drawStart(a, b) {
    let dir = getDirection(a, b);
    let data = $("#main").data();
    let startX = data.startX + data.cellSize * (b[1] - 0.5) + (a[1] - 1);
    let startY = data.startY + data.cellSize * (b[0] - 0.5) + (a[0] - 1);
    let endX = startX + (data.cellSize / 2 * -dir[1]);
    let endY = startY + (data.cellSize / 2 * -dir[0]);

    let ctx = getContext();

    ctx.beginPath();
    ctx.lineWidth = 2;
    ctx.strokeStyle = "blue";
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, endY);
    ctx.stroke();
}

function drawEnd(a, b) {
    let dir = getDirection(a, b);
    let data = $("#main").data();
    let startX = data.startX + data.cellSize * (a[1] - 0.5) + (a[1] - 1);
    let startY = data.startY + data.cellSize * (a[0] - 0.5) + (a[0] - 1);
    let endX = startX + (data.cellSize / 2 * dir[1]);
    let endY = startY + (data.cellSize / 2 * dir[0]);

    let ctx = getContext();

    ctx.beginPath();
    ctx.lineWidth = 2;
    ctx.strokeStyle = "blue";
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, endY);
    ctx.stroke();
}

function getDirection(a, b) {
    return [
        b[0] - a[0],
        b[1] - a[1]
    ];
}


/* cavans tools */
function drawRect(ctx, x, y, w, h) {
    ctx.moveTo(x - 0.5    , y - 0.5    );
    ctx.lineTo(x - 0.5    , y + 0.5 + h); //left
    ctx.lineTo(x + 0.5 + w, y + 0.5 + h); //bottom
    ctx.lineTo(x + 0.5 + w, y - 0.5    );//right
    ctx.lineTo(x - 0.5    , y - 0.5    );//top
}

function getContext() {
    return $(".canvas")[0].getContext("2d");
}

function createRandom2D(rows, cols) {
    return Array.from({ length: rows }, () =>
        Array.from({ length: cols }, () =>
            Math.floor(Math.random() * 8)  // entier aléatoire entre 0 et 7
        )
    );
}