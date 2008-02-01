/*
 * Action.java
 *
 * Created on June 16, 2007, 5:38 PM
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
 * NOTE: Modify this class to parse Actions the way you see fit.
 * This class is where you add the meat an potatoes of recognizing commands.
 *
 */
public class Action {
    
    public boolean isValid = true;
    public String verb = "";
    public String actor = "";
    public String noun = "";
    public long timeStamp = -1;
    
    /** Creates a new instance of Action */
    public Action() {
    }
    
    public void setupAction(String theAction) {
        // parse the string into this object
        // set time
        // set noun
        // set verb
        // set actor
        
        // for now...
        this.timeStamp = System.currentTimeMillis();
        this.setVerb(theAction);
    }
    
    public String toString() {
        return this.verb;
    }
    
    public void clear() {
        // clear all parts of action
        noun = null;
        verb = null;
        actor = null;
        timeStamp = -1;
    }
    
    public void setTime(long time) {
        timeStamp = time;
    }
    
    public void setVerb(String doThis) {
        verb = doThis;
    }
}
