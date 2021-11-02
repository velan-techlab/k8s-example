package com.micro.app;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import lombok.extern.apachecommons.CommonsLog;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

@Component
@Slf4j
public class PropagateHeadersInterceptor implements RequestInterceptor {

    @Autowired
    private HttpServletRequest request;

    @Override
    public void apply(RequestTemplate requestTemplate) {
        try
        {
            Enumeration<String> e = request.getHeaderNames();
            while (e.hasMoreElements())
            {
                String header = e.nextElement();
                String value = request.getHeader(header);
                log.info("Header {}, value {}",header,value);
                if (header.startsWith("x-"))
                {
                    requestTemplate.header(header, value);
                }
            }
        }
        catch(IllegalStateException e)
        {}
    }
}
