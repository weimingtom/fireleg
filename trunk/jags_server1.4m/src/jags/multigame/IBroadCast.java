/*
 * IBroadCast.java
 *
 * Created on May 13, 2007, 11:09 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jags.multigame;

/**
 *
 * @author test
 *
 * Offers a way for one Connection to talk to all the others.
 *
 * Allows the HelloSockets class to offer a callback to the 
 * Connection objects.
 *
 * Basically, this Interface encapsulates HelloSockets.
 * Otherwise, I would have to give a reference of the entire HelloSockets
 * instance to the Connection object.  With the Interface, I can offer only
 * a small portion of it to the Connection and thus it's cleaner.
 *
 */
public interface IBroadCast {
    public void broadcast(int connectionNumber, Message message);
    public void autoMatch(Connection conn);
    public void gameStarted(Connection conn);
    public void removeHost(Connection conn);    
}
