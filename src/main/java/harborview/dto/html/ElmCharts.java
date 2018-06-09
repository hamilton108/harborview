package harborview.dto.html;

import java.util.List;

public class ElmCharts {
    private Chart chart;
    private Chart chart2;
    private Chart chart3;
    private String minDx;
    private List<Double> xAxis;

    public Chart getChart() {
        return chart;
    }

    public void setChart(Chart chart) {
        this.chart = chart;
    }

    public Chart getChart2() {
        return chart2;
    }

    public void setChart2(Chart chart2) {
        this.chart2 = chart2;
    }

    public Chart getChart3() {
        return chart3;
    }

    public void setChart3(Chart chart3) {
        this.chart3 = chart3;
    }

    public String getMinDx() {
        return minDx;
    }

    public void setMinDx(String minDx) {
        this.minDx = minDx;
    }

    public List<Double> getxAxis() {
        return xAxis;
    }

    public void setxAxis(List<Double> xAxis) {
        this.xAxis = xAxis;
    }
}
