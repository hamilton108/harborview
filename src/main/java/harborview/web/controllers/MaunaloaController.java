package harborview.web.controllers;

import oahu.financial.repository.StockMarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Locale;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {

    private final StockMarketRepository stockMarketRepository;

    @Autowired
    MaunaloaController(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
    @RequestMapping(value = "charts", method =  RequestMethod.GET)
    public String index(Locale locale, Model model) {
        model.addAttribute("stockTickers", stockMarketRepository.getStocks());
        return "maunaloa/charts.html";
    }

}
