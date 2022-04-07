package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
public class MasterStatus {
    @Id
    private Long statusId;

    @Column(length = 50, nullable = false)
    private String name;

    public Long getStatusId() {
        return statusId;
    }

    public void setStatusId(Long statusId) {
        this.statusId = statusId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MasterStatus that = (MasterStatus) o;
        return statusId.equals(that.statusId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(statusId);
    }

    public MasterStatus(Long statusId, String name) {
        this.statusId = statusId;
        this.name = name;
    }

    public MasterStatus() {
    }
}


