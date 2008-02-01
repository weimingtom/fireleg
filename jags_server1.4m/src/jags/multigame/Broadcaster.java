/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package jags.multigame;

import java.util.ArrayList;

/**
 * Handy class to send messages, completely limited to your list of connections.
 * 
 * Notice that the constructor requires a list to send to.
 * At least pass it an initialized ArrayList.
 * 
 * If you change your mind about which ArrayList it should be sending out
 * to, then use setConnections method.
 * 
 * Groups are respected within list of connections.
 */
public class Broadcaster implements IBroadCast {
    
    // Some kind of throtle controls here
    // public megabytesSent ...
    // public networkTrafficPerMinute ...
    // getNumberConnections... etc.

    public Connection connectionLookingForPlayers = null;
    public ArrayList <jags.multigame.Connection> connections = null;
    
    public Broadcaster(ArrayList <jags.multigame.Connection> connections) {
        this.connections = connections;
    }
    
    public void setConnections(ArrayList <jags.multigame.Connection> connections) {
        if (connections.equals(this.connections)) return;
        
        connectionLookingForPlayers = null;
        this.connections = connections;
    }
    
    // allows connections to callback to all other connections
    public void broadcast(int connectionNumber, Message message) {
        // keeps track of message being broadcast
        String outgoing = null;        
        int i = -1;    
        
        try {
            //Trace.out("Connections size for broadcast = "+ connections.size());
            
            outgoing = message.packageMessage();
            // ------------------------
            //     TELL ALL Clients
            // ------------------------
            if (message.tellAll == true) {
                for (i=0; i < connections.size(); i++) {
                    connections.get(i).sendClient(outgoing);
                }
            }
            // ------------------------
            //     TELL OTHER Clients
            // ------------------------
            else if (message.tellOthers == true) {
                for (i=0; i < connections.size(); i++) {
                    Connection c = connections.get(i);
                    if (connectionNumber != c.connectionNumber) {
                        connections.get(i).sendClient(outgoing);
                    }                   
                }
            }
            // ---------------------------------------------------
            //     TELL Selected TO[] (groups or individuals)
            //  You can send to Group_x instead of just a person.
            // ---------------------------------------------------            
            else if (message.tellSelect == true){
                String toAddress = message.toThese();
                for (i=0; i < connections.size(); i++) {
                    Connection c = connections.get(i);                
                    if (toAddress.indexOf(c.groupName) > -1 || toAddress.indexOf(c.connectionName) > -1) {
                        // NOTE: TODO short group names may accidentally
                        // be sent messages. either make this code search each to[n]
                        // or make sure people use complex group names.
                        c.sendClient(outgoing);
                    }
                }
            }
            else Trace.out("WARN: Cannot determine whom to send msg to.");
            
        } catch (Exception e) {
            Trace.out("Broadcast exception on loop "+ i +" "+ e.toString());
        }
    }

    private void tellGroupMyselfIncluded(String verb, Connection conn) {
        Message m = new Message();
        m.tellSelect = true;
        m.from = conn.connectionName;
        m.to = new String[1];
        m.to[0] = conn.groupName;
        m.action.setTime(System.currentTimeMillis());
        m.action.setVerb(verb);
    	this.broadcast(conn.connectionNumber, m);
    }
    
    public void gameStarted(Connection conn) {
        tellGroupMyselfIncluded("!start_game"+ Message.CLIENT_DELIMITER + conn.groupName, conn);
    }

    public void removeHost(Connection conn) {
         synchronized(this) {
             if (connectionLookingForPlayers == conn)
                 connectionLookingForPlayers = null;
         } 
         
         tellGroupMyselfIncluded("!remove_connection"+ Message.CLIENT_DELIMITER + conn.connectionName, conn);
    }
    
    public void autoMatch(Connection conn) {
        synchronized(this) {
            // ---------------------
            //   HOST the Game
            // ---------------------
            if (connectionLookingForPlayers == null) {
                connectionLookingForPlayers = conn;
                if (conn.groupName.equals("")) {
                    conn.groupName = "group_"+ conn.connectionNumber +"g";
                    // Let client know
                    conn.sendClient("!name_group"+ Message.CLIENT_DELIMITER + conn.groupName);
                    conn.sendClient("!you_host"+ Message.CLIENT_DELIMITER +conn.connectionName);

                    Trace.out("NEW GAME: "+ conn.groupName);
                }
            }
            // ---------------------
            //   ATTACH to the Game
            // ---------------------
            else {
                connectionLookingForPlayers.waitingForMore --;
                connectionLookingForPlayers.sendClient("!add_player"+ Message.CLIENT_DELIMITER + conn.connectionName);

                conn.waitingForMore = 0;
                conn.sendClient("!joined_host"+ Message.CLIENT_DELIMITER + connectionLookingForPlayers.connectionName);
                conn.sendClient("!name_group"+ Message.CLIENT_DELIMITER + connectionLookingForPlayers.groupName);            

                // Get ready for next game host
                if (connectionLookingForPlayers.waitingForMore == 0)
                    connectionLookingForPlayers = null;
            }
        }
    }  
}
