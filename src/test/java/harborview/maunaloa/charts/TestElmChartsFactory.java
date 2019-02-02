package harborview.maunaloa.charts;

import critterrepos.beans.StockPriceBean;
import oahu.financial.StockPrice;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInfo;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class TestElmChartsFactory {

    ElmChartsMonthFactory factory;

    @BeforeEach
    public void init(TestInfo info) {
        factory = new ElmChartsMonthFactory();
    }

    @DisplayName("Tests transforming a null-list of stock prices from a month to a monthly stock price")
    @Test
    public void monthPrices_null_toStockPrice() {
        StockPrice price = factory.monthToStockPrice(null);
        StockPrice expected = new StockPriceBean(LocalDate.of(2019,1,1), 100,120,90, 110,1000000);
        assertEquals(expected, price);
    }

    @DisplayName("Tests transforming a list of one item to a monthly stock price")
    @Test
    public void monthPrices_one_item_toStockPrice() {
        StockPrice expected = createStockPrice(1,100,120,90,110, 1000000);
        List<StockPrice> items = new ArrayList<>();
        items.add(expected);
        StockPrice price = factory.monthToStockPrice(items);
        assertEquals(expected, price);
    }

    @DisplayName("Tests transforming a list of stock prices from a month to a monthly stock price")
    @Test
    public void monthPrices_toStockPrice() {
        List<StockPrice> items = new ArrayList<>();
        items.add(createStockPrice(2,100,120,90,110,1000000));
        items.add(createStockPrice(3,105,125,95,115,1000000));
        items.add(createStockPrice(4,95,110,90,105,1000000));
        items.add(createStockPrice(7,90,100,80,80,1000000));
        items.add(createStockPrice(8,80,90,80,85,1000000));
        items.add(createStockPrice(9,100,120,100,100,1000000));
        items.add(createStockPrice(10,110,125,100,105,1000000));
        items.add(createStockPrice(11,120,135,120,135,1000000));
        items.add(createStockPrice(14,115,115,90,90,1000000));
        items.add(createStockPrice(15,130,140,130,140,1000000));

        StockPrice expected = createStockPrice(1,110,140,80,140, 10000000);
        StockPrice price = factory.monthToStockPrice(items);
        assertEquals(expected, price);
    }

    private StockPrice createStockPrice(int day, double o, double hi, double lo, double c, long vol) {
        return new StockPriceBean(LocalDate.of(2019,1,day), o,hi,lo, c,vol);
    }
}
