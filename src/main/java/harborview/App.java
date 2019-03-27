package harborview;

import oahu.financial.Stock;
import oahu.financial.repository.StockMarketRepository;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

import java.util.Collection;

@SpringBootApplication
@MapperScan("critterrepos.models.mybatis")
@ComponentScan({"oahu.financial.repository","critterrepos.models.impl"})
public class App implements CommandLineRunner {

    StockMarketRepository repository;

    @Autowired
    public App(StockMarketRepository repository) {
        this.repository = repository;
    }
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.printf("My repository: " + repository);
        Collection<Stock> stox = repository.getStocks();
        for (Stock s : stox) {
            System.out.println(s.getTicker());
        }
    }
}
