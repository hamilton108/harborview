package harborview.web.controllers;

import critterrepos.beans.critters.CritterBean;
import critterrepos.beans.options.OptionPurchaseBean;
import harborview.dto.html.critters.OptionPurchaseDTO;
import harborview.critters.CritterModel;
import harborview.web.controllers.web.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Controller
@RequestMapping("/critters")
public class CritterController {
    private final CritterModel model;

    @Autowired
    public CritterController(CritterModel model) {
        this.model = model;
    }

    @RequestMapping(value = "overlook", method =  RequestMethod.GET)
    public String critters(Locale locale, Model model) {
        model.addAttribute("dbinfo", HomeController.getDbInfo());
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
            model.resetCache();
            return new JsonResult(true, String.format("%s rule [id=%d] toggled ok", rt == 1 ? "Acc" : "Deny", oid), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }

    @ResponseBody
    @RequestMapping(value = "purchases/newcritter/{oid}/{vol}",
            method =  RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult newCritter (
            @PathVariable("oid") int oid,
            @PathVariable("vol") int vol) {
        try {
            CritterBean bean = model.insertCritter(oid,vol);
            model.resetCache();
            return new JsonResult(true, String.format("[id=%d] New Critter", bean.getOid()), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }
    @ResponseBody
    @RequestMapping(value = "purchases/resetcache/{ptype}",
            method =  RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult resetCache (
            @PathVariable("ptype") int purchaseType) {
        try {
            model.resetCache();
            return new JsonResult(true, String.format("Cache reset for purchase type %d", purchaseType), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }
}
