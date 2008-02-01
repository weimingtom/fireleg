package deeper;


//import jags.multigame.GameTitle;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Compaq_Owner
 */
public class FindClassTest {
    @SuppressWarnings("static-access")
    public static void main(String[] args) {
        try {
            Thread t = Thread.currentThread();
            ClassLoader cl = t.getContextClassLoader();
            Class c = cl.loadClass("Reg");

            //           Class c = Class.forName("MyGame");
           // Reg r = (Reg) c.newInstance();
           // r.main(null);
            
            //C:\netbeans6.0_out\jags_server1.4m;
            Class c2 = cl.loadClass("jags.multigame.Connection");
            System.out.println("Found c2");

            //Class c3 = cl.loadClass("jags.multigame.public_ftp.chat.v1_1.Hello");
            //System.out.println("Hello found");
            
            //String s = c.getPackage().toString();
           // System.out.println("Name is "+ s);
            //System.out.println("Found " + c.getName() + " :: " + c.getPackage().toString());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(FindClassTest.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
