package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.MasterStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IMasterStatus extends JpaRepository<MasterStatus, Long> {
}
