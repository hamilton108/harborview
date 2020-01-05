package harborview.controllers;

import oahu.financial.Derivative;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;

import java.util.Optional;

public class DerivativePriceMock implements DerivativePrice {
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
        return 10.0;
    }

    @Override
    public Optional<Double> getBreakEven() {
        return Optional.of(36.0);
    }

    @Override
    public Optional<Double> stockPriceFor(double optionValue) {
        return Optional.empty();
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
        return null;
    }

    @Override
    public double getCurrentRiscOptionValue() {
        return 12.0;
    }

    @Override
    public double getCurrentRisc() {
        return 3.0;
    }

    @Override
    public Optional<Double> getCurrentRiscStockPrice() {
        return Optional.of(31.43);
    }

    @Override
    public void resetRiscCalc() {

    }
}
