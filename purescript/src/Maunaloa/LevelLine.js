"use strict";

exports.createLine = function (valueToPix) {
    return function (evt) {
        return function () {
            console.log(evt);
            console.log(valueToPix);
            return { y: evt.offsetY, draggable: true };
        };
    };
};
