
"use strict";

exports.incMonths_ = function (startTime) {
    return function (numMonths) {
        var stm = new Date(startTime);
        var startOfMonth = new Date(stm.getFullYear(), stm.getMonth() + numMonths, 1);
        return startOfMonth.getTime();
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