package harborview.maunaloa;

import netfondsrepos.repos.EtradeRepository2;
import oahu.dto.Tuple3;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;

import java.io.File;
import java.util.Collection;
import java.util.Optional;

public class EtradeRepositoryStub extends EtradeRepository2 {

    private Tuple3<Optional<StockPrice>, Collection<DerivativePrice>, Collection<DerivativePrice>> cached;
    @Override
    public Tuple3<Optional<StockPrice>, Collection<DerivativePrice>, Collection<DerivativePrice>>
    parseHtmlFor(String ticker, File suppliedFile) {
        if (cached == null) {
            cached = super.parseHtmlFor(ticker, suppliedFile);
        }
        return cached;
    }
}
