package es.victorgv.cleverhelpdesk.config;

import es.victorgv.cleverhelpdesk.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;

@Configuration
public class DatabasePopulateConfig {
    @Autowired
    RoleService roleService;

    @PostConstruct
    public void populate() {
        roleService.init();
    }



}
