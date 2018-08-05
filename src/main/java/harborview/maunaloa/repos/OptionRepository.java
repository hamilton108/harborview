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

    public Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
    stockAndOptions(int oid) {
        Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>
                tmp = stockAndOptionsMap.get(oid);
        if (tmp == null) {
            String ticker = stockMarketRepository.getTickerFor(oid);
            tmp = etrade.parseHtmlFor(ticker,null);
            stockAndOptionsMap.put(oid,tmp);
        }
        return tmp;
    }

    private Collection<DerivativePrice> allOptions() {
        /*
        for (Map.Entry<Integer,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>> entry :
            stockAndOptionsMap.entrySet()) {
        }
        */
        for (Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>> vals : stockAndOptionsMap.values()) {

        }
        return null;
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
    }

    public List<RiscLinesDTO> fetchRiscLines(int oid) {
        return null;
    }
    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
    public void setEtrade(EtradeRepository<Tuple<String>,Tuple3<Optional<StockPrice>,Collection<DerivativePrice>,Collection<DerivativePrice>>> etrade) {
        this.etrade = etrade;
    }
}
