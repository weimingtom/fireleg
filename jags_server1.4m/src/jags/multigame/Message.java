/*
 * Message.java
 * Created on June 16, 2007, 5:38 PM
 */

package jags.multigame;

import java.util.ArrayList;

/**
 * @author Travis Somerville
 * Project Java Actionscript Game Server
 * 
 * This code is licensed under a special open source license.  
 * Please see this project's license at sourceforge.net.
 *
 * This class wraps the Action.
 * Message keeps track of who it's going to, whom it came from,
 * the timeStamp, etc.
 */
public class Message {
    
    public Action action = new Action();
    public String from= "";
    public String[] to;
    public String format = "";
    
    public Connection conn = null;
   
    // PROTOCOL:
    // tellAll means everyone including the sender
    // tellOthers means everyone except the sender
    // tellSelect tells a selected list of clients
    public boolean tellAll;
    public boolean tellOthers;
    public boolean tellSelect;
    public boolean tellServer;    
    
    public static int TELL_ALL      = 5;
    public static int TELL_OTHERS   = 10;
    public static int TELL_SELECT   = 15;       
    public static int TELL_SERVER   = 20; 
    
    public static String DELIMITER          = ">";
    public static String CLIENT_DELIMITER   = ":";
    public static String TO_DELIMITER       = ",";
    
    /** Creates a new instance of Message */
    public Message() {
    }
    
    public void clearMessage(){
        action.setupAction("");
        to = null;
        from = null;
        tellAll = false;
        tellOthers = false;
        tellSelect = false;
        tellServer = false;
        conn = null;
    }
    
    // takes raw format of message string and transforms into an object
    // time>from>format>to>message
    //
    // added the requirement to supply a connection, to make sure it's set each time.
    // we use this connection object later in IGame extensively.
    public void parseMessage(String message, Connection conn) {
        clearMessage();
        this.conn = conn;
        
        // parse something like:
        // TimeStamp>From>To[!All | !Others | johnny3,billy56,sarah908]>Action        
        String[] headers = message.split(DELIMITER);
        
        int i = 0;
        if (Rules.USE_TIMESTAMPS == true) {
           action.setTime(Long.parseLong(headers[i]));
           i++;
        }       
        from = headers[i];
        i++;
        
        format = headers[i];
        i++;
        
        to = headers[i].split(TO_DELIMITER);
        if (to != null && to[0].equalsIgnoreCase("!all")) tellAll = true;
        else if (to != null && to[0].equalsIgnoreCase("!others")) tellOthers = true; 
        else if (to != null && to[0].equalsIgnoreCase("!server")) tellServer = true; 
        else tellSelect = true;
        i++;
       
        // create Action by parsing actor:verb:noun
        // TODO: split the string into its real components
        // don't forget to parse time based on Rules variable
        action.setupAction(headers[i]);
    }
    
    public void replyOnlyToSender() {
        replyOnlyTo(conn.connectionName);
    }

    public void replyOnlyTo(String recipient) {
        this.to = null;
        this.to = new String[1];
        this.to[0] = recipient;
    }

    
    // transforms to[] back to simple String
    public String toThese() {
        StringBuilder toThese = new StringBuilder();
        for (int i =0; i < to.length; i++) {
            toThese.append(to[i]);
            if (i + 1 < to.length) toThese.append(TO_DELIMITER);
        }
        
        return toThese.toString();
    }
    
    // takes this object and puts it back into the form of a string
    public String packageMessage() {
        String r;
        if (Rules.USE_TIMESTAMPS == true) {
            r = action.timeStamp +DELIMITER+ 
                from +DELIMITER+ 
                format +DELIMITER+
                //toThese() +DELIMITER+
                action.toString();
            return r;
        }
        else {
            return 
            from +DELIMITER+ 
            format +DELIMITER+                    
            //toThese() +DELIMITER+
            action.toString();
        }
    }
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("MESSAGE:\n");
        sb.append("  TIME: "+ action.timeStamp +"\n");        
        sb.append("  FROM: "+ from +"\n");
        sb.append("  FORMAT: "+ format +"\n");        
        sb.append("  TO: "+ toThese() +"\n");
        sb.append("  Action Verb: "+ action.verb +"\n");
        
        return sb.toString();
    }
}
