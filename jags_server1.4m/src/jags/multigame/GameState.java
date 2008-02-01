/*
 * GameState.java
 * Created on June 18, 2007, 10:12 PM
 */

package jags.multigame;

/**
 * @author Travis Somerville
 * Project Java Actionscript Game Server
 *
 * This code is licensed under a special open source license.
 * Please see this project's license at sourceforge.net.
 *
 * NOTE: This class can be the main place where you keep track of game logic.
 *
 * If you want to keep track of your world on the java side (server side),
 * then put some logic in this class.
 *
 * If you want to keep track of your world only in actionscript (client side),
 * then ignore this class.
 *
 * You can keep track on both sides too if desired.
 *
 */
public class GameState {
    
    // simple example of keeping track of something in your game world.
    public int actionCount = 0;
    private Action action = null;    
    
    public GameState() {
    }
    
    // All valid actions flow through the doAction() function.
    // Returns the Message that should be sent back in response.
    public Message doAction(Message message) {
        action = message.action;

        // example of keeping track of something
        if (actionCount < 100000) actionCount = actionCount + 1;
       // Trace.out("GameState Action Count "+ actionCount);
        
        if (action.verb.equalsIgnoreCase("get-action-count")) {
            action.clear();
            action.noun = "Number of Actions: "+ actionCount;
        }
        
        return message;
    }
    
}
