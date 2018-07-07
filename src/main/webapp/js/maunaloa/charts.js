import Draggable from "./svg/draggable.js";
import Chart from "./canvas/chart.js";

document.addEventListener("DOMContentLoaded", function() {
    const canvases = {
        DAY : {
            LINES: 'canvas1',
            LINES_OVERLAY: 'canvas1x',
            LINES_OVERLAY_2: 'canvas1-scrap',
            VOLUME: 'canvas1c',
            OSC: 'canvas1b',
        },
        WEEK : {
            LINES: 'canvas2',
            LINES_OVERLAY: 'canvas2x',
            LINES_OVERLAY_2: 'canvas2-scrap',
            VOLUME: 'canvas2c',
            OSC: 'canvas2b',
        },
        MONTH : {
            LINES: 'canvas3',
            LINES_OVERLAY: 'canvas3x',
            LINES_OVERLAY_2: null,
            VOLUME: 'canvas3c',
            OSC: 'canvas3b',
        }
    };
    const scrapbooks = {
        DAY : {

        },
        WEEK : {

        }
    };
    const setCanvasSize = function(selector, w, h) {
        const c1 = document.querySelectorAll(selector);
        for (let i = 0; i < c1.length; ++i) {
            const canvas = c1[i];
            canvas.width = w;
            canvas.height = h;
        }
    };
    const setCanvasSizes = function() {
        setCanvasSize('canvas.c1', 1310, 500);
        setCanvasSize('canvas.c2', 1310, 200);
        setCanvasSize('canvas.c3', 1310, 110);
    };
    setCanvasSizes();
    const draggableBtn1 = document.getElementById("btn-draggable-1");
    draggableBtn1.onclick = function() {
        Draggable.addLine("svg-1");
    };
    //---------------------- Elm.Maunaloa.Charts ---------------------------

    const elmApp = (appId, chartRes, myCanvases) => {
        /*
        const drawCanvas = function (chartInfo) {
            Chart.drawCanvas(chartInfo);
        };
        */
        const myChart = new Chart(myCanvases);
        const node = document.getElementById(appId);
        const app = Elm.Maunaloa.Charts.embed(node, {
            chartResolution: chartRes
        });
        app.ports.drawCanvas.subscribe(cfg => myChart.drawCanvases(cfg));
    };
    elmApp("my-app", 1, canvases.DAY);
});