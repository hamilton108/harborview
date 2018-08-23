package harborview.maunaloa;

import critterrepos.models.impl.CachedStockMarketReposImpl;
import harborview.dto.html.ElmCharts;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.SelectItem;
import harborview.dto.html.options.*;
import harborview.maunaloa.repos.OptionRepository;
import oahu.dto.Tuple3;
import oahu.exceptions.FinancialException;
import oahu.financial.*;
import oahu.financial.repository.StockMarketRepository;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private LocalDate startDate = LocalDate.of(2010,1,1);

    private Map<Integer,ElmCharts> elmChartsDayMap = new HashMap<>();
    private Map<Integer,ElmCharts> elmChartsWeekMap = new HashMap<>();
    private OptionRepository optionRepos;

    public Collection<Stock> getStocks() {
       return stockMarketRepository.getStocks();
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
                break;
        }
    }

    public Collection<SelectItem> getStockTickers() {
        return stockMarketRepository.getStocks().stream().map(
                x -> new SelectItem(String.format("%s - %s",x.getTicker(),x.getCompanyName()),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }

    public void resetSpotAndOptions() {
        optionRepos.resetSpotAndOptions();
    }
    public StockAndOptions calls(int oid) {
        return optionRepos.calls(oid);
    }
    public StockAndOptions puts(int oid) {
        return optionRepos.puts(oid);
    }

    public ElmCharts elmChartsDay(int stockId) {
        ElmCharts result = elmChartsDayMap.get(stockId);
        if (result == null) {
            Collection<StockPrice> prices = stockMarketRepository.findStockPrices(
                    stockMarketRepository.getTickerFor(stockId),startDate);
            ElmChartsFactory factory = new ElmChartsFactory();
            result = factory.elmCharts(prices);
            elmChartsDayMap.put(stockId,result);
        }
        return result;
    }

    public ElmCharts elmChartsWeek(int stockId) {
        ElmCharts result = elmChartsWeekMap.get(stockId);
        if (result == null) {
            Collection<StockPrice> prices = stockMarketRepository.findStockPrices(
                    stockMarketRepository.getTickerFor(stockId),startDate);
            ElmChartsFactory factory = new ElmChartsWeekFactory();
            result = factory.elmCharts(prices);
            elmChartsWeekMap.put(stockId,result);
        }
        return result;
    }

    public ElmCharts elmChartsMonth(int stockId) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(
                stockMarketRepository.getTickerFor(stockId),startDate);
        return null; // elmCharts(prices);
    }

    public StockPriceDTO spot(int oid) {
        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
                tmp = optionRepos.stockAndOptions(oid);
        StockPriceDTO sp = null;
        if (tmp.first().isPresent()) {
            sp = new StockPriceDTO(tmp.first().get());
        }
        return sp;
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
        return null; //stockMarketRepository.purchasesWithSalesAll(purchaseType,status,null);
    }
    public List<RiscLinesDTO> fetchRiscLines(int oid) {
        return optionRepos.fetchRiscLines(oid);
    }

    public List<OptionRiscDTO> calcStockPricesFor(List<OptionRiscDTO> riscs) {
        List<OptionRiscDTO> result = new ArrayList<>();
        riscs.forEach(x -> {
            DerivativePrice price = optionRepos.getOptionFor(x.getTicker());
            double curOptionPrice = price.getSell() - x.getRisc();
            Optional<Double> stockPrice = price.stockPriceFor(curOptionPrice);
            stockPrice.ifPresent(s -> result.add(new OptionRiscDTO(x.getTicker(), s)));
        });
        return result;
    }

    public OptionPriceForDTO optionPriceFor(String optionTicker, double levelValue) {
        DerivativePrice option = optionRepos.getOptionFor(optionTicker);
        double curOptionPrice = option.optionPriceFor(levelValue);
        return new OptionPriceForDTO(curOptionPrice,option.getCurrentRisc());
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
    public void setOptionRepos(OptionRepository optionRepos) {
        this.optionRepos = optionRepos;
    }
}
