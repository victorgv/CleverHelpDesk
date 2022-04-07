package es.victorgv.cleverhelpdesk.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Objects;

@Entity
public class MasterType {
    @Id
    private Long typeId;

    @Column(length = 50, nullable = false)
    private String name;

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
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
        MasterType that = (MasterType) o;
        return typeId.equals(that.typeId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(typeId);
    }

    public MasterType(Long typeId, String name) {
        this.typeId = typeId;
        this.name = name;
    }

    public MasterType() {
    }
}
