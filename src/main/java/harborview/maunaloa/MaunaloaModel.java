package harborview.maunaloa;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import oahu.financial.Stock;
import oahu.financial.repository.StockMarketRepository;

import java.util.Collection;
import java.util.stream.Collectors;

public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private Collection<Stock> stocks;
    private Ehlers ehlersDay;

    public Collection<SelectItem> getStockTickers() {
        return getStocks().stream().map(x -> new SelectItem(x.getTicker(),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }
    public Collection<Stock> getStocks() {
        if (stocks == null) {
            stocks =  stockMarketRepository.getStocks();
        }
        return stocks;
    }
    public ElmCharts elmChartsDay() {
        return new ElmCharts();
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    public void setEhlersDay(Ehlers ehlersDay) {
        this.ehlersDay = ehlersDay;
    }
}
