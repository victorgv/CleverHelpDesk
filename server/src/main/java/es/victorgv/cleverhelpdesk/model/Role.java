package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
public class Role {

    @Id
    @Column(name = "code", nullable = false)
    private String code; // posibles códigos ADMIN, USER, AGENT - se inicializan al lanzar la aplicación

    @Column(length = 60, nullable = false)
    private String name;

    public Role() {
    }

    public Role(String code, String name) {
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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
        return code.equals(role.code);
    }

    @Override
    public int hashCode() {
        return Objects.hash(code);
    }
}
