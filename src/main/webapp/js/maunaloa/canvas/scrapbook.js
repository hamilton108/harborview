import {Draggable} from "./../svg/draggable.js";
import {Doodle} from "./doodle.js";

export class Scrapbook {
    constructor(config) {
        Scrapbook.initLayers(config);
        Scrapbook.initDraggable(config);
        Scrapbook.initDoodle(config);
    }
    static initLayers(cfg) {
        const rgQry = `input[name="${cfg.RG_LAYER}"]`;

        const rgs = document.querySelectorAll(rgQry);
        const rgClick = (event) => {
            const div_doodle = document.getElementById(cfg.DIV_DOODLE);
            const div_level = document.getElementById(cfg.DIV_LEVEL_LINES);
            const div_svg = document.getElementById(cfg.SVG);
            const v = event.target.value;
            switch (v) {
                case "1":
                    div_doodle.style.zIndex = "10";
                    div_level.style.zIndex = "0";
                    div_svg.style.zIndex = "0";
                    break;
                case "2":
                    div_doodle.style.zIndex = "0";
                    div_level.style.zIndex = "10";
                    div_svg.style.zIndex = "0";
                    break;
                case "3":
                    div_doodle.style.zIndex = "0";
                    div_level.style.zIndex = "0";
                    div_svg.style.zIndex = "10";
                    break;
            }
        };
        rgs.forEach(rg => {
            rg.onclick = rgClick;
        });
        document.getElementById(cfg.DIV_DOODLE).style.zIndex = "10";
        document.getElementById(cfg.DIV_LEVEL_LINES).style.zIndex = "0";
        document.getElementById(cfg.SVG).style.zIndex = "0";
    }
    static initDraggable(cfg) {
        const draggableBtn1 = document.getElementById(cfg.BTN_DRAGGABLE);
        draggableBtn1.onclick = function() {
            Draggable.addLine(cfg.SVG);
        };
    }
    static initDoodle(cfg) {
        const doodle =  new Doodle(cfg);
    }
}