
import java.io.File;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Compaq_Owner
 */
public class Test1 {
    public static void main(String[] args) {

        try {
            File f = new File("public");
            System.out.println("Abs Path = " + f.getAbsolutePath());
            System.out.println("Can Path = " + f.getCanonicalPath());
            System.out.println("Path = " + f.getPath());

            File[] authors = f.listFiles();
            for (int i = 0; i < authors.length; i++) {
                System.out.println("Author :"+ authors[i].getName());
                
                File[] titles = authors[i].listFiles();
                for (int j = 0; j < titles.length; j++) {
                    System.out.println("Title :"+ titles[j].getName());
                    
                    File[] versions = titles[j].listFiles();
                    for (int k = 0; k < versions.length; k++) {
                         System.out.println("Version :"+ versions[k].getName());
                         
                         // grab resources by name...
                    }
                }
            }
            
        } catch (IOException ex) {
            //Logger.getLogger(HelloSockets.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
