package harborview.maunaloa.models;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.SelectItem;
import harborview.dto.html.StockPriceDTO;
import harborview.dto.html.options.OptionRiscDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.maunaloa.charts.ElmChartsFactory;
import harborview.maunaloa.charts.ElmChartsMonthFactory;
import harborview.maunaloa.charts.ElmChartsWeekFactory;
import harborview.maunaloa.repos.OptionRiscRepos;
import oahu.financial.StockPrice;
import oahu.financial.repository.StockMarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

@Component
@CacheConfig(cacheNames = {"maunaloaModel"})
public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private OptionRiscRepos optionRiscRepos;
    private LocalDate startDate = LocalDate.of(2010,1,1);


    @Autowired
    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    @Autowired
    public void setOptionRiscRepos(OptionRiscRepos optionRiscRepos) {
        this.optionRiscRepos = optionRiscRepos;
    }

    public StockPriceDTO spot(int ticker) {
        return null;
    }



    public enum ElmChartType { DAY, WEEK, MONTH }

    public Collection<SelectItem> getStockTickers() {
        return stockMarketRepository.getStocks().stream().map(
                x -> new SelectItem(String.format("%s - %s",x.getTicker(),x.getCompanyName()),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }

    private ElmCharts elmCharts(int stockId, ElmChartsFactory factory) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(
                stockMarketRepository.getTickerFor(stockId),startDate);
        return factory.elmCharts(prices);
    }

    public ElmCharts elmChartsDay(int stockId) {
        return elmCharts(stockId, new ElmChartsFactory());
    }
    public ElmCharts elmChartsWeek(int stockId) {
        return elmCharts(stockId, new ElmChartsWeekFactory());
    }
    public ElmCharts elmChartsMonth(int stockId) {
        return elmCharts(stockId, new ElmChartsMonthFactory());
    }

    //----------------------------------------------------------------
    //--------------------------- Options ----------------------------
    //----------------------------------------------------------------
    public StockAndOptions calls(int oid) {
        return optionRiscRepos.calls(oid);
    }
    public StockAndOptions puts(int oid) {
        return optionRiscRepos.puts(oid);
    }
    public List<OptionRiscDTO> calcStockPricesFor(int oid, List<OptionRiscDTO> riscs) {
        return optionRiscRepos.calcRiscs(oid, riscs);
    }

    //----------------------------------------------------------------
    //-------------------------- Risc Lines --------------------------
    //----------------------------------------------------------------
    public List<RiscLinesDTO> fetchRiscLines(int oid) {
        return optionRiscRepos.getRiscLines(oid);
    }
}

