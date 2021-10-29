package com.micro.app;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

@RestController
@Slf4j
public class AppController {


    @Value("${app.version}")
    String appVersion;

    @Value("${app.name}")
    String appName;

    @Value("${app.service.suffix}")
    String suffixServiceName;

    @Autowired AppServiceCall appServiceCall;

    @PostConstruct
    public void printappInfo()
    {
        log.info("App Name {}",appName);
        log.info("AppVersion {}",appVersion);
        log.info("AppServiceSuffix {}",suffixServiceName);
    }

    @GetMapping("/{routeString}")
    public String app(@PathVariable("routeString") String routeString) throws MalformedURLException {
        String passRouteString = "";
        String routeService= "";
        log.info("route String : {}",routeString);
        String resultcurrentService = "["+routeString.substring(0,1)+":"+appVersion+"]";
        log.info("Current Service {}",resultcurrentService);
        if(routeString.length()>1) {
            resultcurrentService = resultcurrentService+",";
            passRouteString = routeString.substring(1, routeString.length());
            log.info("pass route String : {}", passRouteString);

            routeService = routeString.substring(1, 2);
            log.info("pass route service : {} , {} ", routeService, routeService.length());
        }




        if(routeService!="" && routeService!=null && routeService.length()>0)
        {
            String uriStr = "http://"+routeService+suffixServiceName;
            log.info("Internal service call {}, routeString {} ",uriStr,passRouteString);
            //resultcurrentService += this.app(passRouteString);
           resultcurrentService += appServiceCall.callAppService(URI.create(uriStr),passRouteString);
            //resultcurrentService += appServiceCall.callAppService(URI.create("http://localhost:8080"),passRouteString);
        }
        return resultcurrentService;
    }
}
