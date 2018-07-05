var MAUNALOA = MAUNALOA || {};


document.addEventListener("DOMContentLoaded", function() {
  var repos1 = null;
  var repos2 = null;
  var repos3 = null;
  const node = document.getElementById('my-app');
  const app = Elm.Maunaloa.Charts.embed(node, {
    chartResolution: 1
  });
  const scrapbook1 = MAUNALOA.scrapbook.create({
    //id_checkbox: "scrapbook1",
      id_layer: "rg-layer1",
      id_svg: "svg-1",
    id_div1: "div-1x",
    id_divScrap: "div-1scrap",
    id_clear: "btn-scrapbook1-clear",
    id_text: "btn-scrapbook1-text",
    id_line: "btn-scrapbook1-line",
    id_horiz: "btn-scrapbook1-horiz",
    id_arrow: "btn-scrapbook1-arrow",
    id_arrow_orient: "arrow1-orient",
    id_save: "btn-scrapbook1-save",
    id_comment: "comment1",
    id_color: "color1",
    id_canvas: MAUNALOA.repos.DAY_LINES_OVERLAY_2,
    id_canvas_0: [MAUNALOA.repos.DAY_LINES,
      MAUNALOA.repos.DAY_LINES_OVERLAY
    ],
    id_rgLine: "rg-line1"
  });
  const scrapbook2 = MAUNALOA.scrapbook.create({
    //id_checkbox: "scrapbook2",
      id_layer: "rg-layer2",
      id_svg: "svg-2",
    id_div1: "div-2x",
    id_divScrap: "div-2scrap",
    id_clear: "btn-scrapbook2-clear",
    id_text: "btn-scrapbook2-text",
    id_line: "btn-scrapbook2-line",
    id_horiz: "btn-scrapbook2-horiz",
    id_arrow: "btn-scrapbook2-arrow",
    id_arrow_orient: "arrow2-orient",
    id_save: "btn-scrapbook2-save",
    id_comment: "comment2",
    id_color: "color2",
    id_canvas: MAUNALOA.repos.WEEK_LINES_OVERLAY_2,
    id_canvas_0: [MAUNALOA.repos.WEEK_LINES,
      MAUNALOA.repos.WEEK_LINES_OVERLAY
    ],
    id_rgLine: "rg-line2"
  });

  /*
  const node2 = document.getElementById('my-app2');
  const app2 = Elm.Maunaloa.Charts.embed(node2, {
    chartResolution: 2
  });

  const node3 = document.getElementById('my-app3');
  const app3 = Elm.Maunaloa.Charts.embed(node3, {
    chartResolution: 3
  });
  */
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
  const drawCanvas1 = function(chartInfo) {
    const cfg = {
      ci: chartInfo,
      ch: chartInfo.chart,
      cid: MAUNALOA.repos.DAY_LINES,
      cidx: MAUNALOA.repos.DAY_LINES_OVERLAY,
      reposId: 1,
      isMain: true
    };
    drawCanvas(cfg);
    cfg.isMain = false;
    if (chartInfo.chart2 != null) {
      cfg.ch = chartInfo.chart2;
      cfg.cid = MAUNALOA.repos.DAY_OSC;
      drawCanvas(cfg);
    }
    if (chartInfo.chart3 != null) {
      cfg.ch = chartInfo.chart3;
      cfg.cid = MAUNALOA.repos.DAY_VOLUME;
      drawCanvas(cfg);
    }
    scrapbook1.clearCanvas();
  };
  const drawCanvas2 = function(chartInfo) {
    const cfg = {
      ci: chartInfo,
      ch: chartInfo.chart,
      cid: MAUNALOA.repos.WEEK_LINES,
      cidx: MAUNALOA.repos.WEEK_LINES_OVERLAY,
      reposId: 2,
      isMain: true
    };
    drawCanvas(cfg);
    cfg.isMain = false;
    if (chartInfo.chart2 != null) {
      cfg.ch = chartInfo.chart2;
      cfg.cid = MAUNALOA.repos.WEEK_OSC;
      drawCanvas(cfg);
    }
    if (chartInfo.chart3 != null) {
      cfg.ch = chartInfo.chart3;
      cfg.cid = MAUNALOA.repos.WEEK_VOLUME;
      drawCanvas(cfg);
    }
    scrapbook2.clearCanvas();
  };
  const drawCanvas3 = function(chartInfo) {
    const cfg = {
      ci: chartInfo,
      ch: chartInfo.chart,
      cid: MAUNALOA.repos.MONTH_LINES,
      cidx: MAUNALOA.repos.MONTH_LINES_OVERLAY,
      reposId: 3,
      isMain: true
    };
    drawCanvas(cfg);
  };
  app.ports.drawCanvas.subscribe(drawCanvas1);
  //app2.ports.drawCanvas.subscribe(drawCanvas2);
  //app3.ports.drawCanvas.subscribe(drawCanvas3);

  const clearCanvas = function(canvasId) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    return [ctx, canvas];
  };
  const drawCanvas = function(cfg) {
    const chartInfo = cfg.ci;
    const curChart = cfg.ch;
    const offsets = chartInfo.xaxis;
    let ctx, canvas;
    [ctx, canvas] = clearCanvas(cfg.cid);

    const myHruler = MAUNALOA.hruler(1300, chartInfo.startdate, offsets, curChart.bars === null, 5);
    myHruler.lines(ctx, canvas.height, chartInfo.numIncMonths);

    const myVruler = MAUNALOA.vruler(canvas.height, curChart.valueRange);
    myVruler.lines(ctx, canvas.width, curChart.numVlines);

    if (cfg.isMain === true) {
      if (cfg.reposId === 1) {
        if (repos1 !== null) {
          repos1.dispose();
        }
        repos1 = MAUNALOA.repos.create(cfg.cidx, myHruler, myVruler);
      } else if (cfg.reposId === 2) {
        if (repos2 !== null) {
          repos2.dispose();
        }
        repos2 = MAUNALOA.repos.create(cfg.cidx, myHruler, myVruler);
      } else {
        if (repos3 !== null) {
          repos3.dispose();
        }
        repos3 = MAUNALOA.repos.create(cfg.cidx, myHruler, myVruler);
      }
    }

    const lineChart = MAUNALOA.lineChart(myHruler, myVruler, ctx);
    const strokes = chartInfo.strokes;
    if (curChart.lines !== null) {
      for (let i = 0; i < curChart.lines.length; ++i) {
        const line = curChart.lines[i];
        const curStroke = strokes[i] === undefined ? "#000000" : strokes[i];
        lineChart.drawLine(line, curStroke);
      }
    }
    if (curChart.bars !== null) {
      for (let i = 0; i < curChart.bars.length; ++i) {
        lineChart.drawBars(curChart.bars[i]);
      }
    }

    if (curChart.candlesticks !== null) {
      lineChart.drawCandlesticks(curChart.candlesticks);
    }
  };

  //------------- Level line ---------------->
  const levelLineBtn1 = document.getElementById("btn-levelline-1");
  levelLineBtn1.onclick = function() {
    repos1.addLevelLine(100, true);
  };
    /*
  const levelLineBtn2 = document.getElementById("btn-levelline-2");
  levelLineBtn2.onclick = function() {
    repos2.addLevelLine(100, true);
  };
  */
    //------------- Draggable ---------------->
    //const draggable1 = new MAUNALOA.svg.draggable("svg-1"); //Draggable("svg-1");
    const draggableBtn1 = document.getElementById("btn-draggable-1");
    draggableBtn1.onclick = function() {
        //draggable1.addLine();
        MAUNALOA.svg.draggable.addLine("svg-1");
    };

  //------------- drawRiscLines ---------------->

  const drawRiscLines1 = function(riscLinesInfo) {
    drawRiscLines(riscLinesInfo, 1);
  };
  const drawRiscLines2 = function(riscLinesInfo) {
    drawRiscLines(riscLinesInfo, 2);
  };
  const drawRiscLines = function(riscLinesInfo, reposId) {
    const repos = reposId === 1 ? repos1 : repos2;
    if (repos === null) {
      alert("Repos not initialized! Aborting.");
      return;
    }
    repos.reset();
    const riscLines = riscLinesInfo.riscLines;
    for (let i = 0; i < riscLines.length - 1; ++i) {
      const rl = riscLines[i];
      repos.addRiscLines(rl, false);
    }
    if (riscLines.length > 0) {
      const rlLast = riscLines[riscLines.length - 1];
      repos.addRiscLines(rlLast, true);
    }
  };
  /*
  app.ports.drawRiscLines.subscribe(drawRiscLines1);
  app2.ports.drawRiscLines.subscribe(drawRiscLines2);
  */

  /*
  const drawSpot1 = function(spot) {
    repos1.addSpot(spot);
  };
  app.ports.drawSpot.subscribe(drawSpot1);
  */
});