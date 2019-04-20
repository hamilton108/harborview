package harborview.maunaloa;

import oahu.financial.Derivative;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class DerivativePriceStub implements DerivativePrice {
    private String ticker;
    private static Map<Double,Double> stockPriceMap = new HashMap<>();

    public static void setStockPriceMap(Map<Double, Double> stockPriceMap) {
        DerivativePriceStub.stockPriceMap = stockPriceMap;
    }

    @Override
    public Derivative getDerivative() {
        return null;
    }

    @Override
    public StockPrice getStockPrice() {
        return null;
    }

    @Override
    public double getDays() {
        return 0;
    }

    @Override
    public Optional<Double> getIvBuy() {
        return Optional.empty();
    }

    @Override
    public Optional<Double> getIvSell() {
        return Optional.empty();
    }

    @Override
    public double getBuy() {
        return 0;
    }

    @Override
    public double getSell() {
        return 0;
    }

    @Override
    public Optional<Double> getBreakEven() {
        return Optional.empty();
    }

    @Override
    public Optional<Double> stockPriceFor(double optionValue) {
        return Optional.ofNullable(stockPriceMap.get(optionValue));
    }

    @Override
    public double optionPriceFor(double stockPrice) {
        return 0;
    }

    @Override
    public int getOid() {
        return 0;
    }

    @Override
    public int getStockId() {
        return 0;
    }

    @Override
    public void setOid(int oid) {

    }

    @Override
    public String getTicker() {
        return ticker;
    }
    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    @Override
    public double getCurrentRiscOptionValue() {
        return 0;
    }

    @Override
    public double getCurrentRisc() {
        return 0;
    }

    @Override
    public Optional<Double> getCurrentRiscStockPrice() {
        return Optional.empty();
    }

    @Override
    public void resetRiscCalc() {

    }

}
