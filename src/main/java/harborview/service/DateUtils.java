package harborview.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

public class DateUtils {
    private static DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
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

    public static String localTimeToStr(LocalTime t) {
        return t.format(timeFormatter);
        /*
        int m = t.getMinute();
        int h = t.getHour();
        return String.format("%d:%d", h, m);
        */
    }

    public static String localDateToStr(LocalDate ld) {
        return ld.format(dateFormatter);
        /*
        int y = ld.getYear();
        int m = ld.getMonthValue();
        int d = ld.getDayOfMonth();
        return String.format("%d-%d-%d", y, m, d);
        */
    }
    public static long unixTime(LocalDate ld, LocalTime tm) {
        LocalDateTime ldt = LocalDateTime.of(ld.getYear(), ld.getMonth(), ld.getDayOfMonth(),
                tm.getHour(), tm.getMinute(), 0);
        return ldt.toInstant(ZoneOffset.UTC).toEpochMilli();
    }
}
