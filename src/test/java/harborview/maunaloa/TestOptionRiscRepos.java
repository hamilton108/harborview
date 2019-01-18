package harborview.maunaloa;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gargoylesoftware.htmlunit.Page;
import harborview.dto.html.RiscLinesDTO;
import harborview.dto.html.options.*;
import harborview.maunaloa.repos.OptionRiscRepos;
import netfondsrepos.downloader.MockDownloader;
import netfondsrepos.repos.EtradeRepository2;
import oahu.financial.DerivativePrice;
import oahu.financial.OptionCalculator;
import oahu.financial.html.EtradeDownloader;
import oahu.financial.repository.EtradeRepository;
import oahu.financial.repository.StockMarketRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import vega.financial.calculator.BlackScholes;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class TestOptionRiscRepos {

    private static String c1 = "NHY9I34";
    private static String storePath = "/home/rcs/opt/java/netfonds-repos/src/test/resources";
    private static final EtradeDownloader<Page, Serializable> downloader = new MockDownloader(storePath);
    private static final StockMarketRepository stockMarketRepos = new StockMarketReposStub();
    private static final OptionCalculator calculator = new BlackScholes();
    private static final EtradeRepository2 etrade = new EtradeRepositoryStub(); //EtradeRepository2();
    static {
        etrade.setDownloader(downloader);
        etrade.setStockMarketRepository(stockMarketRepos);
        etrade.setOptionCalculator(calculator);
    }

    @DisplayName("Test fetching stock and calls")
    @Test
    public void testCalls() {
        int stockId = 1; // NHY

        OptionRiscRepos riscRepos = new OptionRiscRepos();
        riscRepos.setEtrade(etrade);

        StockAndOptions result = riscRepos.calls(stockId);
        StockPriceDTO stock = result.getStock();
        assertNotNull(stock, "Stock is null");
        assertEquals("2018-11-23", stock.getDx(), "Stock dx not 2018-11-23");
        assertEquals("18:30", stock.getTm(), "Stock tm not 18:13");
        testDouble(41.83, stock.getO(), "getO() ");
        testDouble(41.85, stock.getH(), "getH() ");
        testDouble(40.87, stock.getL(), "getL() ");
        testDouble(41.05, stock.getC(), "getC() ");
        List<OptionDTO> calls = result.getOptions();
        assertEquals(91, calls.size(), "Number of calls not 91");
    }
    private void testDouble(double expected, double acutal, String msg) {
        assertEquals(expected, acutal, 0.01, String.format("%s not %.2f",msg, expected));
    }

    private List<OptionRiscDTO> optionsForRiscCalculations() {
        List<OptionRiscDTO>  result = new ArrayList<>();

        result.add(new OptionRiscDTO(c1, 2.35));

        return result;
    }

    @DisplayName("Test calculating List<RiscItemDTO>")
    @Test
    public void testRiscs() {
        List<OptionRiscDTO> opx = optionsForRiscCalculations();

        OptionRiscRepos riscRepos = new OptionRiscRepos();
        riscRepos.setEtrade(etrade);
        riscRepos.setStockMarketRepository(stockMarketRepos);

        List<OptionRiscDTO> calculated = riscRepos.calcRiscs(1,opx);

        for (OptionRiscDTO item : calculated) {
            if (item.getTicker().equals(c1)) {
                double expected = 39.05;
                assertEquals(expected, item.getRisc(), 0.1, String.format("%s not %.2f",item.getTicker(), expected));
            }
        }

        List<RiscLinesDTO> cached = riscRepos.getRiscLines(1);
        assertEquals(1, cached.size(), "Cached riscs not 1");
    }


    /*
    @DisplayName("Test serializing RiscLine from DerivativePrice by Jackson")
    @Test
    public void testRiscLineJackson() throws JsonProcessingException {
        DerivativePrice stub = new DerivativePriceStub();
        RiscLinesDTO dto = new RiscLinesDTO(stub);
        String result = new ObjectMapper().writeValueAsString(dto);
        System.out.printf(result);
    }
    */

}


