
document.addEventListener("DOMContentLoaded", function () {

    const cfg = {
        "startdate": 1548115200000,
        "xaxis": [10, 9, 8, 5, 4],
        "chart3": null,
        "chart2": null,
        "chart": { "candlesticks": null, "lines": [[3.0, 2.2, 3.1, 4.2, 3.5]], "valueRange": [2.2, 4.2] }
    };

    const mappings = () => {
        const mainChart = { chartId: "chart", canvasId: "levellines-1", chartHeight: 500.0, levelCanvasId: "levellines-1" };
        return [mainChart];
    };

    const unlistener = PS.Main.paint(mappings())(cfg)();
    console.log(unlistener);
})