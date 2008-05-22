/*
 * Connection.java
 *
 * Created on May 2, 2007, 7:57 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package jags.multigame;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 *
 * @author test
 */
public class Connection extends Thread {

    /** Creates a new instance of Connection */
    public Connection(GameLibrarian librarian, IBroadCast IB, IDie ID, Socket c, int count) {
        clientSock = c;
        this.librarian = librarian;
        this.IB = IB;
        this.ID = ID;
        this.connectionNumber = count;
        this.connectionName = "conn_" + connectionNumber + "c";
        Trace.out("CONNECTION STARTED: " + count + "");
    }
    
    Socket clientSock;
    PrintWriter out;
    BufferedReader in;
    IBroadCast IB;
    
    // controls killing of idle connections
    IDie ID;
    public long timeStamp = System.currentTimeMillis();
    public boolean markedToDie = false;
    public long deathTime = timeStamp;
    
    public static String SECURITY_POLICY =
            "<?xml version=\"1.0\"?><cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"80-4000\"/></cross-domain-policy> ";
    
    
    // turns raw data into readable Actions
    Message message = new Message();
    Action action = new Action();
    
    // keeps track of things if you just want to modify one java game
    // class, recompile this to your specific class and skip the fancy librarian stuff.
    GameState state = null;
    
    // by setting the gameName (below), this little class pops into action.
    // go read it's source description to understand how it finds your game.
    GameLibrarian librarian = null;
    GameTitle gameTitle = null;
    
    // Should equal a unique identifier.
    // like "travis.pong_v1.4" or "youraccount.racing_v1.6" or "public.tetris_v22.1"
    //    
    // This partitions your communications off to avoid collisions with
    // other people's games on this same server.
    public String gameName = null;
    
    // ---------------------
    //   Communications
    // --------------------- 

    // group is anonymous until set.  this means default is for everyone
    // within same gameName to hear all communications.
    public String groupName = "";
    public String connectionName = "";
    
    // a unique number id, internal to the game server only
    int connectionNumber;
    
    // Signals how many more players we need
    // Protocol is !more>4 (meaning need 4 more besides this connection)
    // the > is whatever the Message.DELIMITER is.
    public int waitingForMore = 0;
    public int groupSize = 0;
    public boolean isHost = false;

    public void setGameState(GameState gs) {
        state = gs;
    }

    // TODO: use subscriber pattern to allow multiple channels?
    // singular groups for now...
    public void setGroupName(String group) {
        this.groupName = group;
    }

    private void setGameName(String gameName) {
        this.gameName = gameName;
        if (gameTitle != null && gameTitle.getTitle().equals(gameName)) {
            return;
        }

        // Remove ourselves from the current GameTitle if exists
        if (gameTitle != null) {
            gameTitle.unregisterConnection(this);
            gameTitle = null;
        }

        // Lookup new title

        gameTitle = librarian.lookupCreate(gameName);

        // register our connection with that title
        gameTitle.registerConnection(this);

        // change our broadcaster to the GameTitle's.
        // now we are in the right game at least.
        this.IB = gameTitle.getIBroadCast();
    }

    @Override
    public void run() {
        try {
            in = new BufferedReader(new InputStreamReader(
                    clientSock.getInputStream()));
            out = new PrintWriter(clientSock.getOutputStream(), true);
            sendClient(SECURITY_POLICY + "\u0000");
            Trace.out("--------------------");
            Trace.out("SECURITY POLICY SENT");
            Trace.out("--------------------");

            // the work-horse function
            processClient(in, out);

            clientSock.close();
            Trace.out("CONNECTION CLOSED: " + connectionName + "\n");
        } catch (Exception e) {
            Trace.out("Run Exception - Connection" + connectionName + ": exception " + e);
        }
    }

    // call this from the parent only (unless you are using this class stand-alone)
    public void kill() {
        try {
            if (gameTitle != null && gameTitle.IGame != null) {
                gameTitle.unregisterConnection(this);
            }            
            //Trace.out("KILL Method "+ connectionNumber);
            this.finalize();
        } catch (Throwable ex) {
            ex.printStackTrace();
        }
    }

    // don't worry.  if this raises an exception,
    // the thread probably hasn't finished getting the output object ready.
    public void sendClient(String say) {
        try {
            out.println(say);
            out.flush();
            Trace.out("OUT: " + say);
            Trace.out("");
        } catch (Exception e) {
            Trace.out("SendClient Method exception: " + connectionName + " " + say + ":: " + e);
        }
    }

    public void processClient(BufferedReader in, PrintWriter out) {
        String line;
        boolean done = false;
        try {
            while (!done) {
                if ((line = in.readLine()) == null) {
                    done = true;
                    Trace.out("NULL input");
                } else {
                    timeStamp = System.currentTimeMillis();
                    markedToDie = false;

                    // DO Game ACTIONS and Server COMMANDS
                    handleMessage(line.trim());
                }
            }
        } catch (IOException e) {
            Trace.out("Process Client IO Exception " + connectionName + ": " + e.toString());
        } catch (Exception e2) {
            Trace.out("Process Client Exception " + connectionName + ": " + e2.toString());
        }

        ID.die(this);
    }

    private boolean handleMessage(String fullMessage) throws Exception {
        try {
            Trace.out("IN " + this.connectionName + ": " + fullMessage);
            message.parseMessage(fullMessage, this);
        } catch (Exception ex) {
            if (Rules.USE_TIMESTAMPS) {
                // Auto-add a timestamp that client forgot and try again
                Trace.out("IN " + this.connectionName + " Added Time: " + fullMessage);
                message.parseMessage(System.currentTimeMillis() + Message.DELIMITER + fullMessage, this);
            } else {
                throw ex;
            }
        }

        // Send to Rules for possible transformation
        //message = Rules.checkAction(message);
        //action = message.action;

        //if (!action.isValid) return false;

        // send it to the dynamically selected Gamestate
        // this gives your game a chance to alter the message,
        // and correct recipients.
        if (gameTitle != null && gameTitle.IGame != null) {
            gameTitle.IGame.doAction(message);
        }

        //Trace.out(message.toString());
        if (message.tellServer) {
            return doServerCommand(message);
        } else {
            // Broadcast to correct recipients.
            IB.broadcast(connectionNumber, message);
            return true;
        }
    }

    private boolean doServerCommand(Message comm) {
        String line = message.action.verb;
        boolean done = false;


        // Now that the client connection has "warmed up",
        // we can kick off a request to nail down its game name asap.
        if (gameName == null) {
            sendClient("!what_is_your_game");
        }

        // PROTOCOL COMMANDS
        if (line.trim().indexOf("!bye") > -1) {
            done = true;

        // still need to tell rules that we're leaving,
        // so other players see us gone or whatever the rule is.
        // TODO: possibly move this to ACTIONS section
        // or broadcast the player leaving.
        } // keep your connection from being killed
        else if (line.trim().indexOf("!iam_alive") > -1) {
            Trace.out(connectionName + " is alive.");
        } else if (line.trim().indexOf("!whats_my_name") > -1) {
            sendClient("!your_id" + Message.CLIENT_DELIMITER + this.connectionName);
        } else if (line.trim().indexOf("!whats_my_game") > -1) {
            sendClient("!your_game" + Message.CLIENT_DELIMITER + this.gameName);
        } else if (line.trim().indexOf("!set_my_group") > -1) {
            String[] data = line.trim().split(Message.CLIENT_DELIMITER);
            this.setGroupName(data[1]);
        } else if (line.trim().indexOf("!set_my_game") > -1) {
            String[] data = line.trim().split(Message.CLIENT_DELIMITER);
            this.setGameName(data[1]);
        } // automatically find more players
        else if (line.trim().indexOf("!auto_match") > -1) {
            String[] data = line.trim().split(Message.CLIENT_DELIMITER);
            Trace.out(
                    groupName + ":" + connectionName + " looking for up to " + data[1] + " total players.");

            waitingForMore = Integer.parseInt(data[1]);

            IB.autoMatch(this);
        } else if (line.trim().indexOf("!start_game") > -1) {
            // remove game from autoMatch
            // broadcast to group that game started
            IB.gameStarted(this);
            IB.removeHost(this);
        } else {
            Trace.out("COMMAND not found." + line);
            Trace.out("");
        }

        return done;
    }
}
