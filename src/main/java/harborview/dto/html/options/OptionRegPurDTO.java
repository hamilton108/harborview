package harborview.dto.html.options;

import java.time.LocalDate;
import critterrepos.beans.options.DerivativeBean;
import oahu.financial.Derivative;
import oahu.financial.Stock;

public class OptionRegPurDTO extends OptionPurchaseDTO {

  private int stockId;
  private String opType;
  private String expiry;
  private double x;

  public Derivative createDerivative(Stock stock) {
    Derivative.OptionType ot = opType.equals("c") ?
                                Derivative.OptionType.CALL :
                                Derivative.OptionType.PUT;
    DerivativeBean result = new DerivativeBean(
        getTicker()
        ,ot
        ,x
        ,LocalDate.parse(expiry)
        ,stock
      );
    return result;
  }

  public String getOpType() {
    return opType;
  }
  public void setOpType(String value) {
    opType = value;
  }
  public String getExpiry() {
    return expiry;
  }
  public void setExpiry(String value) {
    expiry = value;
  }
  public double getX() {
    return x;
  }
  public void setX(double value) {
    x = value;
  }

  public int getStockId() {
    return stockId;
  }

  public void setStockId(int stockId) {
    this.stockId = stockId;
  }
}
