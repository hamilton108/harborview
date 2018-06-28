package harborview.dto.html.options;

import harborview.service.DateUtils;
import oahu.financial.StockPrice;

public class StockPriceDTO {
    private final String dx;
    private final String tm;
    private final double o;
    private final double h;
    private final double l;
    private final double c;

    public StockPriceDTO(StockPrice stockPrice) {
        this.dx = DateUtils.localDateToStr(stockPrice.getLocalDx());
        this.tm = DateUtils.localTimeToStr(stockPrice.getTm());
        this.o = stockPrice.getOpn();
        this.h = stockPrice.getHi();
        this.l = stockPrice.getLo();
        this.c = stockPrice.getCls();
    }

    public String getDx() {
        return dx;
    }

    public String getTm() {
        return tm;
    }

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
}
