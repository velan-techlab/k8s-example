package com.micro.app;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.net.URI;
import java.net.URL;

@FeignClient(value = "serviceCallAdapter",url = "#")
public interface AppServiceCall {

    @GetMapping("/{routeString}")
    public String callAppService(URI uri, @PathVariable("routeString") String routeString);
}
