package harborview.dto.html;

public class JsonResult {
    private final boolean ok;
    private final int statusCode;
    private final String msg;

    public JsonResult(boolean ok, String msg, int statusCode) {
        this.ok = ok;
        this.msg = msg;
        this.statusCode = statusCode;
    }


    public String getMsg() {
        return msg;
    }

    public boolean isOk() {
        return ok;
    }

    public int getStatusCode() {
        return statusCode;
    }
}
