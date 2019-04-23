package harborview;

import oahu.financial.repository.StockMarketRepository;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@MapperScan("critterrepos.models.mybatis")
@ComponentScan({
        "critterrepos.models.impl"
        , "critterrepos.beans.options"
        , "oahu.properties"
        , "netfondsrepos.repos"
        , "netfondsrepos.downloader"
        , "netfondsrepos.webclient"
        , "harborview.controllers"
        , "harborview.maunaloa.models"
        , "harborview.maunaloa.repos"
        , "harborview.critters"
        , "vega.financial.calculator"
})
@EnableCaching
public class App implements CommandLineRunner {

    private final StockMarketRepository repository;

    @Autowired
    public App(StockMarketRepository repository) {
        this.repository = repository;
    }

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
    }

    /*
    @Override
    public void run(String... args) throws Exception {
        System.out.println("My repository: " + repository);
        Collection<Stock> stox = repository.getStocks();
        for (Stock s : stox) {
            System.out.println(s.getTicker());
        }
        Collection<StockPrice> prices = repository.findStockPrices("NHY", LocalDate.of(2018,1,1));
        System.out.println(prices.size());
        prices = repository.findStockPrices("NHY", LocalDate.of(2018,1,1));
        System.out.println(prices.size());
        prices = repository.findStockPrices("NHY", LocalDate.of(2018,1,1));
        System.out.println(prices.size());
    }
    */
}
