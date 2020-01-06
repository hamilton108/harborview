"use strict";

const x1 = 45.0;

/*
const createPilotLine = function (y) {
    return PS["Data.Maybe"].Just.create(y);
}
*/

const createPilotLine = function (line) {
    return PS["Data.Maybe"].Just.create({y: line.y, strokeStyle: line.strokeStyle});
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
        //return [index, createPilotLine(lines[index].y)];
        return [index, createPilotLine(lines[index])];
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
        //paintDisplayValueDefault(curLine.y, vruler, ctx);
        paintLine(curLine, vruler, ctx);
    }
    //paintDisplayValueDefault(linesWrapper.pilotLine.y, vruler, ctx);
    paintLine(linesWrapper.pilotLine.value0, vruler, ctx);
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
                //linesWrapper.pilotLine = createPilotLine(lines[0].y);
                linesWrapper.pilotLine = createPilotLine(lines[0]);
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
                    //linesWrapper.pilotLine.y = evt.offsetY;
                    linesWrapper.pilotLine.value0.y = evt.offsetY;
                    draw(linesWrapper, vruler, ctx);
                }
            }
        }
    }
};

exports.onMouseUp = function (evt) {
    return function (linesWrapper) {
        return function () {
            var selectedLine; 
            const lines = linesWrapper.lines;

            for (var i = 0; i < lines.length; ++i) {
                const curLine = lines[i];
                if (curLine.selected == true) {
                    curLine.y = linesWrapper.pilotLine.value0.y;
                    curLine.selected = false;
                    selectedLine = curLine;
                }
            }
            linesWrapper.pilotLine = nothing();
            return selectedLine;
        }
    }
};

const paintLine = function (line, vruler, ctx) {
    const x2 = vruler.w - x1;
    const y = line.y;
    const displayValue = pixToValue(vruler, y);
    paint(x2, y, displayValue, ctx, line.strokeStyle);
}

const paintDisplayValueDefault = function (y, vruler, ctx) {
    const x2 = vruler.w - x1;
    const displayValue = pixToValue(vruler, y);
    paint(x2, y, displayValue, ctx, "black");
}

exports.redraw = function (ctx) {
    return function (vruler) {
        return function () {
            ctx.clearRect(0, 0, vruler.w, vruler.h);
        }
    };
};

exports.createRiscLines = function (json) {
    return function (ctx) {
        return function (vruler) {
            return function () {
                var result = [];
                const x2 = vruler.w - x1;
                for (var i=0; i<json.length; ++i) {
                    const curJson = json[i];
                    const bePix = valueToPix(vruler, curJson.be);
                    const spPix = valueToPix(vruler, curJson.stockprice);
                    const breakEvenLine = { y: bePix, draggable: false, selected: false, riscLine: false, strokeStyle: "green" };
                    const riscLine = { y: spPix, draggable: true, selected: false, riscLine: true, strokeStyle: "red" };
                    //paint(x2, bePix, curJson.be, ctx);
                    //paint(x2, spPix, curJson.stockprice, ctx);
                    paintLine(breakEvenLine, vruler, ctx);
                    paintLine(riscLine, vruler, ctx);
                    result.push(breakEvenLine);
                    result.push(riscLine);
                }
                return result;
            };
        };
    };
};


exports.createLine = function (ctx) {
    return function (vruler) {
        return function () {
            //console.log("createLine...");
            const y = vruler.h * Math.random();
            paintDisplayValueDefault(y, vruler, ctx);
            return { y: y, draggable: true, selected: false, riscLine: false, strokeStyle: "black" };
        };
    };
};

const pixToValue = function (v, pix) {
    return v.maxVal - ((pix - v.padding.top) / v.ppy);
};
const valueToPix = function (v, value) {
    //((maxVal - value) * ppyVal) + curPad.top 
    return ((v.maxVal - value) * v.ppy) + v.padding.top;
};

const paint = function (x2, y, displayValue, ctx, strokeStyle) {
    ctx.lineWidth = 1.0;
    ctx.strokeStyle = strokeStyle;
    ctx.beginPath();
    ctx.moveTo(x1, y);
    ctx.lineTo(x2, y);
    ctx.stroke();
    ctx.font = "16px Arial";
    ctx.fillStyle = "#000000";
    ctx.fillText(displayValue, x1, y - 10);
};
