package harborview.controllers;

import critterrepos.beans.critters.AcceptRuleBean;
import critterrepos.beans.critters.CritterBean;
import critterrepos.beans.options.OptionPurchaseBean;
import harborview.dto.html.JsonResult;
import harborview.dto.html.critters.OptionPurchaseDTO;
import harborview.critters.CritterModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/critters")
public class CritterController {
    private final CritterModel model;

    @Autowired
    public CritterController(CritterModel model) {
        this.model = model;
    }

    @GetMapping(value = "overlook")
    public String critters() {
        return "critters/overlook.html";
    }

    @ResponseBody
    @GetMapping(value = "/purchases/{purchaseType}",
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OptionPurchaseDTO> purchases(@PathVariable("purchaseType") int purchaseType) {
        List<OptionPurchaseBean> purchases = model.fetchCritters(purchaseType);
        List<OptionPurchaseDTO> result = new ArrayList<>();
        for (OptionPurchaseBean p : purchases) {
            result.add(new OptionPurchaseDTO(p));
        }
        return result;
    }
    @ResponseBody
    @GetMapping(value = "/purchases/toggle/{rt}/{oid}/{newVal}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult toggleAccRule(
            @PathVariable("rt") int rt,
            @PathVariable("oid") int oid,
            @PathVariable("newVal") boolean newVal) {
        try {
            model.toggleRule(rt, oid, newVal);
            model.resetCache();
            return new JsonResult(true, String.format("%s rule [id=%d] toggled ok", rt == 1 ? "Acc" : "Deny", oid), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }

    @ResponseBody
    @GetMapping(value = "/purchases/newacc/{oid}/{rt}/{val}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult newAcc(
            @PathVariable("oid") int oid,
            @PathVariable("rt") int ruleType,
            @PathVariable("val") double ruleValue) {
        return Common.jsonTryCatch(()-> {
            AcceptRuleBean bean = model.insertAccRule(oid,ruleType,ruleValue);
            model.resetCache();
            return String.format("[id=%d] New Acc Rule", bean.getOid());
        });
    }

    @ResponseBody
    @GetMapping(value = "/purchases/newdeny/{oid}/{rt}/{val}/{mem}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult newDeny(
            @PathVariable("oid") int oid,
            @PathVariable("rt") int ruleType,
            @PathVariable("val") double ruleValue,
            @PathVariable("mem") boolean hasMemory) {
        return Common.jsonTryCatch(()-> {
            System.out.printf("oid: %d, ruleType: %d, ruleValue: %.2f, hasMemory: %s", oid, ruleType, ruleValue, hasMemory);
            return String.format("[id=%d] New Deny Rule", 1000);
        });
    }

    @ResponseBody
    @GetMapping(value = "/purchases/newcritter/{oid}/{vol}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult newCritter (
            @PathVariable("oid") int oid,
            @PathVariable("vol") int vol) {
        return Common.jsonTryCatch(()-> {
            CritterBean bean = model.insertCritter(oid,vol);
            model.resetCache();
            return String.format("[id=%d] New Critter", bean.getOid());
        });
    }
    @ResponseBody
    @GetMapping(value = "/purchases/resetcache/{ptype}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult resetCache (
            @PathVariable("ptype") int purchaseType) {
        return Common.jsonTryCatch(()-> {
                    model.resetCache();
                    return String.format("Cache reset for purchase type %d", purchaseType);
                });
        /*
        try {
            model.resetCache();
            return new JsonResult(true, String.format("Cache reset for purchase type %d", purchaseType), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
        */
    }
}
