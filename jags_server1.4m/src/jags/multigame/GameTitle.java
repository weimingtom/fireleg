package jags.multigame;

import java.util.ArrayList;

/**
 * A GameTitle object is created for each type of game.
 * For instance, Pong_v1.4 will get it's own GameTitle object.
 * 
 * This object keeps track of all the connections belonging
 * to it, and thus boxes in all messages so they do not bleed
 * over into someone else's game (both client side or server side).
 * 
 * Within this object, there are still game groups.
 */
public class GameTitle {

    public GameTitle(String uniqueName) {
        this.title = uniqueName;
    }
    
    public IGame IGame;
    private ArrayList <jags.multigame.Connection> connections = new ArrayList();   
    private Broadcaster broadcaster = new Broadcaster(connections);     
    private String title = "";
    
    public String getTitle() {
       return title;
    };
  
    public IBroadCast getIBroadCast() {
        return (IBroadCast) broadcaster;
    }
    
    public int registerConnection(Connection c) {
       if (IGame != null) {
        IGame.registerConnection(c);
       }
       connections.add(c);
       
       return connections.size();
    }
    public void unregisterConnection(Connection c) {
       if (IGame != null) {
           IGame.unregisterConnection(c);
       }
        connections.remove(c);
    }
}
