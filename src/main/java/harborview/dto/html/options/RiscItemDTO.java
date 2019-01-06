package harborview.dto.html.options;

public class RiscItemDTO {
    private String ticker;
    private double risc;

    public RiscItemDTO(){
    }
    public RiscItemDTO(String ticker, double risc){
        this.ticker = ticker;
        this.risc = risc;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public double getRisc() {
        return risc;
    }

    public void setRisc(double risc) {
        this.risc = risc;
    }
}
