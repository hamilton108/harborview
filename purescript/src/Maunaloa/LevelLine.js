"use strict";

const x1 = 45.0;

const createPilotLine = function (y) {
    return PS["Data.Maybe"].Just.create(y);
}

const nothing = function () {
    return PS["Data.Maybe"].Nothing.value;
}

const closestLine = function (lines, y) {
    var dist = 100000000;
    var index = null;
    for (var i = 0; i < lines.length; ++i) {
        const curLine = lines[i];
        if (curLine.draggable === false) {
            continue;
        }
        const dy = curLine.y - y;
        const thisDist = dy * dy;
        if (thisDist < dist) {
            index = i;
            dist = thisDist;
        }
    }
    if (index === null) {
        return null;
    }
    else {
        return [index, createPilotLine(lines[index].y)];
    }
}

const draw = function (linesWrapper, vruler, ctx) {
    ctx.clearRect(0, 0, vruler.w, vruler.h);

    const lines = linesWrapper.lines;
    for (var i = 0; i < lines.length; ++i) {
        const curLine = lines[i];
        if (curLine.selected == true) {
            continue;
        }
        paintDisplayValueDefault(curLine.y, vruler, ctx);
    }
    paintDisplayValueDefault(linesWrapper.pilotLine.y, vruler, ctx);
};

exports.showJson = function(json) {
    return function () {
        console.log (json);
    }
}
exports.onMouseDown = function (evt) {
    return function (linesWrapper) {
        return function () {
            const lines = linesWrapper.lines;
            if (lines.length === 0) {
                return;
            }
            if (lines.length === 1) {
                lines[0].selected = true;
                linesWrapper.pilotLine = createPilotLine(lines[0].y);
            }
            else {
                const cl = closestLine(lines, evt.offsetY);
                if (cl !== null) {
                    lines[cl[0]].selected = true;
                    linesWrapper.pilotLine = cl[1];
                }
            }
            //console.log(lines);
        }
    }
};

exports.onMouseDrag = function (evt) {
    return function (linesWrapper) {
        return function (ctx) {
            return function (vruler) {
                return function () {
                    //console.log(linesWrapper);
                    linesWrapper.pilotLine.y = evt.offsetY;
                    draw(linesWrapper, vruler, ctx);
                }
            }
        }
    }
};

exports.onMouseUp = function (evt) {
    return function (linesWrapper) {
        return function () {
            const lines = linesWrapper.lines;

            for (var i = 0; i < lines.length; ++i) {
                const curLine = lines[i];
                if (curLine.selected == true) {
                    curLine.y = linesWrapper.pilotLine.y;
                    curLine.selected = false;
                }
            }
            linesWrapper.pilotLine = nothing();
        }
    }
};

const paintDisplayValueDefault = function (y, vruler, ctx) {
    const x2 = vruler.w - x1;
    const displayValue = pixToValue(vruler, y);
    paint(x2, y, displayValue, ctx);
}

exports.redraw = function (ctx) {
    return function (vruler) {
        return function () {
            ctx.clearRect(0, 0, vruler.w, vruler.h);
        }
    };
};

exports.createLine = function (ctx) {
    return function (vruler) {
        return function () {
            //console.log("createLine...");
            const y = vruler.h * Math.random();
            paintDisplayValueDefault(y, vruler, ctx);
            return { y: y, draggable: true, selected: false };
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
