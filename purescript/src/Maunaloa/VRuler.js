"use strict";

exports.js_lines = function (ctx) {
    return function (boundary) {
        return function (lines) {
            console.log(boundary);
            const x1 = boundary.p1;
            const x2 = boundary.p2;
            ctx.strokeStyle = "#000";
            ctx.lineWidth = 0.25;
            ctx.beginPath();
            for (var i = 0; i < lines.length; ++i) {
                const y = lines[i].p0;
                ctx.moveTo(x1, y);
                ctx.lineTo(x2, y);
                ctx.fillText(lines[i].tx, x1, y + 15);
            }
            ctx.stroke();
        }
    }
}

