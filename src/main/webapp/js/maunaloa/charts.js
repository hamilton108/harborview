import {Chart} from "./canvas/chart.js";
import {Scrapbook} from "./canvas/scrapbook.js";
import {LevelLines} from "./canvas/levelline.js";

document.addEventListener("DOMContentLoaded", function() {
    const canvases = {
        DAY : {
            MAIN_CHART: 'chart-1',
            VOLUME: 'vol-1',
            OSC: 'osc-1',
        },
        WEEK : {
            MAIN_CHART: 'chart-2',
            VOLUME: 'vol-2',
            OSC: 'osc-2',
        },
        MONTH : {
        }
    };
    const scrapbooks = {
        DAY : {
            SVG: 'svg-1',
            DIV_DOODLE: 'div-1-doodle',
            DIV_LEVEL_LINES: 'div-1-levelline',
            DOODLE: 'doodle-1',
            LEVEL_LINES: 'levellines-1',
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
            SVG: 'svg-2',
            DIV_DOODLE: 'div-2-doodle',
            DIV_LEVEL_LINES: 'div-2-levelline',
            DOODLE: 'doodle-2',
            LEVEL_LINES: 'levellines-2',
            RG_LAYER: "rg-layer2",
            COLOR: "color2",
            RG_LINE_SIZE: "rg-line2",
            BTN_LINE: "btn-scrapbook2-line",
            BTN_HORIZ: "btn-scrapbook2-horiz",
            BTN_ARROW: "btn-scrapbook2-arrow",
            BTN_TEXT: "btn-scrapbook2-text",
            BTN_CLEAR: "btn-scrapbook2-clear",
            BTN_SAVE: "btn-scrapbook2-save",
            BTN_LEVELLINE: "btn-levelline-2",
            BTN_DRAGGABLE: "btn-draggable-2",
            ARROW_ORIENT: "arrow2-orient",
            COMMENT: "comment2",
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
        const drawSpot = function(spot) {
          levelLines.spot = spot;
        };
        app.ports.drawSpot.subscribe(drawSpot);
        const drawRiscLines = function(riscLines) {
            console.log(riscLines);
            levelLines.addRiscLines(riscLines);
        };
        app.ports.drawRiscLines.subscribe(drawRiscLines);

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
    elmApp("my-app2", 2, canvases.WEEK, scrapbooks.WEEK);
    //---------------------- Scrapbooks ---------------------------
    //const scrap1 = new Scrapbook(scrapbooks.DAY);
});
