package harborview.dto.html.options;

import harborview.service.DateUtils;
import oahu.financial.StockPrice;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneOffset;
import java.util.Date;

public class StockPriceDTO {
    //private final String dx;
    //jprivate final String tm;
    private final double o;
    private final double h;
    private final double l;
    private final double c;
    private final long unixTime;
    //private final LocalDate dx;
    //private final LocalTime tm;

    public StockPriceDTO(StockPrice stockPrice) {
        //this.dx = DateUtils.localDateToStr(stockPrice.getLocalDx());
        //this.tm = DateUtils.localTimeToStr(stockPrice.getTm());
        //this.dx = stockPrice.getLocalDx();
        //this.tm = stockPrice.getTm();
        unixTime = DateUtils.unixTime(stockPrice.getLocalDx(), stockPrice.getTm());
        this.o = stockPrice.getOpn();
        this.h = stockPrice.getHi();
        this.l = stockPrice.getLo();
        this.c = stockPrice.getCls();
    }

    /*
    public String getDx() {
        return DateUtils.localDateToStr(dx);
    }

    public String getTm() {
        return DateUtils.localTimeToStr(tm);
    }
    */

    public double getO() {
        return o;
    }

    public double getH() {
        return h;
    }

    public double getL() {
        return l;
    }

    public double getC() {
        return c;
    }

    public long getUnixTime() {
        return unixTime;
    }
}
