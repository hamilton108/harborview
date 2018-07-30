package harborview.web.controllers;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import harborview.dto.html.options.OptionPurchaseDTO;
import harborview.dto.html.options.OptionRegPurDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.maunaloa.MaunaloaModel;
import harborview.web.controllers.web.JsonResult;
import oahu.exceptions.FinancialException;
import oahu.financial.OptionPurchase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.Locale;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {

    // private final StockMarketRepository stockMarketRepository;
    private final MaunaloaModel maunaloaModel;

    @Autowired
    public MaunaloaController(MaunaloaModel maunaloaModel) {
        this.maunaloaModel = maunaloaModel;
    }

    @RequestMapping(value = "charts", method =  RequestMethod.GET)
    public String charts(Locale locale, Model model) {
        model.addAttribute("stockTickers", maunaloaModel.getStocks());
        return "maunaloa/charts.html";
    }

    @RequestMapping(value = "optiontickers", method =  RequestMethod.GET)
    public String options(Locale locale, Model model) {
        return "maunaloa/options.html";
    }

    @ResponseBody
    @RequestMapping(value = "tickers", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Collection<SelectItem> tickers() {
        return maunaloaModel.getStockTickers();
    }

    @ResponseBody
    @RequestMapping(value = "ticker/{oid}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts ticker(@PathVariable("oid") int oid,
                            @PathVariable("rc") boolean resetCache) {
        return maunaloaModel.elmChartsDay(oid);
    }
    @ResponseBody
    @RequestMapping(value = "tickerweek/{oid}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts tickerWeek(@PathVariable("oid") int oid,
                            @PathVariable("rc") boolean resetCache) {
        return maunaloaModel.elmChartsWeek(oid);
    }
    @ResponseBody
    @RequestMapping(value = "calls/{ticker}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public StockAndOptions calls(@PathVariable("ticker") int ticker, @PathVariable("rc") boolean resetCache) {
        return maunaloaModel.calls(ticker);
    }

    @ResponseBody
    @RequestMapping(value = "purchaseoption", method =  RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult purchaseOption(@RequestBody OptionPurchaseDTO dto) {
        try {
            OptionPurchase purchase = maunaloaModel.purchaseOption(dto);
            return new JsonResult(true, String.format("Option purchase oid: %d",  purchase.getOid()), 0);
        }
        catch (FinancialException fx) {
            return new JsonResult(false, fx.getMessage(), 1);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }

    @ResponseBody
    @RequestMapping(value = "regpuroption", method =  RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult registerAndPurchaseOption(@RequestBody OptionRegPurDTO dto) {
        try {
            OptionPurchase purchase = maunaloaModel.registerAndPurchaseOption(dto);
            return new JsonResult(true, String.format("Option purchase oid: %d",  purchase.getOid()), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }
}
