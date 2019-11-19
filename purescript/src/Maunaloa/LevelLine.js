"use strict";

/*
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
*/

const x1 = 45.0;

exports.onMouseDown = function (evt) {
    return function (lines) {
        return function () {
            console.log(event);
            if (lines.length === 0) {
                return;
            }
            if (lines.length === 1) {

            }
            lines.selected = PS["Data.Maybe"].Just.create(234 * Math.random());
            console.log(lines);
        }
    }
};

exports.onMouseDrag = function (evt) {
    return function (linesRef) {
        return function () {
            console.log(event);
            console.log(linesRef);
        }
    }
};

exports.createLine = function (ctx) {
    return function (vruler) {
        return function () {
            console.log(ctx);
            console.log(vruler);
            const y = vruler.h * Math.random();
            const x2 = vruler.w - x1;
            const displayValue = pixToValue(vruler, y);
            paint(x2, y, displayValue, ctx);
            return { y: y, draggable: true };
        };
    };
};

const pixToValue = function (v, pix) {
    return v.maxVal - ((pix - v.padding.top) / v.ppy);
};

const paint = function (x2, y, displayValue, ctx) {
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.moveTo(x1, y);
    ctx.lineTo(x2, y);
    ctx.stroke();
    ctx.font = "16px Arial";
    ctx.fillStyle = "#000000";
    ctx.fillText(displayValue, x1, y - 10);
};
