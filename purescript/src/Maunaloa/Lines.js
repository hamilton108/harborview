"use strict";

exports.js_draw = function (line) {
    return function (ctx) {
        console.log(line);
        ctx.strokeStyle = line.strokeStyle;
        ctx.beginPath();
        const y = line.yaxis;
        const x = line.xaxis;
        ctx.moveTo(x[0], y[0]);
        for (var i = 1; i < x.length; ++i) {
            ctx.lineTo(x[i], y[i]);
        }
        ctx.stroke();
        /*
        const l0 = x[0];
        const l1 = x[1];
        const diff = l0 - l1;
        ctx.moveTo(x[0], y[0]);
        ctx.lineTo(x[0] + diff, y[0]);
        ctx.stroke();
        */
    }
};