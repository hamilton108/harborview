package harborview.maunaloa.repos;

import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.options.*;
import oahu.dto.Tuple;
import oahu.dto.Tuple3;
import oahu.financial.*;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;

import java.util.*;
import java.util.stream.Collectors;

public class OptionRepository {
    private StockMarketRepository stockMarketRepository;
    private Map<Integer,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
            stockAndOptionsMap = new HashMap<>();

    private EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>>
            etrade;

    private Map<String,DerivativePrice> optionsMap = new HashMap<>();
    private Map<Integer,OptionPurchase> purchasesMap;

    public Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
    stockAndOptions(int oid) {
        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
                tmp = stockAndOptionsMap.get(oid);
        if (tmp == null) {
            String ticker = stockMarketRepository.getTickerFor(oid);
            tmp = etrade.parseHtmlFor(ticker,null);
            stockAndOptionsMap.put(oid,tmp);
            tmp.second().forEach(x -> optionsMap.put(x.getTicker(), x));
            tmp.third().forEach(x -> optionsMap.put(x.getTicker(), x));
        }
        return tmp;
    }
    public void setOptionPurchases(Collection<OptionPurchase> purchases) {
        purchasesMap = new HashMap<>();
        for (OptionPurchase p: purchases) {
            purchasesMap.put(p.getOid(), p);
        }
    }

    private Collection<DerivativePrice> optionsWithRisc(int oid) {
        List<DerivativePrice> result = new ArrayList<>();
        for (Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>> vals : stockAndOptionsMap.values()) {
            //List<DerivativePrice> yar =
            //        vals.second().stream().filter(x -> x.getTicker().equals("YAR9C360")).collect(Collectors.toList());
            List<DerivativePrice> callsWithSpRisc =
                    vals.second().stream().filter(x -> x.getCurrentRiscStockPrice().isPresent() && x.getStockId() == oid).collect(Collectors.toList());
            List<DerivativePrice> putsWithSpRisc =
                    vals.third().stream().filter(x -> x.getCurrentRiscStockPrice().isPresent() && x.getStockId() == oid).collect(Collectors.toList());
            result.addAll(callsWithSpRisc);
            result.addAll(putsWithSpRisc);
        }
        return result;
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

        List<OptionDTO> options = prices.stream().map(OptionDTO::new).collect(Collectors.toList());

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

    public void resetSpotAndOptions() {
        stockAndOptionsMap = new HashMap<>();
        optionsMap = new HashMap<>();
    }
    public DerivativePrice getOptionFor(String ticker) {
        return optionsMap.get(ticker);
    }
    public OptionPurchase getPurchaseFor(int oid) {
        return purchasesMap.get(oid);
    }
    public List<RiscLinesDTO> fetchRiscLines(int oid) {
        Collection<DerivativePrice> riscs = optionsWithRisc(oid);
        return riscs.stream().map(RiscLinesDTO::new).collect(Collectors.toList());
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
    public void setEtrade(EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>> etrade) {
        this.etrade = etrade;
    }
}
