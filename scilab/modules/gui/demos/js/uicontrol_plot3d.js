// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

$( document ).ready(() => {
    $("button").click(() => {
        toScilab({type: "init", data: ""});
    })

    $("#title").change(() => {
        toScilab({type: "update", data: getGuiValues()});
    })

    $(`input:not([type="range"])`).change(() => {
        toScilab({type: "update", data: getGuiValues()});
    })

    $(`input[type="range"]`).on('input', () => {
        toScilab({type: "updateonlyangle", data: getGuiValues()});
    })

    toScilab({type: "init", data: []})
});

function toScilab(msg) {
    Scilab({request: JSON.stringify(msg)})
}

function fromScilab(msg) {
    switch(msg.type) {
        case "update":
            updateGui(msg.data);
            break;
        default:
            console.log("not managed", data);
            break;
        }
}

function updateGui(data) {
    $("#title").val(data.title);
    $("#alpha").val(data.alpha);
    $("#theta").val(data.theta);

    $("input[type='radio']").prop("checked", false);
    switch (data.colormap) {
        case "Jet":
            var name = "cmjet";
            break;
        case "Hot":
            var name = "cmhot";
            break;
        case "Gray":
            var name = "cmgray";
            break;
        case "Parula":
            var name = "cmparula";
            break;
    }

    $(`#${name}`).prop("checked", true);

    $("#showtics").prop("checked", data.showtics);
    $("#showtitle").prop("checked", data.showtitle);
    $("#showlabels").prop("checked", data.showlabels);
    $("#showedges").prop("checked", data.showedges);

    $("#colorbackground").val(data.background);
    $("#coloraxes").val(data.axes);
}

function getGuiValues() {

    let checked = $("input[type='radio']:checked").attr("id");
    let colormap = $(`label[for="${checked}"]`).text()
    return {
        title: $("#title").val(),
        alpha: parseFloat($("#alpha").val()),
        theta: parseFloat($("#theta").val()),
        colormap: colormap,
        showtics: $("#showtics").is(":checked"),
        showtitle: $("#showtitle").is(":checked"),
        showlabels: $("#showlabels").is(":checked"),
        showedges: $("#showedges").is(":checked"),
        background: $("#colorbackground").val(),
        axes: $("#coloraxes").val(),
    }
}
