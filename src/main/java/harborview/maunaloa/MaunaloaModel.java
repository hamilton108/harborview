package harborview.maunaloa;

import com.google.common.collect.Lists;
import harborview.dto.html.Candlestick;
import harborview.dto.html.Chart;
import harborview.dto.html.ElmCharts;
import harborview.dto.html.SelectItem;
import oahu.financial.Stock;
import oahu.financial.StockPrice;
import oahu.financial.repository.StockMarketRepository;
import vega.filters.Filter;
import vega.filters.ehlers.CyberCycle;
import vega.filters.ehlers.Itrend;
import vega.filters.ehlers.RoofingFilter;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class MaunaloaModel {
    private StockMarketRepository stockMarketRepository;
    private Collection<Stock> stocks;
    private Ehlers ehlersDay;
    private LocalDate startDate = LocalDate.of(2014,1,1);

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
        return "YAR";
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
    /*
    private long diffDays(LocalDate d1, LocalDate d2) {
        return ChronoUnit.DAYS.between(d1,d2);
    }
    */
    private long hRuler(LocalDate d) {
        return ChronoUnit.DAYS.between(startDate,d);
    }

    private ElmCharts elmCharts(Collection<StockPrice> prices) {
        ElmCharts result = new ElmCharts();
        result.setMinDx(toIso8601(startDate));
        int totalNum = prices.size();
        int skipNum = totalNum - 400;
        List<StockPrice> winSpots = prices.stream().skip(skipNum).collect(Collectors.toList());
        List<Double> spots = winSpots.stream().map(x -> x.getCls()).collect(Collectors.toList());
        Filter calcItrend10 = new Itrend(10);
        Filter calcCyberCycle10 = new CyberCycle(10);
        Filter roofingFilter = new RoofingFilter();
        List<Double> itrend10 = calcItrend10.calculate(spots).stream()
                                .map(x -> roundToNumDecimals(x)).collect(Collectors.toList());

        List<LocalDate> dx = winSpots.stream().map(StockPrice::getLocalDx).collect(Collectors.toList());

        List<Candlestick> candlesticks = winSpots.stream().map(x -> new Candlestick(x)).collect(Collectors.toList());
        //List<Double> cc10 = calcCyberCycle10.calculate(spots);
        //:List<Double> cc10rf = roofingFilter.calculate(cc10);

        List<Long> xAxis = dx.stream().map(this::hRuler).collect(Collectors.toList());
        Chart chart = new Chart();
        chart.addLine(Lists.reverse(itrend10));
        chart.setCandlesticks(Lists.reverse(candlesticks));
        result.setChart(chart);
        result.setxAxis(Lists.reverse(xAxis));
        return result;
    }
    public ElmCharts elmChartsDay(int stockId) {
        Collection<StockPrice> prices = stockMarketRepository.findStockPrices(getTickerFor(stockId),startDate);
        return elmCharts(prices);
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    public void setEhlersDay(Ehlers ehlersDay) {
        this.ehlersDay = ehlersDay;
    }
}
