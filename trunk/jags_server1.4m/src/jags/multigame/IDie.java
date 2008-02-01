/*
 * IDie.java
 *
 * Created on May 25, 2007, 12:20 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jags.multigame;

/**
 *
 * @author Travis Somerville
 *
 * Once again, a way to let the parent know one of the Connections 
 * has died.
 *
 * This interface allows HelloSockets (or any parent of the Connections)
 * to encapsulate a clean function call.
 *
 * When the Connection lets the parent know that it wants to Die,
 * the parent can keep better information about what's going on.
 *
 */
public interface IDie {
    public void die(Connection conn);
}
