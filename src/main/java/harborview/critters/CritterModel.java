package harborview.critters;

import critterrepos.beans.options.OptionPurchaseBean;
import critterrepos.models.mybatis.CritterMapper;
import critterrepos.utils.MyBatisUtils;

import java.util.List;

public class CritterModel {
    List<OptionPurchaseBean> critters11;
    List<OptionPurchaseBean> critters4;

    public List<OptionPurchaseBean> fetchCritters(int purchaseType) {
        List<OptionPurchaseBean> critters = purchaseType == 4 ? critters4 : critters11;
        if (critters == null) {
            List<OptionPurchaseBean> result = MyBatisUtils.withSession((session) ->
                    session.getMapper(CritterMapper.class).activePurchasesAll(purchaseType));
            /*
            for (OptionPurchaseBean critter : result) {
                critter.setRepository(repos);
            }
            */
            if (purchaseType == 4) {
                critters4 = result;
            }
            else {
                critters11 = result;
            }
            critters = result;
        }
        return critters;
    }
    public void toggleRule(int ruleType, int oid, boolean newVal) {
        MyBatisUtils.withSessionConsumer((session) -> {
            CritterMapper mapper = session.getMapper(CritterMapper.class);
            if (ruleType == 1) {
                mapper.toggleAcceptRule(oid, newVal ? "y" : "n");
            }
            else {
                mapper.toggleDenyRule(oid, newVal ? "y" : "n");
            }
        });
    }
    public void resetCache() {
        critters4 = null;
        critters11 = null;
    }
}
