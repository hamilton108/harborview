package harborview.dto.html.critters;

import oahu.financial.OptionPurchase;

import java.util.List;

public class OptionPurchaseDTO {
    private final OptionPurchase purchase;

    public OptionPurchaseDTO(OptionPurchase purchase) {
        this.purchase = purchase;
    }

    public int getOid() {
        return purchase.getOid();
    }

    public String getTicker() {
        return purchase.getOptionName();
    }

    public List<CritterDTO> getCritters()  {
        return null;
    }

}
