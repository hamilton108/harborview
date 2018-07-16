
export class Doodle {
    constructor(cfg) {
        this.canvas = document.getElementById(cfg.DOODLE);
        if (this.canvas !== null) {
            this.canvas.addEventListener('mousedown', this.handleMouseDown.bind(this), false);
            /*
            c_scrap.addEventListener('mousemove', this.handleMouseMove(this), false);
            c_scrap.addEventListener('mouseup', this.handleMouseDone(this), false);
            c_scrap.addEventListener('mouseleave', this.handleMouseDone(this), false);
            this.ctx = c_scrap.getContext("2d");
            */
        }
        this.p0 = null;
        this.MODE = Doodle.MODE_NONE;
        this.guiEvent(cfg.BTN_LINE, (e) => { this.MODE = Doodle.MODE_LINE_BEGIN; });
        this.guiEvent(cfg.BTN_HORIZ, (e) => { this.MODE = Doodle.MODE_HORIZ_BEGIN; });
        this.guiEvent(cfg.BTN_ARROW, (e) => { this.MODE = Doodle.MODE_ARROW; });
        this.getLineSize = this.getLineSizeFn(cfg.RG_LINE_SIZE);

        this.color = document.getElementById(cfg.COLOR);
    }
    get curContext() {
        return this.canvas.getContext("2d");
    }
    guiEvent(domId,fn) {
        const obj = document.getElementById(domId);
        if (obj !== null) {
            obj.onclick = fn.bind(this);
        }
    }
    getLineSizeFn(lineSizeId) {
        return function() {
            const qry = `input[name="${lineSizeId}"]:checked`;
            const rgLine = document.querySelector(qry).value;
            switch (rgLine) {
                case "1":
                    return 1;
                case "2":
                    return 3;
                case "3":
                    return 7;
            }
        }
    }
    handleMouseDown(e) {
        switch (this.MODE) {
            case Doodle.MODE_LINE_BEGIN:
                this.p0 = {
                    x: e.offsetX,
                    y: e.offsetY
                };
                this.MODE = Doodle.MODE_LINE_END;
                break;
            case Doodle.MODE_LINE_END:
                const ctx = this.curContext;
                ctx.lineWidth = this.getLineSize();
                ctx.strokeStyle = this.color.value;
                ctx.beginPath();
                ctx.moveTo(this.p0.x, this.p0.y);
                ctx.lineTo(e.offsetX, e.offsetY);
                ctx.stroke();
                this.p0 = null;
                this.MODE = Doodle.MODE_NONE;
                break;
            case Doodle.MODE_HORIZ_BEGIN:
                this.MODE = Doodle.MODE_HORIZ_END;
                break;
            case Doodle.MODE_HORIZ_END:
                this.MODE = Doodle.MODE_NONE;
                break;
            case Doodle.MODE_ARROW:
                this.MODE = Doodle.MODE_NONE;
                break;
        }
    }
}
Doodle.MODE_NONE = 0;
Doodle.MODE_LINE_BEGIN = 1;
Doodle.MODE_LINE_END = 2;
Doodle.MODE_HORIZ_BEGIN = 3;
Doodle.MODE_HORIZ_END = 4;
Doodle.MODE_ARROW = 5;


