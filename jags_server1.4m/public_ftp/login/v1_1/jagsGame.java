package public_ftp.login.v1_1;


import jags.multigame.Connection;
import jags.multigame.IGame;
import jags.multigame.Message;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public class jagsGame implements IGame {
    
    private ArrayList<Connection> conns = new ArrayList();
    
    // example of mapping your game state to the connections.
    // in this case, you want to know if they are logged in, language, etc.
    private HashMap<String, YourGameState> myStates = new HashMap<String, YourGameState>();
    
    public String getName() {
        return "Realmics Login v1.1";
    }
    
    public void registerConnection(Connection c) {
        conns.add(c);

        // call your code that needs to refer to this connection...
        YourGameState state = new YourGameState();
        myStates.put(c.getName(), state);
    }

    public void unregisterConnection(Connection c) {
        conns.remove(c);
        myStates.remove(c.getName());
        // notify your code as needed...
    }

    public Message doAction(Message message) { 
        // possibly add connection to all messages
        // and then make sure the conn is registered here
        // and that everything is mapped.
        // for some reason, i caught the register/unreg event before
        // but i'm not getting the event here now!
        
        // availabe states in map
        for (Iterator<String> it = myStates.keySet().iterator(); it.hasNext();) {
            String s = it.next();
            System.out.println(s +":"+ myStates.get(s));
        }
        
        YourGameState state;
        try {
            state = (YourGameState) myStates.get(message.conn.getName());

            if (message.action.verb.contains("login_me_in")) {
                // do code for login - you would actually do a check in your game.
               state.loggedIn = true;
            }

            // do a check to make sure they are logged in.
            // you can modify messages and send them back...
            /*
             if (!state.loggedIn && !message.tellServer) {
                message.action.verb = "^^please_log_in^^";
                message.to = new String[1];
                message.to[0] = message.from;
                return message;
            }
             */

            if (message.action.verb.contains("choose_language")) {
                state.language = message.action.verb;
            }
        } catch (Exception e) {
            System.out.println("message exception "+ e.toString());
        }
        
        return message;
    }
}
