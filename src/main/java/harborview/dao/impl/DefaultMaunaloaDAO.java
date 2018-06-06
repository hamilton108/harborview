package harborview.dao.impl;

import harborview.dao.MaunaloaDAO;
import harborview.dto.html.SelectItem;
import oahu.financial.Stock;
import oahu.financial.repository.StockMarketRepository;

import java.util.Collection;
import java.util.stream.Collectors;

public class DefaultMaunaloaDAO implements MaunaloaDAO {
    private StockMarketRepository stockMarketRepository;
    private Collection<Stock> stocks;

    public DefaultMaunaloaDAO() {
    }

    @Override
    public Collection<SelectItem> getStockTickers() {
        return getStocks().stream().map(x -> new SelectItem(x.getTicker(),String.valueOf(x.getOid()))).collect(Collectors.toList());
    }

    @Override
    public Collection<Stock> getStocks() {
        if (stocks == null) {
            stocks =  stockMarketRepository.getStocks();
        }
        return stocks;
    }

    public StockMarketRepository getStockMarketRepository() {
        return stockMarketRepository;
    }

    public void setStockMarketRepository(StockMarketRepository stockMarketRepository) {
        this.stockMarketRepository = stockMarketRepository;
    }
}
