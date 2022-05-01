package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.DTO.MensajeDTO;
import es.victorgv.cleverhelpdesk.DTO.User_LoginDTO;
import es.victorgv.cleverhelpdesk.DTO.User_NewDTO;
import es.victorgv.cleverhelpdesk.model.MasterStatus;
import es.victorgv.cleverhelpdesk.model.MasterType;
import es.victorgv.cleverhelpdesk.model.Project;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IMasterStatus;
import es.victorgv.cleverhelpdesk.repository.IMasterType;
import es.victorgv.cleverhelpdesk.repository.IProject;
import es.victorgv.cleverhelpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/global")
public class ProjectController {
    @Autowired IMasterType repo_masterType;
    @Autowired IMasterStatus repo_masterStatus;
    @Autowired IProject repo_project;


    @GetMapping("/type")
    public List<MasterType> masterType_findAll() {
        return repo_masterType.findAll();
    }

    @GetMapping("/status")
    public List<MasterStatus> masterStatus_findAll() {
        return repo_masterStatus.findAll();
    }

    @GetMapping("/project")
    public List<Project> project_findAll() {
        return repo_project.findAll();
    }


}
