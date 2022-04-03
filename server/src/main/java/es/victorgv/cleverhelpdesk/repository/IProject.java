package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IProject extends JpaRepository<Project, Long> {

}
