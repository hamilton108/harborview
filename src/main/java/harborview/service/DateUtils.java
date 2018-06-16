package harborview.service;

import java.time.LocalDate;
import java.time.LocalTime;

public class DateUtils {
    /*
    (defn tm->str [^LocalTime t]
            (let [h (.getHour t)
    m (.getMinute t)]
            (str h ":" m)))

            (defn ld->str [^LocalDate v]
            (let [y (.getYear v)
    m (.getMonthValue v)
    d (.getDayOfMonth v)]
            (str y "-" m "-" d)))
            */

    public static String tmToStr(LocalTime t) {
        int m = t.getMinute();
        int h = t.getHour();
        return String.format("%d:%d", h, m);
    }

    public static String ldToStr(LocalDate ld) {
        int y = ld.getYear();
        int m = ld.getMonthValue();
        int d = ld.getDayOfMonth();
        return String.format("%d-%d-%d", y, m, d);
    }
}
