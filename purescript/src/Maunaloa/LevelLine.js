"use strict";

exports.createLine = function (evt) {
    return function () {
        console.log(evt);
        return { y: evt.offsetY, draggable: true};
    };
};
