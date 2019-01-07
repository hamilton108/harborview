package harborview.maunaloa.repos;

import harborview.dto.html.options.OptionDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.dto.html.options.StockPriceDTO;
import oahu.dto.Tuple;
import oahu.dto.Tuple3;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;
import oahu.financial.repository.EtradeRepository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class OptionRiscRepos {
    private EtradeRepository<Tuple<String>,
                Tuple3<Optional<StockPrice>,Collection<DerivativePrice>, Collection<DerivativePrice>>> etrade;
    public StockAndOptions calls(int oid) {
        Collection<DerivativePrice> derivatives = etrade.calls(oid);
        Optional<StockPrice> stockPrice = etrade.stockPrice(oid);
        StockPriceDTO stockPriceDTO = null;
        if (stockPrice.isPresent()) {
           stockPriceDTO = new StockPriceDTO(stockPrice.get());
        }

        List<OptionDTO> derivativesDTO = derivatives.stream().map(OptionDTO::new).collect(Collectors.toList());
        return new StockAndOptions(stockPriceDTO, derivativesDTO);
    }



    //region Properties
    public void setEtrade(EtradeRepository<Tuple<String>, Tuple3<Optional<StockPrice>, Collection<DerivativePrice>, Collection<DerivativePrice>>> etrade) {
        this.etrade = etrade;
    }
    //endregion Properties

}
