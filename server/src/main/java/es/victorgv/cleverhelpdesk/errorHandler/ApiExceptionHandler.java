package es.victorgv.cleverhelpdesk.errorHandler;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

// Clase encargada de capturar las excepciones y formaterlas en un objeto ErrorMessage para que todos los errores de la aplicación
// tengan una gestión y un formato uniforme. Permitirá también al cliente controlar con este objeto ErrorMessage si se ha producido un error
// así como gestionarlo.

@ControllerAdvice
public class ApiExceptionHandler {

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler({
            org.springframework.dao.DuplicateKeyException.class,
            org.springframework.web.bind.support.WebExchangeBindException.class,
            org.springframework.http.converter.HttpMessageNotReadableException.class,
            org.springframework.web.server.ServerWebInputException.class
    })
    @ResponseBody
    public ErrorMessage badRequest(Exception exception) {
        return new ErrorMessage(exception, HttpStatus.BAD_REQUEST.value());
    }


    // Resto de errores no controlados previamente
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler({
            Exception.class
    })
    @ResponseBody
    public ErrorMessage exception(Exception exception) { // The error must be corrected
        exception.printStackTrace();
        return new ErrorMessage(exception, HttpStatus.INTERNAL_SERVER_ERROR.value());
    }




}
