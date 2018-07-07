
export default class Chart {
    constructor(myCanvases) {
        this.myCanvases = myCanvases;
    }
    drawCanvas(cfg) {
        /*
        const chartInfo = cfg.ci;
        const curChart = cfg.ch;
        const offsets = chartInfo.xaxis;
        const myHruler = MAUNALOA.hruler(1300, cfg.startdate, offsets, curChart.bars === null, 5);
        console.log(myHruler);
        */
        const offsets = cfg.xaxis;
        const myHruler = MAUNALOA.hruler(1300, cfg.startdate, offsets, true, 5);
        console.log(myHruler);
    }
}
