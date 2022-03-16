package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.User;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;

//@SpringBootTest
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class UserTest {
    @Autowired
    private IUser repo;

    @Test
    public void saveUser() {
        User victor = new User("ViCtOr *TEST*", "testtest", "???", "USUARIO");
        repo.save(victor);

        repo.flush();


        assertEquals(1, repo.findAll().size());
    }



}
