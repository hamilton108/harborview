package harborview.web.controllers;

import harborview.web.controllers.web.JsonResult;
import java.util.function.Supplier;

public class Common {

    /*
    public static JsonResult jsonEx(Exception ex) {
        return new JsonResult(false, ex.getMessage(), 0);

    }
    */

    public static JsonResult jsonTryCatch(Supplier<String> fn) {
        try {
            return new JsonResult(true, fn.get(), 0);
        }
        catch (Exception ex) {
            return new JsonResult(false, ex.getMessage(), 0);
        }
    }
}
