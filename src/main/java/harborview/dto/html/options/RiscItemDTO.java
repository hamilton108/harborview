package harborview.dto.html.options;

public class RiscItemDTO {
    private String ticker;
    //private String option;
    private double risc;

    public RiscItemDTO(){
    }
    public RiscItemDTO(String ticker, double risc){
        this.ticker = ticker;
        this.risc = risc;
    }

    /*
    public RiscItemDTO(String ticker, String option, double risc){
        this.ticker = ticker;
        this.risc = risc;
        this.setOption(option);
    }
    */

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

    /*
    public String getOption() {
        return option;
    }

    public void setOption(String option) {
        this.option = option;
    }
    */
}
