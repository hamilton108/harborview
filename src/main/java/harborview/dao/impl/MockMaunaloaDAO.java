package harborview.dao.impl;

import harborview.dao.MaunaloaDAO;
import harborview.dto.html.SelectItem;
import oahu.financial.Stock;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class MockMaunaloaDAO implements MaunaloaDAO {
    @Override
    public Collection<SelectItem> getStockTickers() {
        List<SelectItem> result = new ArrayList<>();
        result.add(new SelectItem("YAR", "3"));
        return result;
    }

    @Override
    public Collection<Stock> getStocks() {
        List<Stock> result = new ArrayList<>();
        result.add(new MockStock("NHY", 1));
        result.add(new MockStock("STL", 2));
        result.add(new MockStock("YAR", 3));
        return result;
    }
}
