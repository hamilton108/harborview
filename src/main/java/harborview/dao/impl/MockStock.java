package harborview.dao.impl;

import oahu.financial.Derivative;
import oahu.financial.Stock;
import oahu.financial.StockPrice;

import java.util.List;

public class MockStock implements Stock {
    private final int oid;
    private final String ticker;
    public MockStock(String ticker, int oid) {
       this.oid = oid;
       this.ticker = ticker;
    }
    @Override
    public String getCompanyName() {
        return null;
    }

    @Override
    public String getTicker() {
        return ticker;
    }

    @Override
    public int getTickerCategory() {
        return 0;
    }

    @Override
    public int getOid() {
        return oid;
    }

    @Override
    public List<StockPrice> getPrices() {
        return null;
    }

    @Override
    public List<Derivative> getDerivatives() {
        return null;
    }
}
