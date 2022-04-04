package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "user_")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator= "user_id_generator")
    @SequenceGenerator(name="user_id_generator", sequenceName = "user_seq")
    private Long userId;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Column(length = 100, nullable = false)
    private String email;

    @Column(length = 60, nullable = false)
    private String name;

    @Column(length = 25, nullable = false, unique = true)
    private String userName;

    @Column(length = 25, nullable = false)
    private String password;

    @Column(length = 25, nullable = false)
    private String role;

    public User() {

    }

    public User(String email, String name, String userName, String password, String role) {
        this.email = email;
        this.name = name;
        this.userName = userName;
        this.password = password;
        this.role = role;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return userId.equals(user.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId);
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + userId +
                ", name='" + name + '\'' +
                ", userName='" + userName + '\'' +
                ", password='" + password + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
