package harborview.critters;

import critterrepos.beans.options.OptionPurchaseBean;
import critterrepos.models.mybatis.CritterMapper;
import critterrepos.utils.MyBatisUtils;

import java.util.List;

public class CritterModel {
    List<OptionPurchaseBean> critters;

    public List<OptionPurchaseBean> fetchCritters(int purchaseType) {
        if (critters == null) {
            List<OptionPurchaseBean> result = MyBatisUtils.withSession((session) ->
                    session.getMapper(CritterMapper.class).activePurchasesAll(purchaseType));

            /*
            for (OptionPurchaseBean critter : result) {
                critter.setRepository(repos);
            }
            */
            critters = result;
        }
        return critters;
    }
}
