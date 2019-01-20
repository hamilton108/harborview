package harborview.maunaloa.repos;

import critterrepos.beans.options.DerivativeBean;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.options.*;
import oahu.dto.Tuple;
import oahu.dto.Tuple3;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;

import java.util.*;
import java.util.stream.Collectors;

public class OptionRiscRepos {
    private EtradeRepository<Tuple<String>,
                Tuple3<Optional<StockPrice>,Collection<DerivativePrice>, Collection<DerivativePrice>>> etrade;
    private StockMarketRepository stockMarketRepository;

    //region Properties
    public void setEtrade(EtradeRepository<Tuple<String>, Tuple3<Optional<StockPrice>, Collection<DerivativePrice>, Collection<DerivativePrice>>> etrade) {
        this.etrade = etrade;
    }
    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
    //endregion Properties
    public StockAndOptions callsOrPuts(int oid, boolean isCalls) {
        Collection<DerivativePrice> derivatives = isCalls == true ? etrade.calls(oid) : etrade.puts(oid);
        Optional<StockPrice> stockPrice = etrade.stockPrice(oid);
        StockPriceDTO stockPriceDTO = null;
        if (stockPrice.isPresent()) {
            stockPriceDTO = new StockPriceDTO(stockPrice.get());
        }

        List<OptionDTO> derivativesDTO = derivatives.stream().map(OptionDTO::new).collect(Collectors.toList());
        return new StockAndOptions(stockPriceDTO, derivativesDTO);
    }
    public StockAndOptions calls(int oid) {
        /*
        Collection<DerivativePrice> derivatives = etrade.calls(oid);
        Optional<StockPrice> stockPrice = etrade.stockPrice(oid);
        StockPriceDTO stockPriceDTO = null;
        if (stockPrice.isPresent()) {
           stockPriceDTO = new StockPriceDTO(stockPrice.get());
        }

        List<OptionDTO> derivativesDTO = derivatives.stream().map(OptionDTO::new).collect(Collectors.toList());
        return new StockAndOptions(stockPriceDTO, derivativesDTO);
        */
        return callsOrPuts(oid, true);
    }
    public StockAndOptions puts(int oid) {
        return callsOrPuts(oid, false);
    }


    public List<OptionRiscDTO> calcRiscs(int oid, List<OptionRiscDTO> items) {
        List<OptionRiscDTO> result = new ArrayList<>();
        for (OptionRiscDTO item : items) {
            String stockTicker= stockMarketRepository.getTickerFor(oid);
            Tuple<String> info = new Tuple<>(stockTicker, item.getTicker());
            Optional<DerivativePrice> price = etrade.findDerivativePrice(info);
            if (price.isPresent()) {
                DerivativePrice pricex = price.get();
                double curOptionPrice = pricex.getSell() - item.getRisc();
                Optional<Double> spf = price.get().stockPriceFor(curOptionPrice);
                double spfx = -1.0;
                if (spf.isPresent()) {
                   spfx = spf.get();
                }
                OptionRiscDTO calculated = new OptionRiscDTO(item.getTicker(),spfx);
                result.add(calculated);
            }
        }
        return result;
    }

    public List<RiscLinesDTO> getRiscLines(int oid) {
        /*
        Collection<DerivativePrice> calls = etrade.calls(oid);
        Collection<DerivativePrice> puts = etrade.puts(oid);
        List<DerivativePrice> calculatedCalls =
                calls.stream().filter(x -> x.getCurrentRiscStockPrice().isPresent()).collect(Collectors.toList());
        List<DerivativePrice> calculatedPuts=
                puts.stream().filter(x -> x.getCurrentRiscStockPrice().isPresent()).collect(Collectors.toList());
                */

        Tuple<List<DerivativePrice>> calculated = calculatedCallsAndPuts(oid);
        List<RiscLinesDTO> result = new ArrayList<>();

        for (DerivativePrice call : calculated.first()) {
            result.add(new RiscLinesDTO(call));
        }
        for (DerivativePrice put : calculated.second()) {
            result.add(new RiscLinesDTO(put));
        }

        return result;
    }
    public void clearRiscLines(int oid) {
        Tuple<List<DerivativePrice>> calculated = calculatedCallsAndPuts(oid);
        for (DerivativePrice price : calculated.first()) {
            price.resetRiscCalc();
        }
        for (DerivativePrice price : calculated.second()) {
            price.resetRiscCalc();
        }

    }
    private Tuple<List<DerivativePrice>> calculatedCallsAndPuts(int oid) {
        Collection<DerivativePrice> calls = etrade.calls(oid);
        Collection<DerivativePrice> puts = etrade.puts(oid);
        List<DerivativePrice> calculatedCalls =
                calls.stream().filter(x -> x.getCurrentRiscStockPrice().isPresent()).collect(Collectors.toList());
        List<DerivativePrice> calculatedPuts=
                puts.stream().filter(x -> x.getCurrentRiscStockPrice().isPresent()).collect(Collectors.toList());
        return new Tuple<>(calculatedCalls,calculatedPuts);
    }
}
