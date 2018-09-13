package harborview.web.controllers;

import critterrepos.beans.options.OptionPurchaseBean;
import harborview.dto.html.critters.OptionPurchaseDTO;
import harborview.critters.CritterModel;
import harborview.web.controllers.web.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @RequestMapping(value = "overlook", method =  RequestMethod.GET)
    public String critters() {
        return "critters/overlook.html";
    }

    @ResponseBody
    @RequestMapping(value = "purchases/{purchaseType}",
                    method =  RequestMethod.GET,
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
    @RequestMapping(value = "purchases/toggle/{rt}/{oid}/{newVal}",
            method =  RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult toggleAccRule(
            @PathVariable("rt") int rt,
            @PathVariable("oid") int oid,
            @PathVariable("newVal") boolean newVal) {
        try {
            model.toggleRule(rt, oid, newVal);
            return new JsonResult(true, "AccRule toggled", 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }
}
