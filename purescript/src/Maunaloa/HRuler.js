
"use strict";

exports.incMonths_ = function (startTime) {
    return function (numMonths) {
        var stm = new Date(startTime);
        var startOfMonth = new Date(stm.getFullYear(), stm.getMonth() + numMonths, 1);
        return startOfMonth.getTime();
    }
}

exports.incDays_ = function (startTime) {
    return function (offset) {
        var stm = new Date(startTime);
        var offsetTime = new Date(stm.getFullYear(), stm.getMonth(), stm.getDate() + offset);
        return offsetTime.getTime();
    }
}

exports.dateToString_ = function (tm) {
    var d = new Date(tm);
    var m = d.getMonth() + 1;
    if (m < 10) {
        return "0" + m + "." + d.getFullYear();
    }
    else {
        return m + "." + d.getFullYear();
    }
}

exports.js_lines = function (ctx) {
    return function (level) {
        return function (lines) {
            console.log(level);
        }
    }
}

exports.js_startOfNextMonth = function (tm) {
    const curDate = new Date(tm);
    const som = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);
    return som.getTime();
}