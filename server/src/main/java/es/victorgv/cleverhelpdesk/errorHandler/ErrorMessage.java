package es.victorgv.cleverhelpdesk.errorHandler;

// Clase que permitirá devolver un mensaje de error uniforme al cliente para que este lo pueda tratar adecuadamente
public class ErrorMessage {
    private final String error;
    private final String message;
    private final Integer code;

    ErrorMessage(Exception e, Integer c) {
        this.error = e.getClass().getSimpleName();
        this.message = e.getMessage();
        this.code = c;
    }

    public String getError() {
        return error;
    }

    public String getMessage() {
        return message;
    }

    public Integer getCode() {
        return code;
    }

    @Override
    public String toString() {
        return "ErrorMessage{" +
                "error='" + error + '\'' +
                ", message='" + message + '\'' +
                ", code=" + code +
                '}';
    }
}
