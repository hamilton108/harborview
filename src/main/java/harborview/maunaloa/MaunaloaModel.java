package harborview.maunaloa;

import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import harborview.dto.html.options.*;
import oahu.dto.Tuple;
import oahu.dto.Tuple3;
import oahu.exceptions.FinancialException;
import oahu.financial.*;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
    etrade;
    //private EtradeRepository etrade;
    private Collection<Stock> stocks;
    private LocalDate startDate = LocalDate.of(2010,1,1);
    private Map<Integer,String> tixMap;

    //private Map<Integer, StockAndOptions> stockAndOptionsMap = new HashMap<>();

    private Map<Integer,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
    stockAndOptionsMap = new HashMap<>();

    private Map<Integer,ElmCharts> elmChartsDayMap = new HashMap<>();
    private Map<Integer,ElmCharts> elmChartsWeekMap = new HashMap<>();

    public enum ElmChartType { DAY, WEEK, MONTH };

    public void resetElmChartsCache(ElmChartType elmChartType) {
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
        return getStocks().stream().map(x -> new SelectItem(x.getTicker(),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }
    public Collection<Stock> getStocks() {
        if (stocks == null) {
            stocks =  stockMarketRepository.getStocks();
        }
        return stocks;
    }
    private String getTickerFor(int stockId) {
        if (tixMap == null) {
            Collection<Stock> sx = getStocks();
            tixMap = new HashMap<>();
            for (Stock s : sx) {
               tixMap.put(s.getOid(),s.getTicker());
            }
        }
        return tixMap.get(stockId);
    }

    public ElmCharts elmChartsDay(int stockId) {
        ElmCharts result = elmChartsDayMap.get(stockId);
        if (result == null) {
            Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
            ElmChartsFactory factory = new ElmChartsFactory();
            result = factory.elmCharts(prices);
            elmChartsDayMap.put(stockId,result);
        }
        return result;
    }

    public ElmCharts elmChartsWeek(int stockId) {
        ElmCharts result = elmChartsWeekMap.get(stockId);
        if (result == null) {
            Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
            ElmChartsFactory factory = new ElmChartsWeekFactory();
            result = factory.elmCharts(prices);
            elmChartsWeekMap.put(stockId,result);
        }
        return result;
    }

    public ElmCharts elmChartsMonth(int stockId) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
        return null; // elmCharts(prices);
    }

    public void resetSpotAndOptions() {
        stockAndOptionsMap = new HashMap<>();
    }
    private Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
    stockAndOptions(int oid) {
        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
                tmp = stockAndOptionsMap.get(oid);
        if (tmp == null) {
            String ticker = getTickerFor(oid);
            tmp = etrade.parseHtmlFor(ticker,null);
            stockAndOptionsMap.put(oid,tmp);
        }
        return tmp;
    }
    private StockAndOptions callsOrPuts(int oid, boolean isCalls) {
        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
                tmp = stockAndOptions(oid);
        StockPriceDTO stockPrice = null;
        if (tmp.first().isPresent()) {
            stockPrice = new StockPriceDTO(tmp.first().get());
        }
        Collection<DerivativePrice> prices =
                isCalls ? tmp.second() : tmp.third();

        List<OptionDTO> options = prices.stream().map(x -> new OptionDTO(x)).collect(Collectors.toList());

        return new StockAndOptions(stockPrice, options);
    }
    public StockAndOptions calls(int oid) {
        return callsOrPuts(oid, true);
    }
    public StockAndOptions puts(int oid) {
        return callsOrPuts(oid, false);
    }
    public StockPriceDTO spot(int oid) {
        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
                tmp = stockAndOptions(oid);
        StockPriceDTO sp = null;
        if (tmp.first().isPresent()) {
            sp = new StockPriceDTO(tmp.first().get());
        }
        return sp;
    }

    private int findOptionOid(String ticker) {
        return 3; //getStocks().stream().filter(x -> x.getTicker().equals(ticker)).findFirst();
    }
    private Optional<Stock> findStock(int stockId) {
        return getStocks().stream().filter(x -> x.getOid() == stockId).findFirst();
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

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    public void setEtrade(EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>> etrade) {
        this.etrade = etrade;
    }
}
