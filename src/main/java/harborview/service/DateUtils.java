package harborview.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

public class DateUtils {
    private static DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    public static String localTimeToStr(LocalTime t) {
        return t.format(timeFormatter);
    }

    public static String localDateToStr(LocalDate ld) {
        return ld.format(dateFormatter);
    }
    public static long unixTime(LocalDate ld, LocalTime tm) {
        LocalDateTime ldt = LocalDateTime.of(ld.getYear(), ld.getMonth(), ld.getDayOfMonth(),
                tm.getHour(), tm.getMinute(), 0);
        return ldt.toInstant(ZoneOffset.UTC).toEpochMilli();
    }
}
