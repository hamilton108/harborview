"use strict";

exports.fx = function (ctx) {
    console.log(ctx);

    const cx = document.getElementById("canvas");
    const cxx = cx.getContext("2d");
    console.log(cxx);
};