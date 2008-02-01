/*
 * Rules.java
 *
 * Created on June 16, 2007, 5:36 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jags.multigame;

/**
 * @author Travis Somerville
 * Project Java Actionscript Game Server
 *
 * This code is licensed under a special open source license.
 * Please see this project's license at sourceforge.net.
 *
 * Use Rules to screen out functions that are invalid and how you route them.
 * This class can also perform any security functions you wish to check for.
 *
 */
 public class Rules {
     
     public static boolean USE_TIMESTAMPS = true;
     
    /** Creates a new instance of Rules */
    public Rules() {
    }
    
    // send and Action in
    // out comes the real Action according to the Rule, sent to the right clients.
    public static Message checkAction(Message message) {
        // if action is good, return action
        // else, return modified action
        // else return no action
        
        // default is to just send everthing back to TELL_ALL actionscript clients.
        // just realize we send the message (not just the action) so you can
        // control to whom it is sent to
       // message.tellAll = true;
        
        // for now, no rules at all...
        return message;
    }
}
