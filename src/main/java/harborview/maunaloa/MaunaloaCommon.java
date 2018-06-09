package harborview.maunaloa;

import harborview.dto.html.SelectItem;
import oahu.financial.Stock;
import oahu.financial.repository.StockMarketRepository;

import java.util.Collection;

public class MaunaloaCommon {
    private StockMarketRepository stockMarketRepository;
    private Collection<Stock> stocks;

    public Collection<SelectItem> getStockTickers() {
        return null;
    }
    public Collection<Stock> getStocks() {
        return null;
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
}
