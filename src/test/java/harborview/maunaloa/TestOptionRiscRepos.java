package harborview.maunaloa;

import com.gargoylesoftware.htmlunit.CollectingAlertHandler;
import com.gargoylesoftware.htmlunit.Page;
import harborview.dto.html.options.StockAndOptions;
import harborview.maunaloa.repos.OptionRiscRepos;
import netfondsrepos.downloader.MockDownloader;
import netfondsrepos.repos.EtradeRepository2;
import oahu.financial.DerivativePrice;
import oahu.financial.StockPrice;
import oahu.financial.html.EtradeDownloader;
import oahu.financial.repository.StockMarketRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.io.Serializable;
import java.util.Collection;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
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
        assertNotNull(result.getStock(), "Stock is null");
    }
}
