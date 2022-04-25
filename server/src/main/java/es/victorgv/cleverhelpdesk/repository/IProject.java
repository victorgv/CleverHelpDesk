package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IProject extends JpaRepository<Project, Long> {

}
