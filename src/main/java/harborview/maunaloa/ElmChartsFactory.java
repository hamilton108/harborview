package harborview.maunaloa;

import com.google.common.collect.Lists;
import harborview.dto.html.Candlestick;
import harborview.dto.html.Chart;
import harborview.dto.html.ElmCharts;
import oahu.financial.StockPrice;
import vega.filters.Filter;
import vega.filters.ehlers.CyberCycle;
import vega.filters.ehlers.Itrend;
import vega.filters.ehlers.RoofingFilter;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Collection;
import java.util.List;
import java.util.OptionalDouble;
import java.util.stream.Collectors;

public class ElmChartsFactory {
    private Filter calcItrend10 = new Itrend(10);
    private Filter calcItrend50 = new Itrend(50);
    private Filter calcCyberCycle10 = new CyberCycle(10);
    private Filter roofingFilter = new RoofingFilter();

    private LocalDate startDate = LocalDate.of(2014,1,1);
    private double roundToNumDecimals(double value) {
        return roundToNumDecimals(value,10.0);
    }
    private double roundToNumDecimals(double value, double roundFactor) {
        double tmp = Math.round(value*roundFactor);
        return tmp/roundFactor;
    }
    private String toIso8601(LocalDate d) {
        int year = d.getYear();
        int month = d.getMonthValue();
        int day = d.getDayOfMonth();
        return String.format("%d-%02d-%02d", year,month,day);
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
    public ElmCharts elmCharts(Collection<StockPrice> prices) {
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
}