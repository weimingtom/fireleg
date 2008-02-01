package jags.multigame;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * You write a class called JAGSGame.class (which must implement IGame), 
 * and this object will find it when needed.
 * 
 * Of course, the JAGSGame.class has to be in a folder considered safe 
 * to the JAGS Server.
 * 
 * In addition, the GameLibrarian knows to look for 
 */
public class GameLibrarian {
    ArrayList<GameTitle> gameTitles = new ArrayList<GameTitle>();
    ArrayList authors = new ArrayList();
    
    public GameLibrarian() {
        authors.add("public_ftp");
        File f = new File("");
        System.out.println("File Home :"+ f.getAbsolutePath() );
        
        // TODO: add private accounts for other authors.  
        // like a property file of accounts lookup,
        // or a list of all the directories in a certain folder.
        // The properties way could keep meta data... maybe better.
        // Or a full db of users.
        
        loadTitlesFromDisk();
    }
    
    public void loadTitlesFromDisk() {
        try {
            String author = null;
            String title = null;
            String version = null;

            for (int n = 0; n < authors.size(); n++) {
                author = (String) authors.get(n);
                File root = new File(author);
                System.out.println("");
                System.out.println("Abs Path = " + root.getAbsolutePath());
                System.out.println("Author :"+ author);

                File[] titles = root.listFiles();
                for (int j = 0; j < titles.length; j++) {
                    title = titles[j].getName();
                    System.out.println("Title :"+ title);

                    File[] versions = titles[j].listFiles();
                    for (int k = 0; k < versions.length; k++) {
                        version = versions[k].getName();
                         System.out.println("Version :"+ version);

                         String uniqueName = author +"."+ title +"."+ version;
                         lookupCreate(uniqueName);
                    }
                }
            }
            
        } catch (Exception ex) {
            System.out.println("loadTitlesFromDisk "+ ex);
            Logger.getLogger(HelloSockets.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
 
   // find or create title
    public GameTitle lookupCreate (String uniqueName) {
        // look in our list first to see if it uses server resources
        boolean found = false;
        for (int i = 0; i < gameTitles.size(); i++) {
            if (gameTitles.get(i).getTitle().equals(uniqueName)) {
                found = true;
                return gameTitles.get(i);
            }
        }
        
        GameTitle title = new GameTitle(uniqueName);
        gameTitles.add(title);
        
        // attach IGame object if available
        title.IGame = findIGame(uniqueName);
        
        return title;
    }        
    
    private IGame findIGame(String uniqueName) {
        String theGame = uniqueName +".jagsGame";
        try {
            Thread t = Thread.currentThread();
            ClassLoader cl = t.getContextClassLoader();
            Class c = cl.loadClass(theGame);

            IGame igame = (IGame) c.newInstance();
            return igame;
        }
        catch (Exception e) {
            // No server extensions are needed for this game.
            System.out.println("INFO: IGame"+ theGame +" does not have server files.");
            return null;
        }
    }    
    
 
}
