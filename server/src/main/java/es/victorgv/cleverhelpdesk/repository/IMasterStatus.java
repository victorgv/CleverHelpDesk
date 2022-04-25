package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.MasterStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IMasterStatus extends JpaRepository<MasterStatus, Long> {
}
