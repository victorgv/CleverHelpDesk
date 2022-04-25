package es.victorgv.cleverhelpdesk.DTO;

// Estructura para poder poder recibir el emaill/pass desde un request y utilizarlo para validar el usuario
public class User_LoginDTO {
    private String userName;
     private String password;

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
}
