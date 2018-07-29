package harborview.maunaloa;

import harborview.dto.html.ElmCharts;
import oahu.financial.StockPrice;

import java.time.LocalDate;
import java.time.temporal.IsoFields;
import java.util.Collection;

public class ElmChartsWeekFactory extends ElmChartsFactory {
    public ElmCharts elmCharts(Collection<StockPrice> prices) {
        return super.elmCharts(prices);
    }
    private int extractWeek(StockPrice price) {
        LocalDate dx = price.getLocalDx();
        return dx.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
    }
    private boolean isFirstWeekInDecember(StockPrice price) {
        LocalDate dx = price.getLocalDx();
        int month = dx.getMonthValue();
        int week = dx.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
        return (week == 1) && (month == 12);
    }
}
