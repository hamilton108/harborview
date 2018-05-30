package harborview.web.controllers;

import oahu.financial.Stock;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.ArrayList;
import java.util.Locale;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {

    @RequestMapping(value = "charts", method =  RequestMethod.GET)
    public String index(Locale locale, Model model) {
        model.addAttribute("stockTickers", new ArrayList<Stock>());
        return "maunaloa/charts.html";
    }

}
