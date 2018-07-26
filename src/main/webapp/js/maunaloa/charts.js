import {Chart} from "./canvas/chart.js";
import {Scrapbook} from "./canvas/scrapbook.js";
import {LevelLines} from "./canvas/levelline.js";

document.addEventListener("DOMContentLoaded", function() {
    const canvases = {
        DAY : {
            MAIN_CHART: 'day-chart',
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
            SVG: 'day-svg',
            DIV_DOODLE: 'div-day-doodle',
            DIV_LEVEL_LINES: 'div-day-levelline',
            DOODLE: 'day-doodle',
            LEVEL_LINES: 'day-levellines',
            RG_LAYER: "rg-layer1",
            COLOR: "color1",
            RG_LINE_SIZE: "rg-line1",
            BTN_LINE: "btn-scrapbook1-line",
            BTN_HORIZ: "btn-scrapbook1-horiz",
            BTN_ARROW: "btn-scrapbook1-arrow",
            BTN_TEXT: "btn-scrapbook1-text",
            BTN_CLEAR: "btn-scrapbook1-clear",
            BTN_SAVE: "btn-scrapbook1-save",
            BTN_LEVELLINE: "btn-levelline-1",
            BTN_DRAGGABLE: "btn-draggable-1",
            ARROW_ORIENT: "arrow1-orient",
            COMMENT: "comment1",

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
    /*
    const draggableBtn1 = document.getElementById("btn-draggable-1");
    draggableBtn1.onclick = function() {
        Draggable.addLine("svg-1");
    };
    */
    //---------------------- Elm.Maunaloa.Charts ---------------------------

    const saveCanvases = (canvases) => {
        const canvas =  canvases[0]; // this.canvas; //document.getElementById('canvas');
        const newCanvas = document.createElement('canvas');
        newCanvas.width = canvas.width;
        newCanvas.height = canvas.height;
        const newCtx = newCanvas.getContext("2d");
        newCtx.fillStyle = "FloralWhite";
        newCtx.fillRect(0, 0, canvas.width, canvas.height);
        canvases.forEach(cx => {
            newCtx.drawImage(cx, 0, 0);
        });
        newCanvas.toBlob(function (blob) {
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = "scrap.png";
            document.body.appendChild(a);
            a.click();
            setTimeout(function () {
                document.body.removeChild(a);
                window.URL.revokeObjectURL(url);
            }, 0);
        });
        newCanvas.remove();
    };
    const elmApp = (appId, chartRes, myCanvases, config) => {
        const levelLines = new LevelLines(config);
        const myChart = new Chart(myCanvases,levelLines);
        const scrap = new Scrapbook(config);
        const node = document.getElementById(appId);
        const app = Elm.Maunaloa.Charts.embed(node, {
            chartResolution: chartRes
        });
        app.ports.drawCanvas.subscribe(cfg => {
            scrap.clear();
            myChart.drawCanvases(cfg);
        });
        const btnClear = document.getElementById(config.BTN_CLEAR);
        btnClear.onclick = () => { 
            scrap.clear();
            levelLines.clearCanvas();
        };
        const btnSave = document.getElementById(config.BTN_SAVE);
        btnSave.onclick = () => {
            const blobCanvases = [];
            blobCanvases.push(document.getElementById(myCanvases.MAIN_CHART));
            blobCanvases.push(document.getElementById(config.DOODLE));
            blobCanvases.push(document.getElementById(config.LEVEL_LINES));
            saveCanvases(blobCanvases);
        };
    };
    elmApp("my-app", 1, canvases.DAY, scrapbooks.DAY);
    //---------------------- Scrapbooks ---------------------------
    //const scrap1 = new Scrapbook(scrapbooks.DAY);
});