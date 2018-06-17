package harborview.dto.html.options;

public class OptionPurchaseDTO {
    /*
            , ( "ticker", JE.string ticker )
            , ( "ask", JE.float ask )
            , ( "bid", JE.float bid )
            , ( "vol", JE.int volume )
            , ( "spot", JE.float spot )
            , ( "rt", JE.bool isRealTime )
            */
    private String ticker;
    private double ask;
    private double bid;
    private int volume;
    private double spot;
    private boolean rt;

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public double getAsk() {
        return ask;
    }

    public void setAsk(double ask) {
        this.ask = ask;
    }

    public double getBid() {
        return bid;
    }

    public void setBid(double bid) {
        this.bid = bid;
    }

    public int getVolume() {
        return volume;
    }

    public void setVolume(int volume) {
        this.volume = volume;
    }

    public double getSpot() {
        return spot;
    }

    public void setSpot(double spot) {
        this.spot = spot;
    }

    public boolean isRt() {
        return rt;
    }

    public void setRt(boolean rt) {
        this.rt = rt;
    }
}
