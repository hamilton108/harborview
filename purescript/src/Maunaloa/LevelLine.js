"use strict";

exports.createLine = function (vruler) {
    return function (evt) {
        return function () {
            console.log(evt);
            console.log(vruler);
            const cur_y = evt.offsetY;
            const valY = pixToValue(vruler, cur_y);
            console.log("Value: " + valY);
            return { y: cur_y, draggable: true };
        };
    };
};

exports.createLine2 = function (ctx) {
    return function (vruler) {
        return function () {
            console.log(ctx);
            console.log(vruler);
            /*
            const y = vruler.h / 2.0;
            const x0 = 25.0;
            const x1 = vruler.w - x0;
            ctx.lineWidth = 2.5;
            ctx.beginPath();
            ctx.moveTo(x0, y);
            ctx.lineTo(x1, y);
            ctx.stroke();
            */
            return { y: 20.0, draggable: true };
        };
    };
};

const pixToValue = function (v, pix) {
    return v.maxVal - ((pix - v.padding.top) / v.ppy);
};
