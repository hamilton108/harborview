package harborview.web.controllers;

import harborview.dao.MaunaloaDAO;
import harborview.dto.html.SelectItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;
import java.util.Locale;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {

    // private final StockMarketRepository stockMarketRepository;
    private final MaunaloaDAO maunaloaDAO;

    @Autowired
    public MaunaloaController(MaunaloaDAO maunaloaDAO) {
        this.maunaloaDAO = maunaloaDAO;
    }

    @RequestMapping(value = "charts", method =  RequestMethod.GET)
    public String charts(Locale locale, Model model) {
        model.addAttribute("getStockTickers", maunaloaDAO.getStocks());
        return "maunaloa/charts.html";
    }

    @ResponseBody
    @RequestMapping(value = "tickers", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Collection<SelectItem> tickers(Locale locale, Model model) {
        return maunaloaDAO.getStockTickers();
    }

}
