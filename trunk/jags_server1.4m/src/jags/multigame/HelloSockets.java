/*
 * Main.java
 *
 * Created on March 10, 2007, 2:56 PM
 * Travis Somerville
 *
 * HelloSockets manages Connections.
 * Each Connection is a socket to the client.
 *
 * HelloSockets by default echos ALL messages back to ALL clients.
 * This is a quick way to allow actionscript clients to start communicating.
 * 
 * The only protocol the client needs to respond to is the "?ru_alive" question.
 * If the client doesn't send communications in response, and hasn't been
 * sending any other types of messages, the HelloSockets manager will kill that
 * connection, freeing up memory.
 *
 * NOTE: Set these variables.
 * portNumber is the port the server listens on.
 * The timeToLive is in seconds and is a global variable below.
 * 
 */

package jags.multigame;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author test
 */
public class HelloSockets implements IDie{
    private ArrayList <jags.multigame.Connection> connections = new ArrayList();   
    private Broadcaster broadcaster = new Broadcaster(connections);    
    public GameLibrarian librarian = new GameLibrarian();
    
    private ArrayList <jags.multigame.Connection> games = new ArrayList();    
    
    public int timeToLive = 10;
    public static int portNumber = 82;
    
    public GameState state = new GameState();
    
    public HelloSockets() {
    	this(HelloSockets.portNumber);
    }
    
    public HelloSockets(int port) {
        try {
            ServerSocket serverSock = new ServerSocket(portNumber);
            Socket clientSock;
            BufferedReader in;
            PrintWriter out;
            
            int count = 0;
            
            Trace.out("\nLISTENING on PORT "+ portNumber);
            while(true) {
                //Trace.out("\n READY: "+ count +"\n");
                clientSock = serverSock.accept();
                Trace.out("CONN # "+ count +" :"+
                            clientSock.getInetAddress().getHostAddress());
                
                Connection c = new Connection(librarian, (IBroadCast) broadcaster, (IDie) this, clientSock, count);
                c.setGameState(state);
                connections.add(c);
                c.setDaemon(true);
                c.start();
                //c.sendClient("!your_id" + Message.DELIMITER + count);                 
                count++;
                
                // take the time to kill any Connection that has been idle for more than
                // x seconds.  I divide the timeToLive in half because we try
                // kill the connection and then need to wait an equal amount of time.
                killOldConnections(timeToLive / 2 + 1);
            }
        }
        catch (Exception e) {
            Trace.out("Hello Sockets Constructor Loop Exception "+ e);
        }
    }
    
    // We ask the client if they are still alive before killing it,
    // and give it a resonable chance to respond.
    //
    // PROTOCOL:
    // the client must answer our question "?ru_alive"
    // with "!iam_alive" or we kill it on the next check if enough time has passed.
    private void killOldConnections(long seconds) {
        Trace.out("# Conns:"+ connections.size());
        
        long maxMillis = seconds * 1000;
        long now = System.currentTimeMillis();
        
        Connection conn;
        for (int i=0; i < connections.size(); i++) {
            conn = connections.get(i);
            if (now - conn.timeStamp > maxMillis) {
                // Starts the death process...
                if (conn.markedToDie == false) {
                    conn.markedToDie = true;
                    conn.deathTime = now + maxMillis;
                    conn.sendClient("!ru_alive");
                    Trace.out(conn.connectionName +" marked to die.");
                }
                // Finishes the death process if enough time has passed.
                // We have to allow more time in case the client is in
                // the process of responding.
                else if (now - conn.deathTime > maxMillis) {
                    Trace.out("Kill Old "+ i);
                    die(conn);
                }
            }
        }        
    }
    
    // allows connections to let this class manage the death of connections
    public void die(Connection conn) {
    	broadcaster.removeHost(conn);
        connections.remove(conn);
        conn.kill();
    } 
    
    /**
     * list your favorite port to use, or we'll use default
     */
    public static void main(String[] args) {
            HelloSockets hs;
            hs = new HelloSockets();
    }
    
}
