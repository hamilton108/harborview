package harborview.maunaloa;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import harborview.maunaloa.charts.ElmChartsFactory;
import oahu.financial.StockPrice;
import oahu.financial.repository.StockMarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.Collection;
import java.util.stream.Collectors;

@Component
@CacheConfig(cacheNames = {"maunaloaModel"})
public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private LocalDate startDate = LocalDate.of(2010,1,1);

    @Autowired
    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    public enum ElmChartType { DAY, WEEK, MONTH }

    public Collection<SelectItem> getStockTickers() {
        return stockMarketRepository.getStocks().stream().map(
                x -> new SelectItem(String.format("%s - %s",x.getTicker(),x.getCompanyName()),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }

    private ElmCharts elmCharts(int stockId, ElmChartsFactory factory) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(
                stockMarketRepository.getTickerFor(stockId),startDate);
        return factory.elmCharts(prices);
    }

    public ElmCharts elmChartsDay(int stockId) {
        return elmCharts(stockId, new ElmChartsFactory());
    }
}
