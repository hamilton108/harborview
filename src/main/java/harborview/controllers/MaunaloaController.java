package harborview.controllers;

import com.gargoylesoftware.htmlunit.javascript.host.canvas.ext.OES_standard_derivatives;
import critterrepos.beans.options.DerivativePriceBean;
import harborview.dto.html.*;
import harborview.dto.html.options.OptionPriceForDTO;
import harborview.dto.html.options.OptionRiscDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.maunaloa.models.MaunaloaModel;
import oahu.financial.Derivative;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {
    private final MaunaloaModel maunaloaModel;

    @Autowired
    public MaunaloaController(MaunaloaModel maunaloaModel) {
        this.maunaloaModel = maunaloaModel;
    }

    @ResponseBody
    @GetMapping(value = "/tickers", produces = MediaType.APPLICATION_JSON_VALUE)
    public Collection<SelectItem> tickers() {
        return maunaloaModel.getStockTickers();
    }

    @GetMapping(value = "/")
    public String index() {
        return "maunaloa/charts";
    }


    //public String charts(Locale locale, Model model) {

    @GetMapping(value = "/charts")
    public String charts() {
        return "maunaloa/charts";
    }

    @ResponseBody
    @GetMapping(value = "/days/{oid}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts dayChart(@PathVariable("oid") int oid) {
        return maunaloaModel.elmChartsDay(oid);
    }
    @ResponseBody
    @GetMapping(value = "/weeks/{oid}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts weekChart(@PathVariable("oid") int oid) {
        return maunaloaModel.elmChartsWeek(oid);
    }
    @ResponseBody
    @GetMapping(value = "/months/{oid}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts monthChart(@PathVariable("oid") int oid) {
        return maunaloaModel.elmChartsMonth(oid);
    }

    @ResponseBody
    @GetMapping(value = "/spot/{ticker}",  produces = MediaType.APPLICATION_JSON_VALUE)
    public StockPriceDTO spot(@PathVariable("ticker") int ticker) {
        return maunaloaModel.spot(ticker);
    }

    //----------------------------------------------------------------
    //--------------------------- Options ----------------------------
    //----------------------------------------------------------------
    @GetMapping(value = "/optiontickers")
    public String options() {
        return "maunaloa/options.html";
    }

    @ResponseBody
    @GetMapping(value = "/calls/{ticker}", produces = MediaType.APPLICATION_JSON_VALUE)
    public StockAndOptions calls(@PathVariable("ticker") int ticker) {
        return maunaloaModel.calls(ticker);
    }

    @ResponseBody
    @GetMapping(value = "/puts/{ticker}", produces = MediaType.APPLICATION_JSON_VALUE)
    public StockAndOptions puts(@PathVariable("ticker") int ticker) {
        return maunaloaModel.puts(ticker);
    }

    @ResponseBody
    @PostMapping(
            value = "/calcriscstockprices/{oid}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OptionRiscDTO> calcRiscStockprices(
            @PathVariable("oid") int oid,
            @RequestBody List<OptionRiscDTO> riscs) {
        List<OptionRiscDTO> result = maunaloaModel.calcStockPricesFor(oid,riscs);
        return result;
    }

    @ResponseBody
    @GetMapping(
            value = "/optionprice/{optionticker}/{levelvalue}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public OptionPriceForDTO optionPrice(
            @PathVariable("optionticker") String ticker,
            @PathVariable("levelvalue") double levelValue) {
        return null; //maunaloaModel.optionPriceFor(ticker,levelValue);
    }

    //----------------------------------------------------------------
    //-------------------------- Risc Lines --------------------------
    //----------------------------------------------------------------
    @ResponseBody
    @GetMapping(value = "/risclines/{ticker}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<RiscLinesDTO> riscLines(@PathVariable("ticker") int ticker) {
        List<RiscLinesDTO> result = new ArrayList<>();
        RiscLinesDTO dto = new RiscLinesDTO(new DerivativePriceMock());
        result.add(dto);
        return result;
        //return maunaloaModel.fetchRiscLines(ticker);
    }

    @ResponseBody
    @GetMapping(value = "/clearrisclines/{ticker}", produces = MediaType.APPLICATION_JSON_VALUE)
    public JsonResult clearRiscLines(@PathVariable("ticker") int ticker) {
        try {
            maunaloaModel.clearRiscLines(ticker);
            return new JsonResult(true, String.format("Risc Lines for %d cleared", ticker), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }
}
