package harborview.dto.html.options;

public class OptionPriceForDTO {
    private final double risc;
    private final double optionprice;

    public OptionPriceForDTO(double optionPrice, double risc) {
        this.optionprice = optionPrice;
        this.risc = risc;
    }
    public double getRisc() {
        return risc;
    }

    public double getOptionprice() {
        return optionprice;
    }
}
