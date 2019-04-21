package harborview.dto.html;

import oahu.financial.DerivativePrice;

import java.util.Optional;

public class RiscLinesDTO {
    private final DerivativePrice price;

    public RiscLinesDTO(DerivativePrice price) {
        this.price = price;
    }

    public String getTicker() {
        return price.getTicker();
    }
    public double getBe() {
        Optional<Double> be = price.getBreakEven();
        return be.isPresent() ? be.get() : 0;
    }
    public double getStockprice() {
        Optional<Double> p = price.getCurrentRiscStockPrice();
        return p.isPresent() ? p.get(): 0;
    }
    public double getOptionprice() {
        return price.getCurrentRiscOptionValue();
    }
    public double getAsk() {
        return price.getSell();
    }
    public double getRisc() {
        return price.getCurrentRisc();
    }
}
