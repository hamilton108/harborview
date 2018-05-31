package harborview.web.controllers;

import oahu.financial.repository.StockMarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Locale;

@Controller
@RequestMapping("/")
public class HomeController {

    private final StockMarketRepository stockMarketRepository;

    @Autowired
    HomeController(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    @RequestMapping(method =  RequestMethod.GET)
    public String index(Locale locale, Model model) {
        //Collection<Stock> stocks = stockMarketRepository.getStocks();
        model.addAttribute("stockTickers", stockMarketRepository.getStocks());
        return "index.html";
    }

}
