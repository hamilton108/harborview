package harborview.service.config;

import com.gargoylesoftware.htmlunit.Page;
import netfondsrepos.downloader.DefaultDownloader;
import oahu.financial.html.EtradeDownloader;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.io.Serializable;

@Configuration
@Profile("default")
public class DefaultConfig {

    @Bean
    public EtradeDownloader<Page, Serializable> downloader() {
        //return new DefaultDownloader();
        return new harborview.service.DemoDownloader();
    }

}
