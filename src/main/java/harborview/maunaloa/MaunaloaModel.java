package harborview.maunaloa;

import com.google.common.collect.Lists;
import harborview.dto.html.Candlestick;
import harborview.dto.html.Chart;
import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import harborview.dto.html.options.OptionDTO;
import harborview.dto.html.options.OptionPurchaseDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.dto.html.options.StockPriceDTO;
import oahu.dto.Tuple;
import oahu.dto.Tuple3;
import oahu.exceptions.FinancialException;
import oahu.financial.DerivativePrice;
import oahu.financial.OptionPurchase;
import oahu.financial.Stock;
import oahu.financial.StockPrice;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;
import vega.filters.Filter;
import vega.filters.ehlers.CyberCycle;
import vega.filters.ehlers.Itrend;
import vega.filters.ehlers.RoofingFilter;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
    etrade;
    //private EtradeRepository etrade;
    private Collection<Stock> stocks;
    private LocalDate startDate = LocalDate.of(2014,1,1);
    private Map<Integer,String> tixMap;

    private Filter calcItrend10 = new Itrend(10);
    private Filter calcItrend50 = new Itrend(50);
    private Filter calcCyberCycle10 = new CyberCycle(10);
    private Filter roofingFilter = new RoofingFilter();
    //private Map<Integer, StockAndOptions> stockAndOptionsMap = new HashMap<>();

    private Map<Integer,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
    stockAndOptionsMap = new HashMap<>();

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
    private String toIso8601(LocalDate d) {
        int year = d.getYear();
        int month = d.getMonthValue();
        int day = d.getDayOfMonth();
        return String.format("%d-%02d-%02d", year,month,day);
    }
    private double roundToNumDecimals(double value, double roundFactor) {
        double tmp = Math.round(value*roundFactor);
        return tmp/roundFactor;
    }
    private double roundToNumDecimals(double value) {
        return roundToNumDecimals(value,10.0);
    }

    private long hRuler(LocalDate d) {
        return ChronoUnit.DAYS.between(startDate,d);
    }

    private Chart mainChart(List<Double> spots, List<StockPrice> winSpots) {
        List<Double> itrend10 = calcItrend10.calculate(spots).stream()
                                .map(this::roundToNumDecimals).collect(Collectors.toList());
        List<Double> itrend50 = calcItrend50.calculate(spots).stream()
                .map(this::roundToNumDecimals).collect(Collectors.toList());
        List<Candlestick> candlesticks = winSpots.stream().map(x -> new Candlestick(x)).collect(Collectors.toList());
        Chart chart = new Chart();
        chart.addLine(Lists.reverse(itrend10));
        chart.addLine(Lists.reverse(itrend50));
        chart.setCandlesticks(Lists.reverse(candlesticks));
        return chart;
    }

    private Chart cyberCycleChart(List<Double> spots) {
        Chart chart = new Chart();
        List<Double> cc10 = calcCyberCycle10.calculate(spots).stream()
                .map(this::roundToNumDecimals).collect(Collectors.toList());
        List<Double> cc10rf = roofingFilter.calculate(cc10).stream()
                .map(this::roundToNumDecimals).collect(Collectors.toList());
        chart.addLine(Lists.reverse(cc10));
        chart.addLine(Lists.reverse(cc10rf));
        return chart;
    }

    private Chart volumeChart(List<StockPrice> spots) {
        Chart chart = new Chart();
        List<Double> vol = spots.stream().map(x -> (double)x.getVolume()).collect(Collectors.toList());
        OptionalDouble maxVol = vol.stream().mapToDouble(v -> v).max();
        maxVol.ifPresent(v -> {
           List<Double> normalized = vol.stream().map(x -> x/v).collect(Collectors.toList()); 
           chart.addBar(Lists.reverse(normalized));
           //chart.addLine(Lists.reverse(calcItrend10.calculate(normalized)));
        });
        return chart;
    }

    private ElmCharts elmCharts(Collection<StockPrice> prices) {
        ElmCharts result = new ElmCharts();
        int totalNum = prices.size();
        int skipNum = totalNum - 400;
        List<StockPrice> winSpots = prices.stream().skip(skipNum).collect(Collectors.toList());
        List<Double> spots = winSpots.stream().map(x -> x.getCls()).collect(Collectors.toList());

        result.setChart(mainChart(spots,winSpots));
        result.setChart2(cyberCycleChart(spots));
        result.setChart3(volumeChart(winSpots));

        List<LocalDate> dx = winSpots.stream().map(StockPrice::getLocalDx).collect(Collectors.toList());
        List<Long> xAxis = dx.stream().map(this::hRuler).collect(Collectors.toList());
        result.setxAxis(Lists.reverse(xAxis));
        result.setMinDx(toIso8601(startDate));
        return result;
    }

    public ElmCharts elmChartsDay(int stockId) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
        return elmCharts(prices);
    }

    public ElmCharts elmChartsWeek(int stockId) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
        return elmCharts(prices);
    }

    public ElmCharts elmChartsMonth(int stockId) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
        return elmCharts(prices);
    }

    private StockAndOptions callsOrPuts(int oid, boolean isCalls) {

        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
        tmp = stockAndOptionsMap.get(oid);

        if (tmp == null) {
            String ticker = getTickerFor(oid);
            tmp = etrade.parseHtmlFor(ticker,null);
            stockAndOptionsMap.put(oid,tmp);
        }
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

    private int findOptionOid(String ticker) {
        return 3;
    }
    public OptionPurchase purchaseOption(OptionPurchaseDTO dto)
    throws FinancialException {
        int purchaseType = dto.isRt() ? 3 : 11;
        return stockMarketRepository.registerOptionPurchase(purchaseType, dto.getTicker(), dto.getAsk(), dto.getVolume(), dto.getSpot(), dto.getBid());
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    public void setEtrade(EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>> etrade) {
        this.etrade = etrade;
    }
}
