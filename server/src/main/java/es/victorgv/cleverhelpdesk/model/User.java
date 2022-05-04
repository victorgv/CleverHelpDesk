package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Objects;
import java.util.Optional;

@Entity
@Table(name = "user_")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator= "user_id_generator")
    @SequenceGenerator(name="user_id_generator", sequenceName = "user_seq")
    private Long userId;

    @Column(length = 25, nullable = false, unique = true)
    private String userName;

    @Column(length = 60, nullable = false)
    private String name;

    @Column(length = 100, nullable = false, unique = true)
    private String email;

    @Column(length = 250, nullable = false)
    private String password;


    @ManyToOne(optional = false)
    @JoinColumn(name = "role_code", foreignKey = @ForeignKey(name="user_role_fk"))
    private Role role;

    private LocalDate deletedDate;


    public LocalDate getDeletedDate() {
        return deletedDate;
    }

    public void setDeletedDate(LocalDate deletedDate) {
        this.deletedDate = deletedDate;
    }



    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return userId.equals(user.userId) && email.equals(user.email) && userName.equals(user.userName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, email, userName);
    }

    public User() {
    }

    public User(String userName, String name, String email, String password, Role role, LocalDate DeletedDate) {
        this.userName = userName;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.deletedDate = DeletedDate;
    }


}
