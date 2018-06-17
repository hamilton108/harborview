package harborview.web.controllers.web;

public class JsonResult {
    private final boolean ok;
    //private final int status;
    private final String msg;

    public JsonResult(boolean ok, String msg) {
        this.ok = ok;
        this.msg = msg;
    }


    public String getMsg() {
        return msg;
    }

    public boolean isOk() {
        return ok;
    }
}
