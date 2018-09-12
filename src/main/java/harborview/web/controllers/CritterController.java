package harborview.web.controllers;

import harborview.dto.html.critters.OptionPurchaseDTO;
import harborview.maunaloa.CritterModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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

    @RequestMapping(value = "{critterType}",
                    method =  RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OptionPurchaseDTO> critters(@PathVariable("critterType") int critterType) {
        return null;
    }
}
