package harborview.web.controllers;

import harborview.dto.html.SelectItem;
import oahu.financial.repository.StockMarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
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
    public String charts(Locale locale, Model model) {
        model.addAttribute("stockTickers", stockMarketRepository.getStocks());
        return "maunaloa/charts.html";
    }

    @ResponseBody
    @RequestMapping(value = "tickers", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public List<SelectItem> tickers(Locale locale, Model model) {
        List<SelectItem> result = new ArrayList<>();
        result.add(new SelectItem("YAR", "3"));
        return result;
    }

}
