package harborview.aop;

import com.gargoylesoftware.htmlunit.Page;
import com.gargoylesoftware.htmlunit.WebResponse;
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import java.io.*;

@Aspect
@Component
public class DownloadAspect {

    @Pointcut("@annotation(oahu.annotations.StoreHtmlPage) && execution(* *(..)) && args(ticker)")
    private void storeHtmlPagePointcut(String ticker){}

    @Around("storeHtmlPagePointcut(ticker)")
    public Object aroundAdvice(ProceedingJoinPoint jp, String ticker) {
        try {
            System.out.println("DOWNLOADING " + ticker);
            Page page = (Page)jp.proceed();
            if (page.isHtmlPage()) {
                HtmlPage htmlPage = (HtmlPage)page;
                WebResponse response = htmlPage.getWebResponse();
                String content = response.getContentAsString();



                String fileName = String.format("/home/rcs/opt/java/harborview/feed/%s.html", ticker);

                FileWriter fileWriter = new FileWriter(fileName);
                PrintWriter printWriter = new PrintWriter(fileWriter);
                printWriter.print(content);
                printWriter.close();

                /*
                FileOutputStream fos = new FileOutputStream(fileName);
                DataOutputStream outStream = new DataOutputStream(new BufferedOutputStream(fos));
                outStream.writeUTF(content);
                outStream.close();

                 */

                //htmlPage.save(new File(
            }

            return page;
        } catch (Throwable throwable) {
            throwable.printStackTrace();
            throw new RuntimeException(throwable);
        }
    }
}
