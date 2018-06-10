package harborview.maunaloa.impl;

import harborview.maunaloa.Ehlers;
import oahu.financial.repository.StockMarketRepository;

import java.util.List;

public class EhlersDay implements Ehlers {
    private StockMarketRepository stockMarketRepository;

    public EhlersDay()  {
    }


    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    @Override
    public List<Double> itrend(int stockId, int period) {
        return null;
    }
}
