package harborview.maunaloa.repos;

import critterrepos.beans.StockPriceBean;
import harborview.dto.html.options.StockAndOptions;
import harborview.maunaloa.DerivativePriceStub;
import oahu.financial.DerivativePrice;
import oahu.financial.repository.EtradeRepository;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit4.SpringRunner;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Optional;

import static org.mockito.BDDMockito.given;
import static org.assertj.core.api.BDDAssertions.then;

//import org.mockito.junit.MockitoJUnitRunner;

@RunWith(SpringRunner.class)
//@RunWith(MockitoJUnitRunner.class)
public class OptionRiscReposTest {
    OptionRiscRepos repos;

    private static int oid = 1;
    private static String ticker = "NHY";
    //EtradeRepository<Tuple<String>> etrade;

    @Mock
    EtradeRepository etrade;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
        repos = new OptionRiscRepos();
        repos.setEtrade(etrade);
    }

    @Test
    public void when_simple_fetch_calls_should_return_3_items() {
        // Given
        given(etrade.calls(oid)).willReturn(myCalls());
        given(etrade.stockPrice(oid)).willReturn(myStockPrice());

        // When
        StockAndOptions items = repos.calls(oid);

        // Then
        then(items.getOptions().size()).isEqualTo(3);
    }

    @Test
    public void when_fetch_calls_with_invalid_items_should_return_2_items() {
        // Given
        given(etrade.calls(oid)).willReturn(myCallsWithInvalidItems());
        given(etrade.stockPrice(oid)).willReturn(myStockPrice());

        // When
        StockAndOptions items = repos.calls(oid);

        // Then
        then(items.getOptions().size()).isEqualTo(2);
    }

    private Optional myStockPrice() {
        StockPriceBean result = new StockPriceBean(
                LocalDate.now(),
                LocalTime.now(),
                100,
                110,
                98,
                109,
                1000000);
        return Optional.of(result);
    }

    private Collection<DerivativePrice> myCalls() {
        Collection<DerivativePrice> result = new ArrayList<>();

        result.add(new DerivativePriceStub());
        result.add(new DerivativePriceStub());
        result.add(new DerivativePriceStub());

        return result;
    }

    private Collection<DerivativePrice> myCallsWithInvalidItems() {
        Collection<DerivativePrice> result = new ArrayList<>();

        result.add(new DerivativePriceStub());
        result.add(new DerivativePriceStub());
        result.add(new DerivativePriceStub());

        return result;
    }
}

