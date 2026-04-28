// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// For more information, see the COPYING file which you should have received
// along with this program.

var callback = {};
function toScilab(msg, cb) {
    if (cb !== undefined) {
        Scilab({
            request: JSON.stringify(msg),
            onSuccess: (id) => {
                callback[id] = cb;
            }
        })
    } else {
        Scilab({request: JSON.stringify(msg)})
    }
}

function fromScilabInternal(msg) {
    msg = JSON.parse(msg);
    if (typeof msg === "object" && Object.keys(msg).includes("scilabcallbackID")) {
        let cb = callback[msg.scilabcallbackID]
        if (cb !== undefined) {
            cb(msg.data);
            delete callback[msg.scilabcallbackID];
        }
    } else {
        if (typeof fromScilab != "undefined") {
            fromScilab(msg)
        }
    }
}
