package harborview.maunaloa.repos;

import critterrepos.beans.StockPriceBean;
import critterrepos.beans.options.DerivativePriceBean;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.options.OptionRiscDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.maunaloa.CalculatorStub;
import harborview.maunaloa.DerivativePriceStub;
import oahu.dto.Tuple;
import oahu.financial.DerivativePrice;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit4.SpringRunner;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

import static org.assertj.core.api.Assertions.byLessThan;
import static org.assertj.core.api.BDDAssertions.then;
import static org.mockito.BDDMockito.given;

//import org.mockito.junit.MockitoJUnitRunner;

@RunWith(SpringRunner.class)
//@RunWith(MockitoJUnitRunner.class)
public class OptionRiscReposTest {
    OptionRiscRepos repos;

    private static int oid = 1;
    private static String ticker = "NHY";
    private static String optionTicker1 = "NHY-1";
    private static String optionTicker2 = "NHY-2";
    private static String optionTicker3 = "NHY-3";
    //EtradeRepository<Tuple<String>> etrade;

    @Mock
    EtradeRepository<Tuple<String>> etrade;

    @Mock
    StockMarketRepository stockMarketRepository;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
        repos = new OptionRiscRepos();
        repos.setEtrade(etrade);
    }

    @Test
    public void testSimpleFetch() {
        // Given
        given(etrade.calls(oid)).willReturn(myCalls());
        given(etrade.stockPrice(oid)).willReturn(myStockPrice());

        // When
        StockAndOptions items = repos.calls(oid);

        // Then
        then(items.getOptions().size())
                .as("When simple fetch callsi should return 3 items")
                .isEqualTo(3);
    }

    @Test
    public void testCalcRiscs() {
        Map<Double,Double> stockPriceMap = new HashMap<>();
        stockPriceMap.put(2.0,108.0);
        stockPriceMap.put(3.0,105.0);
        CalculatorStub.setStockPriceMap(stockPriceMap);

        repos.setStockMarketRepository(stockMarketRepository);
        // Given
        given(etrade.calls(oid)).willReturn(myCalls());
        given(etrade.stockPrice(oid)).willReturn(myStockPrice());

        given(etrade.findDerivativePrice(info1))
                .willReturn(Optional.of(price1));
        given(etrade.findDerivativePrice(info2))
                .willReturn(Optional.of(price2));
        given(etrade.findDerivativePrice(info3))
                .willReturn(Optional.of(price3));

        given(stockMarketRepository.getTickerFor(oid)).willReturn(ticker);

        // When
        List<OptionRiscDTO> items = repos.calcRiscs(oid, myOptionRiscs());

        // Then
        then(items.size())
                .isEqualTo(2);
        then(items.get(0).getRisc())
                .isEqualTo(108.0, byLessThan(0.01));
        then(items.get(1).getRisc())
                .isEqualTo(105.0, byLessThan(0.01));

        // When
        List<RiscLinesDTO> riscLines = repos.getRiscLines(oid);

        // Then
        then(riscLines.size())
                .isEqualTo(2);

        // When
        repos.clearRiscLines(oid);
        riscLines = repos.getRiscLines(oid);

        // Then
        then(riscLines.size())
                .isEqualTo(0);
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

    private Tuple<String> info1 = new Tuple<>(ticker,optionTicker1);
    private Tuple<String> info2 = new Tuple<>(ticker,optionTicker2);
    private Tuple<String> info3 = new Tuple<>(ticker,optionTicker3);
    private DerivativePrice price1 = createDerivativePrice(optionTicker1,4);
    private DerivativePrice price2 = createDerivativePrice(optionTicker2, 5);
    private DerivativePrice price3 = createDerivativePrice(optionTicker3, 6);
    private Collection<DerivativePrice> myCalls() {
        Collection<DerivativePrice> result = new ArrayList<>();
        result.add(price1);
        result.add(price2);
        result.add(price3);
        return result;
    }

    private List<OptionRiscDTO> myOptionRiscs() {
        List<OptionRiscDTO> riscs = new ArrayList<>();

        riscs.add(new OptionRiscDTO(optionTicker1,2));
        riscs.add(new OptionRiscDTO(optionTicker3,3));

        return riscs;
    }

    private DerivativePrice createDerivativePrice(String ticker, double sell) {
        /*
        DerivativePriceStub result = new DerivativePriceStub();
        result.setTicker(ticker);
        result.setSell(sell);
         */
        DerivativePriceBean result = new DerivativePriceBean(null,null,sell,sell,null);
        result.setCalculator(new CalculatorStub());
        return result;
    }
}

