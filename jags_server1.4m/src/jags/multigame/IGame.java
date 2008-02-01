package jags.multigame;

/**
 * This is the only interface you need to use to get
 * your game up and running from the server side.
 * 
 * You don't even have to use this if you want to
 * make a pure actionscript game.
 * 
 * But, if you want a database or any type of centralized 
 * java server code, here's where it all begins.
 */
public interface IGame {
    public String getName();
    public void registerConnection(Connection c);
    public void unregisterConnection(Connection c);
    public Message doAction(Message message);
}
