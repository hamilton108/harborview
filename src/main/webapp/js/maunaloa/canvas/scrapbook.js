
export class Scrapbook {
    constructor(config) {
        this.config = config;
        Scrapbook.initLayers(config);
    }
    static initLayers(cfg) {
        const rgQry = `input[name="${cfg.RG_LAYER}"]`;

        const rgs = document.querySelectorAll(rgQry);
        const rgClick = (event) => {
            var div_doodle = document.getElementById(cfg.DOODLE);
            var div_level = document.getElementById(cfg.LEVEL_LINES);
            var div_svg = document.getElementById(cfg.SVG);
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
        document.getElementById(cfg.DOODLE).style.zIndex = "10";
        document.getElementById(cfg.LEVEL_LINES).style.zIndex = "0";
        document.getElementById(cfg.SVG).style.zIndex = "0";
    }
}