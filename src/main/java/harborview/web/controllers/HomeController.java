package harborview.web.controllers;

import harborview.maunaloa.MaunaloaCommon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Locale;

@Controller
@RequestMapping("/")
public class HomeController {

    private final MaunaloaCommon maunaloaCommon;

    @Autowired
    public HomeController(MaunaloaCommon maunaloaCommon) {
        this.maunaloaCommon = maunaloaCommon;
    }

    @RequestMapping(method =  RequestMethod.GET)
    public String index(Locale locale, Model model) {
        model.addAttribute("stockTickers", maunaloaCommon.getStocks());
        return "index.html";
    }

}
