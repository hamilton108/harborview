package harborview.maunaloa.repos;

import harborview.dto.html.StockPriceDTO;
import harborview.dto.html.options.OptionDTO;
import harborview.dto.html.options.StockAndOptions;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;
import oahu.financial.repository.EtradeRepository;

import java.util.*;
import java.util.stream.Collectors;

public class OptionRiscRepos {
    private EtradeRepository etrade;

    private Map<String,DerivativePrice> optionsMap = new HashMap<>();

    public StockAndOptions calls(int oid) {
        return callsOrPuts(oid, true);
    }

    public void setEtrade(EtradeRepository etrade) {
        this.etrade = etrade;
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
}
