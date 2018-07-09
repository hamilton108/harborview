import {Draggable} from "./svg/draggable.js";
import {Chart} from "./canvas/chart.js";
//import Scrapbook from "./canvas/scrapbook.js";

document.addEventListener("DOMContentLoaded", function() {
    const canvases = {
        DAY : {
            SVG: 'day-svg',
            MAIN_CHART: 'day-chart',
            DOODLE: 'day-doodle',
            LEVEL_LINES: 'day-levellines',
            VOLUME: 'day-vol',
            OSC: 'day-osc',
        },
        WEEK : {
        },
        MONTH : {
        }
    };
    const scrapbooks = {
        DAY : {
            RG_LAYER: "rg_layer1",

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
        const myChart = new Chart(myCanvases);
        const node = document.getElementById(appId);
        const app = Elm.Maunaloa.Charts.embed(node, {
            chartResolution: chartRes
        });
        app.ports.drawCanvas.subscribe(cfg => myChart.drawCanvases(cfg));
    };
    elmApp("my-app", 1, canvases.DAY);
    //---------------------- Scrapbooks ---------------------------
});