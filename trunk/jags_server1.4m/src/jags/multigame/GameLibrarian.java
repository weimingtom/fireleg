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
        //authors.add("public_ftp");
        File f = new File("");
        System.out.println("Abs Server Home :"+ f.getAbsolutePath() );
        
        loadTitlesFromDisk();
    }
    
    public static String folderContainingGames = "games";
    
    public void loadTitlesFromDisk() {
        try {
            String author = null;
            String title = null;
            String version = null;

            File root = new File(folderContainingGames);  
            if (root == null) return;            
            System.out.println("");
            System.out.println("Abs Path of Games = " + root.getAbsolutePath());            

            File[] authorFiles = root.listFiles();
            if (authorFiles == null) return;
            
            for (int n = 0; n < authorFiles.length; n++) {
                author = (String) authorFiles[n].getName();
                //File root = new File(folderContainingGames + File.separator + author);

                System.out.println("Author :"+ author);

                File[] titles = authorFiles[n].listFiles();
                if (titles == null) return;
                
                for (int j = 0; j < titles.length; j++) {
                    title = titles[j].getName();

                    File[] versions = titles[j].listFiles();
                    if (versions == null) return;
                    for (int k = 0; k < versions.length; k++) {
                        version = versions[k].getName();

                         String uniqueName = author +"."+ title +"."+ version;
                         if (!uniqueName.contains(".svn") && !uniqueName.contains(".cvs")) {
                             System.out.println("Title :"+ title +":"+ version);
                             lookupCreate(uniqueName);
                         }
                    }
                }
            }
            
        } catch (Exception ex) {
            System.out.println("Function loadTitlesFromDisk "+ ex);
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
