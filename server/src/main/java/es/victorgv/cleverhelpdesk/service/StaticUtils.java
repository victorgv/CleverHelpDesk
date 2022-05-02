package es.victorgv.cleverhelpdesk.service;

// Algunas funciones de utilidad estáticas (no instanciaremos la clase)
public class StaticUtils {
    // Devuelve el valorAlternativo si el valorOriginal
    public static String NVL(String valorOriginal, String valorAlternativo) {
        if (valorOriginal == null || valorOriginal == "")
            return valorAlternativo;

        return valorOriginal;
    }
}
