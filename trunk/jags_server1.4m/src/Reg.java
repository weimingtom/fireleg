/*
 * Reg.java
 *
 * Created on August 18, 2007, 2:45 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author test
 */
public class Reg {
    
    /** Creates a new instance of Reg */
    public Reg() {
    }
    
    public void parse(String s, String delimiter) {
        String[] bits = s.split(delimiter);
        System.out.println("Delimiter "+ delimiter +" ");         
        
        for (int i=0; i < bits.length; i++) {
           System.out.println(bits[i]);
        }
        
        System.out.println("-------------------------------");
    }
    
    public static void main(String[] args) {
        Reg r = new Reg();
        r.parse(" |!All|Foo", "\\|");
       // r.parse(" -!All-Foo", "-");
       // r.parse(" ,!All,Foo", ",");        
    }
    
}
