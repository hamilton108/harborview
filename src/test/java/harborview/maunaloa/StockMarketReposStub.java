package harborview.maunaloa;

import critterrepos.beans.StockBean;
import oahu.exceptions.FinancialException;
import oahu.financial.*;
import oahu.financial.repository.StockMarketRepository;

import java.time.LocalDate;
import java.util.*;
import java.util.function.Consumer;

public class StockMarketReposStub implements StockMarketRepository  {
    Map<String,Derivative> derivativeMap = new HashMap<>();

    @Override
    public void insertDerivative(Derivative derivative, Consumer<Exception> errorHandler) {
        derivativeMap.put(derivative.getTicker(), derivative);
    }

    @Override
    public Optional<Derivative> findDerivative(String derivativeTicker) {
        Derivative result = derivativeMap.get(derivativeTicker);
        if (result == null) {
            return Optional.empty();
        }
        return Optional.of(result);
    }

    @Override
    public Stock findStock(String ticker) {
        StockBean result = new StockBean();
        result.setTicker(ticker);

        switch (ticker) {
            case "NHY": result.setOid(1);
            default: result.setOid(1);
        }
        return result;
    }

    @Override
    public Collection<Stock> getStocks() {
        return null;
    }

    @Override
    public Collection<StockPrice> findStockPrices(String ticker, LocalDate fromDx) {
        return null;
    }

    @Override
    public void registerOptionPurchase(DerivativePrice purchase, int purchaseType, int volume) {

    }

    @Override
    public OptionPurchase registerOptionPurchase(int purchaseType, String opName, double price, int volume, double spotAtPurchase, double buyAtPurchase) throws FinancialException {
        return null;
    }

    @Override
    public Collection<SpotOptionPrice> findOptionPrices(int opxId) {
        return null;
    }

    @Override
    public Collection<SpotOptionPrice> findOptionPricesStockId(int stockId, LocalDate fromDate, LocalDate toDate) {
        return null;
    }

    @Override
    public Collection<SpotOptionPrice> findOptionPricesStockIds(List<Integer> stockIds, LocalDate fromDate, LocalDate toDate) {
        return null;
    }

    @Override
    public Collection<SpotOptionPrice> findOptionPricesStockTix(List<String> stockTix, LocalDate fromDate, LocalDate toDate) {
        return null;
    }

    @Override
    public Collection<OptionPurchase> purchasesWithSalesAll(int purchaseType, int status, Derivative.OptionType ot) {
        return null;
    }

    @Override
    public String getTickerFor(int oid) {
        switch (oid) {
            case 1: return "NHY";
            default: return "NHY";
        }
    }
}
