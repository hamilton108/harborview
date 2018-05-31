package harborview.dto.html;

public class SelectItem {
    private String t;
    private String v;
    public SelectItem(String t, String v) {
        this.setT(t);
        this.setV(v);
    }

    public String getT() {
        return t;
    }

    public String getV() {
        return v;
    }

    public void setT(String t) {
        this.t = t;
    }

    public void setV(String v) {
        this.v = v;
    }
}
