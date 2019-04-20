package harborview.dto.html.options;

import harborview.dto.html.StockPriceDTO;

import java.util.List;

public class StockAndOptions {
    private final StockPriceDTO stock;
    private final List<OptionDTO> options;
    public StockAndOptions(StockPriceDTO stock, List<OptionDTO> options) {
        this.stock = stock;
        this.options = options;
    }

    public StockPriceDTO getStock() {
        return stock;
    }

    public List<OptionDTO> getOptions() {
        return options;
    }
}
