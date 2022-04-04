package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
public class Role {

    @Id
    @Column(name = "roleCode", nullable = false)
    private String roleCode; // posibles códigos ADMIN, USER, AGENT - se inicializan al lanzar la aplicación

    @Column(length = 60, nullable = false)
    private String name;


    public Role() {
    }

    public Role(String code, String name) {
        this.roleCode = code;
        this.name = name;
    }

    public String getCode() {
        return roleCode;
    }

    public void setCode(String code) {
        this.roleCode = code;
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
        Role role = (Role) o;
        return roleCode.equals(role.roleCode);
    }

    @Override
    public int hashCode() {
        return Objects.hash(roleCode);
    }
}
