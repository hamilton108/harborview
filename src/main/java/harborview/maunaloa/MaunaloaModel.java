package harborview.maunaloa;

import critterrepos.beans.options.OptionPurchaseBean;
import critterrepos.beans.options.OptionSaleBean;
import critterrepos.models.impl.CachedStockMarketReposImpl;
import harborview.dto.html.ElmCharts;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.SelectItem;
import harborview.dto.html.options.*;
import harborview.maunaloa.charts.ElmChartsFactory;
import harborview.maunaloa.charts.ElmChartsMonthFactory;
import harborview.maunaloa.charts.ElmChartsWeekFactory;
import harborview.maunaloa.repos.OptionRepository;
import harborview.maunaloa.repos.OptionRiscRepos;
import oahu.dto.Tuple;
import oahu.dto.Tuple3;
import oahu.exceptions.FinancialException;
import oahu.financial.*;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;

import java.time.LocalDate;
import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Collectors;

public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private OptionCalculator optionCalculator;
    private LocalDate startDate = LocalDate.of(2010,1,1);

    private Map<Integer,ElmCharts> elmChartsDayMap = new HashMap<>();
    private Map<Integer,ElmCharts> elmChartsWeekMap = new HashMap<>();
    private Map<Integer, ElmCharts> elmChartsMonthMap = new HashMap<>();
    private OptionRepository optionRepos;
    private OptionRiscRepos optionRiscRepos;
    private EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
        etrade;

    //private ChachedEtradeRepository<Tuple<String>> cachedEtrade;

    public Collection<Stock> getStocks() {
       return stockMarketRepository.getStocks();
    }

    public void clearRiscLines(int ticker) {
        optionRiscRepos.clearRiscLines(ticker);
    }


    public enum ElmChartType { DAY, WEEK, MONTH }

    public void resetElmChartsCache(ElmChartType elmChartType) {
        if (stockMarketRepository instanceof CachedStockMarketReposImpl) {
            ((CachedStockMarketReposImpl)stockMarketRepository).emptyCache();
        }
        switch (elmChartType) {
            case DAY:
                elmChartsDayMap = new HashMap<>();
                break;
            case WEEK:
                elmChartsWeekMap = new HashMap<>();
                break;
            case MONTH:
                elmChartsMonthMap = new HashMap<>();
                break;
        }
    }

    public Collection<SelectItem> getStockTickers() {
        return stockMarketRepository.getStocks().stream().map(
                x -> new SelectItem(String.format("%s - %s",x.getTicker(),x.getCompanyName()),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }

    public void resetSpotAndOptions() {
        //optionRepos.resetSpotAndOptions();
        //optionRepos.resetSpotAndOptions();
        optionRiscRepos.resetSpotAndOptions();
    }
    public StockAndOptions calls(int oid) {
        //return optionRepos.calls(oid);
        return optionRiscRepos.calls(oid);
    }
    public StockAndOptions puts(int oid) {
        //return optionRepos.puts(oid);
        return optionRiscRepos.puts(oid);
    }

    public ElmCharts elmCharts(int stockId, ElmChartsFactory factory, Consumer<ElmCharts> storeFn) {
        ElmCharts result = elmChartsWeekMap.get(stockId);
        if (result == null) {
            Collection<StockPrice> prices = stockMarketRepository.findStockPrices(
                    stockMarketRepository.getTickerFor(stockId),startDate);
            result = factory.elmCharts(prices);
            storeFn.accept(result);
        }
        return result;
    }
    public ElmCharts elmChartsDay(int stockId) {
        return elmCharts(stockId, new ElmChartsFactory(), result -> {
            elmChartsDayMap.put(stockId, result);
        });
    }

    public ElmCharts elmChartsWeek(int stockId) {
        return elmCharts(stockId, new ElmChartsWeekFactory(), result -> {
            elmChartsWeekMap.put(stockId, result);
        });
    }

    public ElmCharts elmChartsMonth(int stockId) {
        return elmCharts(stockId, new ElmChartsMonthFactory(), result -> {
            elmChartsMonthMap.put(stockId, result);
        });
    }

    public StockPriceDTO spot(int oid) {
        return optionRiscRepos.spot(oid);
    }

    private Optional<Stock> findStock(int stockId) {
        return stockMarketRepository.getStocks().stream().filter(x -> x.getOid() == stockId).findFirst();
    }

    public OptionPurchase purchaseOption(OptionPurchaseDTO dto)
    throws FinancialException {
        int purchaseType = dto.isRt() ? 3 : 11;
        return stockMarketRepository.registerOptionPurchase(purchaseType, dto.getTicker(), dto.getAsk(), dto.getVolume(), dto.getSpot(), dto.getBid());
    }

    public OptionPurchase registerAndPurchaseOption(OptionRegPurDTO dto)
            throws FinancialException {
        Optional<Stock> stock = findStock(dto.getStockId());

        if (!stock.isPresent()) {
            throw new FinancialException(String.format("Stock with oid %d not present!", dto.getStockId()));
        }

        Derivative derivative = dto.createDerivative(stock.get());

        stockMarketRepository.insertDerivative(derivative, null);

        return purchaseOption(dto);
    }

    public List<PurchaseWithSalesDTO> optionPurchases(
        int purchaseType,
        int status,
        Derivative.OptionType ot) {
        Collection<OptionPurchase> purchases =  stockMarketRepository.purchasesWithSalesAll(purchaseType,status,null);
        optionRepos.setOptionPurchases(purchases);
        List<PurchaseWithSalesDTO> result =
            purchases.stream()
                .map(x -> new PurchaseWithSalesDTO(x, etrade, optionCalculator))
                .collect(Collectors.toList());
        for (PurchaseWithSalesDTO p : result) {
            p.setEtrade(etrade);
        }
        return result;
    }
    public List<RiscLinesDTO> fetchRiscLines(int oid) {
        return optionRiscRepos.getRiscLines(oid);
    }

    public List<OptionRiscDTO> calcStockPricesFor(int oid, List<OptionRiscDTO> riscs) {
        /*
        List<OptionRiscDTO> result = new ArrayList<>();
        riscs.forEach(x -> {
            DerivativePrice price = optionRepos.getOptionFor(x.getTicker());
            double curOptionPrice = price.getSell() - x.getRisc();
            Optional<Double> stockPrice = price.stockPriceFor(curOptionPrice);
            stockPrice.ifPresent(s -> result.add(new OptionRiscDTO(x.getTicker(), s)));
        });
        return result;
        */
        //String stockTicker= stockMarketRepository.getTickerFor(oid);
        return optionRiscRepos.calcRiscs(oid, riscs);
    }

    public OptionPriceForDTO optionPriceFor(String optionTicker, double levelValue) {
        DerivativePrice option = optionRepos.getOptionFor(optionTicker);
        double curOptionPrice = option.optionPriceFor(levelValue);
        return new OptionPriceForDTO(curOptionPrice,option.getCurrentRisc());
    }

    public int sellPurchase(OptionSaleBean dto) {
        OptionPurchaseBean p = (OptionPurchaseBean)optionRepos.getPurchaseFor(dto.getPurchaseOid());
        p.addSale(dto);
        return dto.getOid();
    }
    //region Properties
    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
    public void setOptionRiscRepos(OptionRiscRepos optionRiscRepos) {
        this.optionRiscRepos = optionRiscRepos;
    }

    public void setOptionCalculator(OptionCalculator optionCalculator) {
        this.optionCalculator = optionCalculator;
    }
    public void setEtrade(EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
                                  etrade) {
        this.etrade = etrade;
    }
    /*
    public void setCachedEtrade(ChachedEtradeRepository<Tuple<String>> cachedEtrade) {
        this.cachedEtrade = cachedEtrade;
    }
    */
    //endregion
}
