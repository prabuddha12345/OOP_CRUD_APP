import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestQuery {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/tutorease_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String user = "root";
        String pass = "Prabuddha2006";
        
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM tutor")) {
            
            System.out.println("Connected to MySQL successfully!");
            System.out.println("Tutors in DB:");
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                System.out.println(" - " + rs.getString("id") + ": " + rs.getString("name") + " (" + rs.getString("subject") + ")");
            }
            if (!hasData) {
                System.out.println("   (No tutors found)");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
