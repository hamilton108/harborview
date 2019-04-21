package harborview.maunaloa.repos;

import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.StockPriceDTO;
import harborview.dto.html.options.OptionDTO;
import harborview.dto.html.options.OptionRiscDTO;
import harborview.dto.html.options.StockAndOptions;
import oahu.dto.Tuple;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;

import java.util.*;
import java.util.stream.Collectors;

public class OptionRiscRepos {
    private EtradeRepository<Tuple<String>> etrade;

    private StockMarketRepository stockMarketRepository;

    private Map<String,DerivativePrice> optionsMap = new HashMap<>();

    public StockAndOptions calls(int oid) {
        return callsOrPuts(oid, true);
    }
    public StockAndOptions puts(int oid) {
        return callsOrPuts(oid, false);
    }

    public void setEtrade(EtradeRepository etrade) {
        this.etrade = etrade;
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }

    public List<OptionRiscDTO> calcRiscs(int oid, List<OptionRiscDTO> riscs) {
        List<OptionRiscDTO> result = new ArrayList<>();

        for (OptionRiscDTO risc: riscs) {
            String stockTicker= stockMarketRepository.getTickerFor(oid);
            Tuple<String> info = new Tuple<>(stockTicker, risc.getTicker());
            Optional<DerivativePrice> price = etrade.findDerivativePrice(info);
            if (price.isPresent()) {
                DerivativePrice pricex = price.get();
                double curOptionPrice = pricex.getSell() - risc.getRisc();
                Optional<Double> spf = pricex.stockPriceFor(curOptionPrice);
                double spfx = -1.0;
                if (spf.isPresent()) {
                    spfx = spf.get();
                }
                OptionRiscDTO calculated = new OptionRiscDTO(risc.getTicker(), spfx);
                result.add(calculated);
            }
        }
        return result;
    }
    public List<RiscLinesDTO> getRiscLines(int oid) {
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

    private StockAndOptions callsOrPuts(int oid, boolean isCalls) {
        Collection<DerivativePrice> derivatives = isCalls == true ? etrade.calls(oid) : etrade.puts(oid);
        derivatives.forEach(x -> optionsMap.put(x.getTicker(), x));
        StockPriceDTO stockPriceDTO = spot(oid);
        List<OptionDTO> derivativesDTO = derivatives.stream().map(OptionDTO::new).collect(Collectors.toList());
        return new StockAndOptions(stockPriceDTO, derivativesDTO);
    }
    private StockPriceDTO spot(int oid) {
        Optional<StockPrice> stockPrice = etrade.stockPrice(oid);
        StockPriceDTO result = null;
        if (stockPrice.isPresent()) {
            result = new StockPriceDTO(stockPrice.get());
        }
        return result;
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
