package harborview.maunaloa;

import harborview.dto.html.ElmCharts;
import oahu.financial.StockPrice;

import java.util.Collection;

public class ElmChartsWeekFactory extends ElmChartsFactory {
    public ElmCharts elmCharts(Collection<StockPrice> prices) {
        return super.elmCharts(prices);
    }
}
