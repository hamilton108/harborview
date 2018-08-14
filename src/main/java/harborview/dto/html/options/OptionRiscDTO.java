package harborview.dto.html.options;

public class OptionRiscDTO {
    private String ticker;
    private double risc;

    public void setTicker(String value)  {
        this.ticker = value;
    }
    public String getTicker() {
        return ticker;
    }
    public void setRisc(double value) {
        this.risc = value;
    }
    public double getRisc() {
        return risc;
    }
}
