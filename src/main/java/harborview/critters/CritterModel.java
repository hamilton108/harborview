package harborview.critters;

import critterrepos.beans.critters.AcceptRuleBean;
import critterrepos.beans.critters.CritterBean;
import critterrepos.beans.options.OptionPurchaseBean;
import critterrepos.mybatis.CritterMapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class CritterModel {
    private final SqlSession session;

    private List<OptionPurchaseBean> critters11;
    private List<OptionPurchaseBean> critters3;

    @Autowired
    public CritterModel(SqlSession session) {
        this.session = session;
    }

    public List<OptionPurchaseBean> fetchCritters(int purchaseType) {
        List<OptionPurchaseBean> critters = purchaseType == 3 ? critters3 : critters11;
        if (critters == null) {
            List<OptionPurchaseBean> result =
                    session.getMapper(CritterMapper.class).activePurchasesAll(purchaseType);
            /*
            for (OptionPurchaseBean critter : result) {
                critter.setRepository(repos);
            }
            */
            if (purchaseType == 3) {
                critters3 = result;
            }
            else {
                critters11 = result;
            }
            critters = result;
        }
        return critters;
    }
    public void toggleRule(int ruleType, int oid, boolean newVal) {
            CritterMapper mapper = session.getMapper(CritterMapper.class);
            if (ruleType == 1) {
                mapper.toggleAcceptRule(oid, newVal ? "y" : "n");
            }
            else {
                mapper.toggleDenyRule(oid, newVal ? "y" : "n");
            }
    }
    public CritterBean insertCritter(int purchaseId, int volume) {
            CritterMapper mapper = session.getMapper(CritterMapper.class);
            CritterBean bean = new CritterBean();
            bean.setStatus(7);
            bean.setCritterType(1);
            bean.setPurchaseId(purchaseId);
            bean.setSellVolume(volume);
            mapper.insertCritter(bean);
            return bean;
    }
    public AcceptRuleBean insertAccRule(int critterId, int ruleType, double ruleValue) {
            CritterMapper mapper = session.getMapper(CritterMapper.class);
            AcceptRuleBean bean = new AcceptRuleBean();
            bean.setCid(critterId);
            bean.setRtyp(ruleType);
            bean.setAccValue(ruleValue);
            mapper.insertAcceptRule(bean);
            return bean;
    }

    public void resetCache() {
        critters3 = null;
        critters11 = null;
    }
    public void resetCache(int purchaseType) {
        if (purchaseType == 3) {
            critters3 = null;
        }
        else {
            critters11 = null;
        }
    }
}
