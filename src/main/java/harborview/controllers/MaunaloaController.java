package harborview.controllers;

import harborview.dto.html.ElmCharts;
import harborview.maunaloa.models.MaunaloaModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/maunaloa")
public class MaunaloaController {
    private final MaunaloaModel maunaloaModel;


    @Autowired
    public MaunaloaController(MaunaloaModel maunaloaModel) {
        this.maunaloaModel = maunaloaModel;
    }

    @GetMapping(value = "/")
    public String index() {
        return "maunaloa/index";
    }



    @ResponseBody
    @GetMapping(value = "/days/{oid}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ElmCharts dayChart(@PathVariable("oid") int oid) {
        return maunaloaModel.elmChartsDay(oid);
    }
}
