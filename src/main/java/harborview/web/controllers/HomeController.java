package harborview.web.controllers;

import harborview.dao.MaunaloaDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Locale;

@Controller
@RequestMapping("/")
public class HomeController {

    private final MaunaloaDAO maunaloaDAO;

    @Autowired
    public HomeController(MaunaloaDAO maunaloaDAO) {
        this.maunaloaDAO = maunaloaDAO;
    }

    @RequestMapping(method =  RequestMethod.GET)
    public String index(Locale locale, Model model) {
        model.addAttribute("stockTickers", maunaloaDAO.getStocks());
        return "index.html";
    }

}
