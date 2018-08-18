package harborview.web.controllers;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.SelectItem;
import harborview.dto.html.options.*;
import harborview.maunaloa.MaunaloaModel;
import harborview.web.controllers.web.JsonResult;
import oahu.exceptions.FinancialException;
import oahu.financial.OptionPurchase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import static harborview.maunaloa.MaunaloaModel.ElmChartType;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {

    // private final StockMarketRepository stockMarketRepository;
    private final MaunaloaModel maunaloaModel;

    static boolean DEBUG = true;

    @Autowired
    public MaunaloaController(MaunaloaModel maunaloaModel) {
        this.maunaloaModel = maunaloaModel;
    }

    @RequestMapping(value = "charts", method =  RequestMethod.GET)
    public String charts(Locale locale, Model model) {
        //model.addAttribute("stockTickers", maunaloaModel.getStocks());
        return "maunaloa/charts.html";
    }

    @RequestMapping(value = "optiontickers", method =  RequestMethod.GET)
    public String options(Locale locale, Model model) {
        return "maunaloa/options.html";
    }
    @RequestMapping(value = "optionpurchases", method =  RequestMethod.GET)
    public String optionpurchases(Locale locale, Model model) {
        return "maunaloa/optionpurchases.html";
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
        if (resetCache){
            maunaloaModel.resetElmChartsCache(ElmChartType.DAY);
        }
        return maunaloaModel.elmChartsDay(oid);
    }
    @ResponseBody
    @RequestMapping(value = "tickerweek/{oid}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts tickerWeek(@PathVariable("oid") int oid,
                            @PathVariable("rc") boolean resetCache) {
        if (resetCache){
            maunaloaModel.resetElmChartsCache(ElmChartType.WEEK);
        }
        return maunaloaModel.elmChartsWeek(oid);
    }
    @ResponseBody
    @RequestMapping(value = "calls/{ticker}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public StockAndOptions calls(@PathVariable("ticker") int ticker, @PathVariable("rc") boolean resetCache) {
        if (resetCache) {
            maunaloaModel.resetSpotAndOptions();
        }
        if (DEBUG) {
            StockAndOptions calls = maunaloaModel.calls(ticker);
            List<OptionDTO> debugCalls = calls.getOptions().stream().
                    filter(x -> x.getTicker().equals("YAR9C360")).collect(Collectors.toList());
            StockAndOptions debugResult = new StockAndOptions(calls.getStock(), debugCalls);
            return debugResult;
        }
        else {
            return maunaloaModel.calls(ticker);
        }
    }
    @ResponseBody
    @RequestMapping(value = "puts/{ticker}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public StockAndOptions puts(@PathVariable("ticker") int ticker, @PathVariable("rc") boolean resetCache) {
        if (resetCache) {
            maunaloaModel.resetSpotAndOptions();
        }
        return maunaloaModel.puts(ticker);
    }

    @ResponseBody
    @RequestMapping(value = "spot/{ticker}/{rc}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public StockPriceDTO spot(@PathVariable("ticker") int ticker, @PathVariable("rc") boolean resetCache) {
        if (resetCache) {
            maunaloaModel.resetSpotAndOptions();
        }
        return maunaloaModel.spot(ticker);
    }

    @ResponseBody
    @RequestMapping(value = "purchaseoption", method =  RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult purchaseOption(@RequestBody OptionPurchaseDTO dto) {
        return new JsonResult(true, String.format("Option purchase oid: %d",  12), 0);
        /*
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
        */
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

    @ResponseBody
    @RequestMapping(value = "risclines/{ticker}", method =  RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public List<RiscLinesDTO> riscLines(@PathVariable("ticker") int ticker) {
        return maunaloaModel.fetchRiscLines(ticker);
    }

    @ResponseBody
    @RequestMapping(value = "calcriscstockprices", method =  RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OptionRiscDTO> calcRiscStockprices(@RequestBody List<OptionRiscDTO> riscs) {
        List<OptionRiscDTO> result = maunaloaModel.calcStockPricesFor(riscs);
        return result;
    }
}
