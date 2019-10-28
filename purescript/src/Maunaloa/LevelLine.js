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

const pixToValue = function (v, pix) {
    return v.maxVal - ((pix - v.padding.top) / v.ppy);
};
