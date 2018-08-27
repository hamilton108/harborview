package harborview.web.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/critters")
public class CritterController {

    @RequestMapping(value = "overlook", method =  RequestMethod.GET)
    public String critters() {
        return "critters/overlook.html";
    }
    /*
    @RequestMapping(value = "overlook/{ct}", method =  RequestMethod.GET)
    public String critters(@PathVariable("ct") int critterType, Model model) {
        model.addAttribute("demo", "demo");
        return "critters/overlook.html";
    }
    */
}
