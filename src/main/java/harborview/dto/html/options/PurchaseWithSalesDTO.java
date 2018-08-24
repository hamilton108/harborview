package harborview.dto.html.options;

import critterrepos.beans.options.OptionPurchaseBean;
import oahu.financial.OptionPurchase;
import harborview.service.DateUtils;

public class PurchaseWithSalesDTO {
    private int oid;
    private String stock;
    private String dx;
    private String ot;
    private String ticker;
    private String pdx;
    private String exp;
    private int days;
    private double price;
    private double bid;
    private double spot;
    private int pvol;
    private int svol;
    private double iv;
    private double curAsk;
    private double curBid;
    private double curIv;
    private final OptionPurchaseBean p;

    /*
    (defn purchasesales->json [^OptionPurchaseBean p]
            (let [calc (S/get-bean "calculator")
    oid (.getOid p)
    ticker (.getOptionName p)
    stock-ticker (.getTicker p)
    d0 (.getLocalDx p)
    ot (.getOptionType p)
    spot (.getSpotAtPurchase p)
    price (.getPrice p)
    bid (.getBuyAtPurchase p)
    x (.getX p)
    d1 (.getExpiry p)
    days (.between ChronoUnit/DAYS d0 d1)
    t (/ days 365.0)
    pvol (.getVolume p)
    svol (.volumeSold p)
    iv (if (= ot "c")
            (.ivCall calc spot x t bid)
            (.ivPut calc spot x t bid))
    cur-opt (let [items (if (= ot "c")
                              (calls stock-ticker)
            (puts stock-ticker))]
            (first (filter #(= (.getTicker %) ticker) items)))
    cur-ask (if (nil? cur-opt)
                  -1
                          (.getSell cur-opt))
    cur-bid (if (nil? cur-opt)
                  -1
                          (.getBuy cur-opt))
    cur-iv (if (nil? cur-opt)
                 (Optional/empty)
            (.getIvBuy cur-opt))]
    {:oid oid
     :stock stock-ticker
     :ot ot
     :ticker ticker
     :dx (CU/ld->str d0)
     :exp (CU/ld->str d1)
     :days days
     :price price
     :bid bid
     :spot spot
     :pvol pvol
     :svol svol
     :iv (CU/double->decimal iv 1000.0)
     :cur-ask cur-ask
     :cur-bid cur-bid
     :cur-iv (if (true? (.isPresent cur-iv))
        (CU/double->decimal (.get cur-iv) 1000.0)
        -1)}))

    */

    public PurchaseWithSalesDTO(OptionPurchase purchase) {
        this.p = (OptionPurchaseBean)purchase;
    }

    public int getOid() {
        return p.getOid();
    }

    public String getStock() {
        return p.getTicker();
    }

    public String getDx() {
        return DateUtils.localDateToStr(p.getLocalDx());
    }

    public String getOt() {
        return p.getOptionType();
    }

    public String getTicker() {
        return p.getOptionName();
    }

    /**
      purchase date
    */
    public String getPdx() {
        return getDx();
    }

    public String getExp() {
        return DateUtils.localDateToStr(p.getExpiry());
    }

    public int getDays() {
        return days;
    }

    public double getPrice() {
        return price;
    }

    public double getBid() {
        return bid;
    }

    public double getSpot() {
        return spot;
    }

    public int getPvol() {
        return pvol;
    }

    public int getSvol() {
        return svol;
    }

    public double getIv() {
        return iv;
    }

    public double getCurAsk() {
        return curAsk;
    }

    public double getCurBid() {
        return curBid;
    }

    public double getCurIv() {
        return curIv;
    }

    public OptionPurchase getPurchase() {
        return p;
    }
}
