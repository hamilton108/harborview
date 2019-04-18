package harborview.controllers;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import harborview.dto.html.StockPriceDTO;
import harborview.maunaloa.models.MaunaloaModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {
    private final MaunaloaModel maunaloaModel;


    @Autowired
    public MaunaloaController(MaunaloaModel maunaloaModel) {
        this.maunaloaModel = maunaloaModel;
    }

    @ResponseBody
    @GetMapping(value = "tickers", produces = MediaType.APPLICATION_JSON_VALUE)
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
    @GetMapping(value = "spot/{ticker}/{rc}",  produces = MediaType.APPLICATION_JSON_VALUE)
    public StockPriceDTO spot(@PathVariable("ticker") int ticker, @PathVariable("rc") boolean resetCache) {
        return maunaloaModel.spot(ticker,resetCache);
    }

}
