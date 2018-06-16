package harborview.dto.html.options;

import oahu.financial.DerivativePrice;

import java.util.Optional;

public class OptionDTO {
    private DerivativePrice price;

    public OptionDTO(DerivativePrice price) {
        this.price = price;
    }

    public String getTicker() {
        return price.getTicker();
    }

    public double getX() {
        return price.getDerivative().getX();
    }

    public double getDays() {
        return price.getDays();
    }

    public double getBuy() {
        return price.getBuy();
    }

    public double getSell() {
        return price.getSell();
    }


    private double getIv(boolean isBuy) {
        Optional<Double> iv = isBuy ? price.getIvBuy() : price.getIvSell();
        if (iv.isPresent()) {
            return iv.get();
        }
        else {
            return 0.0;
        }
    }
    public double getIvBuy() {
        return getIv(true);
    }

    public double getIvSell() {
        return getIv(false);
    }

    public double getBrEven() {
        Optional<Double> br = price.getBreakEven();
        if (br.isPresent()) {
            return br.get();
        }
        else {
            return 0.0;
        }
    }
}
