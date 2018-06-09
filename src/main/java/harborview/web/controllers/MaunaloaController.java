package harborview.web.controllers;

import harborview.dto.html.SelectItem;
import harborview.maunaloa.MaunaloaCommon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;
import java.util.Locale;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {

    // private final StockMarketRepository stockMarketRepository;
    private final MaunaloaCommon maunaloaCommon;

    @Autowired
    public MaunaloaController(MaunaloaCommon maunaloaCommon) {
        this.maunaloaCommon = maunaloaCommon;
    }

    @RequestMapping(value = "charts", method =  RequestMethod.GET)
    public String charts(Locale locale, Model model) {
        model.addAttribute("stockTickers", maunaloaCommon.getStocks());
        return "maunaloa/charts.html";
    }

    @ResponseBody
    @RequestMapping(value = "tickers", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Collection<SelectItem> tickers() {
        return maunaloaCommon.getStockTickers();
    }

    @ResponseBody
    @RequestMapping(value = "ticker", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Collection<SelectItem> ticker(@RequestParam("oid") int oid,
                                         @RequestParam("rc") int rc) {
        return null;
    }

}
