package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.MasterType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IMasterType extends JpaRepository<MasterType, Long> {
}
