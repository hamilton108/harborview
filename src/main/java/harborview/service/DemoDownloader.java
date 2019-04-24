package harborview.service;

import com.gargoylesoftware.htmlunit.Page;
import oahu.financial.html.EtradeDownloader;
import oahu.financial.html.WebClientManager;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.io.Serializable;

public class DemoDownloader implements EtradeDownloader<Page, Serializable> {

    private WebClientManager<Page> webClientManager;

    @Autowired
    public void setWebClientManager(WebClientManager webClientManager) {
        this.webClientManager = webClientManager;
    }

    @Override
    public Page downloadDerivatives(String ticker) throws IOException {
        return webClientManager.getPage(tickerUrl(ticker));
    }

    @Override
    public Page downloadDerivatives() throws IOException {
        return null;
    }
    private String tickerUrl(String ticker) {
        return String.format("file:///home/rcs/opt/java/harborview/feed/%s.html", ticker);
    }


    @Override
    public Page downloadIndex(String stockIndex) throws IOException {
        return null;
    }

    @Override
    public Page downloadPaperHistory(String ticker) throws IOException {
        return null;
    }

    @Override
    public Page downloadDepth(String ticker) throws IOException {
        return null;
    }

    @Override
    public Page downloadPurchases(String ticker) throws IOException {
        return null;
    }
}
