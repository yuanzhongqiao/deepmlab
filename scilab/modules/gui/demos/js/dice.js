// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

$(document).ready(() => {
    $("#help").click(() => {
        toScilab({type: "help"});
    })

    $("#history").click(() => {
        toggleHistory();
    });

    $("#multiplier").click(() => {
        switch ($("#multiplier").data("mult")) {
        case 0:
            $("#multiplier").data("mult", 1);
            $("#multiplier").text("x 10");
            break;
        case 1:
            $("#multiplier").data("mult", 2);
            $("#multiplier").text("x 100");
            break;
        case 2:
            $("#multiplier").data("mult", 0);
            $("#multiplier").text("x 1");
            break;
        }

        updateDice();
    });

    $("#roll").click(() => {
        roll();
    })

    $(".dice > button").click((e) => {
        $(e.currentTarget).prop("disabled", true);
        let dice = $(e.currentTarget).parents(".dice").index();
        let mult = Math.pow(10, $("#multiplier").data("mult"));
        toScilab({type: "buy", data: {dice: dice + 1, mult: mult}}, (res) => {
            updateGui(res);
        })
    })

    setTimeout(() => {
        toScilab({type: "init"}, (res) => {
            updateGui(res);
        });
    }, 1000)

    $("#multiplier").data("mult", 0); // x1
});

function fromScilab(msg) {
    if (msg.type == "config") {
        updateGui(msg.data);
    }
}

function showDice(x) {

    let dice = $(`#dice-${x+1}`);
    if (dice.hasClass("dice-show")) return;

    $(".grower").show().width("110px");

    setTimeout(() => {
        $(".grower").hide().width("0px");
        dice.addClass("dice-show");
        setTimeout(() => {
            dice.css("transform", "scale(1)");
        }, 500);
    }, 500);
}

function showWelcome() {
    $( "#dialog-message" ).dialog({
        modal: true,
        draggable: false,
        buttons: {
            Ok: function() {
                $( this ).dialog( "close" );
            }
        }
    });
}

function updateGui(c) {
    $(".dices").data("config", c);

    $("#idle_total").text(`${c.total}`)
    $(".dices").data("total", c.total);

    $("#roll_msg").text(c.msg[0]);
    $("#roll_gain").text(c.msg[1]);

    let dices = c.dices;
    if (dices.length == undefined) {
        dices = [dices];
    }

    dices.forEach((d, i) => {
        let dice = $(`#dice-${i+1}`);

        if (d.length !== undefined) {
            d = d[0];
        }

        dice.data("dice", d);
        if (c.init) {
            dice.addClass("dice-show first");
        } else {
            showDice(i);
        }
    })

    updateDice();
    updateHistory(c.history);
}

function updateDice() {
    $(".dice").each((i, dice) => {
        let d = $(dice).data("dice");
        if (d != null && d != undefined) {
            $(dice).find(".image").attr("src", `images/dice-${d.value}.png`);
            $(dice).find(".score").text(`${d.score}`)
            $(dice).find(".mult > .value").text(`${d.mult}`)
            $(dice).find(".level > .value").text(`${d.level}`)

            let total = $(".dices").data("total");
            let cost = d.cost[$("#multiplier").data("mult")]
            $(dice).find(".buy > span").text(`${cost}`);
            $(dice).find(".buy > span").removeClass("good bad");
            $(dice).find(".image").css("visibility", d.level > 0 ? "visible" : "hidden");

            if (d.level == 100) {
                $(dice).find(".buy > span").text("MAX");
                $(dice).find(".buy > span").addClass("bad");
                $(dice).find(".buy").prop("disabled", true)
            } else if (cost <= total) {
                $(dice).find(".buy > span").addClass("good");
                $(dice).find(".buy").prop("disabled", false)
                $(dice).find(".buy > .progress").css("width", `0%`);
            } else {
                $(dice).find(".buy > span").addClass("bad");
                $(dice).find(".buy").prop("disabled", true)
                $(dice).find(".buy > .progress").css("width", `${total/cost * 100}%`);
            }
        }
    })
}

function roll() {
    stopAutoroll();
    $("#roll").prop("disabled", true);
    $("#roll").data("res", null);
    toScilab({type: "roll", time: Date.now()}, (res) => {
        $("#roll").data("res", res);
    });

    loop = 5;
    //anim dices
    for (var i = 0; i < loop; ++i) {
        setTimeout((idx) => {
            $(".dices > .dice.dice-show").each((_, dice) => {
                let d = Math.floor(Math.random() * 6) + 1;
                $(dice).find(".image").attr("src", `images/dice-${d}.png`);
            })

            if (idx == loop - 1) {
                wait = setInterval(() => {
                    if ($("#roll").data("res") != null) {
                        clearInterval(wait);
                        updateGui($("#roll").data("res"));
                        $("#roll").prop("disabled", false);
                        if ($("#dice-1").data("dice").level > 1) {
                            autoroll();
                        }
                    }
                }, 10);
            }
        }, (i+1) * 100, i);
    }
}

function autoroll() {
    $("#roll").data("timer", 0);
    let autoroll = setInterval(() => {
        let t = $("#roll").data("timer");
        if (t + 100 >= 5000) {
            roll();
        } else {
            t += 100;
            let ratio = t/5000;
            $("#roll > .progress").css("width", `${ratio*100}%`);
            $("#roll > .progress").css("background-color", getRollColor(ratio));
            $("#roll").data("timer", t);
        }
    }, 100);

    $("#roll").data("id", autoroll);
}

function stopAutoroll() {
    let autoroll = $("#roll").data("id");
    if (autoroll) {
        $("#roll > .progress").css("width", `0%`);
        $("#roll > .progress").css("background-color", "#FFFFFF");
        clearInterval(autoroll);
    }
}

function getRollColor(ratio) {
    colors = [
        "#DD776D", "#E0816D", "#E1876B",
        "#E4916A", "#E79A68", "#E9A167",
        "#ECAB67", "#E6AD61", "#E9B761",
        "#F3C463", "#F4CD61", "#E1C964",
        "#D3C76A", "#C4C46D", "#B0BD6D",
        "#A4C073", "#94BD77", "#84BA7A",
        "#73B77D", "#63B681", "#57BA8A"
    ]

    return colors[Math.floor(ratio * colors.length)]
}

function toggleHistory() {
    let show = $("#history-frame").is(":visible") == false;

    toScilab({type: "history", show: show}, (data) => {
        console.log("history", data)
        if (data.show) {
            $("#history-frame").css("display", "block")
        } else {
            $("#history-frame").css("display", "none")
        }
    })
}

function updateHistory(history) {
    if (history.length == undefined) {
        history = [[history]];
    }

    let l = $("#history-list");
    l.empty();
    history.forEach(h => {
        h = h[0];
        let dices = h.dices;
        if (dices.length == undefined) {
            dices = [dices];
        }

        let str = dices.join(" - ");
        str += " => " + h.gain;
        l.append($("<li>").text(str));
    });

    $("#history-frame").scrollTop(l.height());
}