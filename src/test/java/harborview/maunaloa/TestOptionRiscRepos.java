package harborview.maunaloa;

import com.gargoylesoftware.htmlunit.Page;
import harborview.dto.html.options.OptionDTO;
import harborview.dto.html.options.StockAndOptions;
import harborview.dto.html.options.StockPriceDTO;
import harborview.maunaloa.repos.OptionRiscRepos;
import netfondsrepos.downloader.MockDownloader;
import netfondsrepos.repos.EtradeRepository2;
import oahu.financial.html.EtradeDownloader;
import oahu.financial.repository.StockMarketRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.Serializable;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class TestOptionRiscRepos {

    private static String storePath = "/home/rcs/opt/java/netfonds-repos/src/test/resources";
    private static final EtradeDownloader<Page, Serializable> downloader = new MockDownloader(storePath);
    private static final StockMarketRepository stockMarketRepos = new StockMarketReposStub();
    private static final EtradeRepository2 etrade = new EtradeRepository2();
    static {
        etrade.setDownloader(downloader);
        etrade.setStockMarketRepository(stockMarketRepos);
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
}
