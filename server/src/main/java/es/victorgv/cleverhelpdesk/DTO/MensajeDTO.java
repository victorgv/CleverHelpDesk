package es.victorgv.cleverhelpdesk.DTO;

public class MensajeDTO {
    private String mensaje;

    public MensajeDTO(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
}
