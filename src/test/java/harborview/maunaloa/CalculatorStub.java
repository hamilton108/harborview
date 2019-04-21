package harborview.maunaloa;

import oahu.financial.DerivativePrice;
import oahu.financial.OptionCalculator;

import java.util.Map;

public class CalculatorStub implements OptionCalculator {

    private static Map<Double, Double> stockPriceMap;

    public static void setStockPriceMap(Map<Double, Double> stockPriceMap) {
        CalculatorStub.stockPriceMap = stockPriceMap;
    }

    @Override
    public double delta(DerivativePrice d) {
        return 0;
    }

    @Override
    public double spread(DerivativePrice d) {
        return 0;
    }

    @Override
    public double breakEven(DerivativePrice d) {
        return 0;
    }

    @Override
    public double stockPriceFor(double optionPrice, DerivativePrice o) {
        return stockPriceMap.get(optionPrice);
    }

    @Override
    public double iv(DerivativePrice d, int priceType) {
        return 0;
    }

    @Override
    public double ivCall(double spot, double strike, double yearsExpiry, double optionPrice) {
        return 0;
    }

    @Override
    public double ivPut(double spot, double strike, double yearsExpiry, double optionPrice) {
        return 0;
    }

    @Override
    public double callPrice(double spot, double strike, double yearsExpiry, double sigma) {
        return 0;
    }

    @Override
    public double putPrice(double spot, double strike, double yearsExpiry, double sigma) {
        return 0;
    }
}
