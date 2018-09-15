package harborview.web.controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public class DbInfo {
    private static String fileName = "/home/rcs/opt/java/harborview/src/main/resources/critters-dbcp.properties";
    private static Pattern dbUrlPat = Pattern.compile("^db.url=(.*)");
    private static Pattern dbUserPat = Pattern.compile("^db.user=(.*)");
    private String dbUrl;
    private String dbUser;
    public DbInfo() {
    }

    public String getInfo() {
       return String.format("URL: %s - USER: %s", getDbUrl(), getDbUser());
    }
    public String getDbUrl() {
        if (dbUrl == null) {
            init();
        }
        return dbUrl;
    }

    public String getDbUser() {
        if (dbUser == null) {
            init();
        }
        return dbUser;
    }

    private void init() {
        /*
        try (FileInputStream fis =
                     new FileInputStream("/home/rcs/opt/java/harborview/src/main/resources/critters-dbcp.properties")) {


        } catch (IOException e) {
            dbUser = "Error";
            dbUrl = "Error";
            e.printStackTrace();
        }
        */
        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(curLine -> {
                Matcher urlMat = dbUrlPat.matcher(curLine);
                if (urlMat.matches()) {
                    dbUrl = urlMat.group(1);
                }
                else {
                    Matcher userMat = dbUserPat.matcher(curLine);
                    if (userMat.matches()) {
                        dbUser = userMat.group(1);
                    }
                }
            });
        } catch (IOException e) {
            dbUser = "Error";
            dbUrl = "Error";
            e.printStackTrace();
        }

    }
}
