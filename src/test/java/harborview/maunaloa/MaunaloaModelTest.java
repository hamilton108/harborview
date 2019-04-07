package harborview.maunaloa;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
public class MaunaloaModelTest {

}
/*
@ExtendWith(MockitoExtension.class)
public class MaunaloaModelTest {

    @Mock
    Derivative derivative;

    @Mock
    StockPrice stockPrice;

    @Mock
    OptionCalculator calculator;

    //@InjectMocks
    //DerivativePriceBean price;

    //@BeforeAll
    //public static void initMocks() {
    //    MockitoAnnotations.initMocks(this);
    //}

    @Test
    public void testOne() {

        DerivativePriceBean price = new DerivativePriceBean();
        price.setDerivative(derivative);
        price.setStockPrice(stockPrice);
        price.setCalculator(calculator);

        //when(price.getIvBuy()).thenReturn(Optional.of(0.2));

        //Optional<Double> iv = price.getIvBuy();
        //assertThat(iv.isPresent()).isEqualTo(true);
        //iv.ifPresent(aDouble -> assertThat(aDouble).isCloseTo(0.19, offset(0.015)));
    }
}
*/
