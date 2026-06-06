import org.apache.xerces.parsers.DOMParser;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class Validator {
    public static void main(String[] args) throws Exception {
        DOMParser parser = new DOMParser();
        parser.setFeature("http://xml.org/sax/features/validation", true);
        parser.setErrorHandler(new ErrorHandler() {
            public void warning(SAXParseException e) {
                System.out.println("WARNING [" + e.getLineNumber() + "]: " + e.getMessage());
            }
            public void error(SAXParseException e) {
                System.out.println("ERROR [" + e.getLineNumber() + "]: " + e.getMessage());
            }
            public void fatalError(SAXParseException e) throws SAXException {
                System.out.println("FATAL [" + e.getLineNumber() + "]: " + e.getMessage());
                throw e;
            }
        });
        parser.parse(args[0]);
        System.out.println("Validazione completata.");
    }
}
