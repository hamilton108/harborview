package harborview.dao;

import harborview.dto.html.SelectItem;
import oahu.financial.Stock;

import java.util.Collection;

public interface MaunaloaDAO {
    Collection<SelectItem> getStockTickers();
    Collection<Stock> getStocks();
}
