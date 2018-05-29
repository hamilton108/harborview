package harborview.web.controllers;

import oahu.financial.Derivative;
import oahu.financial.Stock;
import oahu.financial.StockPrice;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.ui.Model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Controller
@RequestMapping("/")
public class HomeController {
    @RequestMapping(method =  RequestMethod.GET)
    public String index(Locale locale, Model model) {
        model.addAttribute("stockTickers", getStocks());
        return "index.html";
    }
    private List<Stock> getStocks() {
        List<Stock> result = new ArrayList<>();
        result.add(new StockDemo("NHY", 1));
        result.add(new StockDemo("YAR", 2));
        result.add(new StockDemo("STL", 3));
        return result;
    }
}
class StockDemo implements Stock {
    private final String ticker;
    private final int oid;
    public StockDemo(String ticker, int oid) {
        this.ticker = ticker;
        this.oid = oid;
    }
    @Override
    public String getCompanyName() {
        return null;
    }

    @Override
    public String getTicker() {
        return ticker;
    }

    @Override
    public int getTickerCategory() {
        return 0;
    }

    @Override
    public int getOid() {
        return oid;
    }

    @Override
    public List<StockPrice> getPrices() {
        return null;
    }

    @Override
    public List<Derivative> getDerivatives() {
        return null;
    }
}
