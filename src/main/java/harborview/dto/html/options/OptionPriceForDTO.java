package harborview.dto.html.options;

public class OptionPriceForDTO {
    private final double risc;
    private final double optionPrice;

    public OptionPriceForDTO(double optionPrice, double risc) {
        this.optionPrice = optionPrice;
        this.risc = risc;
    }
    public double getRisc() {
        return risc;
    }

    public double getOptionPrice() {
        return optionPrice;
    }
}
