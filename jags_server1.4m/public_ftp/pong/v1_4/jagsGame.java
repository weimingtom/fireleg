package public_ftp.pong.v1_4;


import jags.multigame.Connection;
import jags.multigame.IGame;
import jags.multigame.Message;
import jags.multigame.Trace;
import java.util.ArrayList;

public class jagsGame implements IGame {
    private ArrayList<Connection> conns = new ArrayList();
    private int counter = 0;
    
    public String getName() {
        return "Pong 1.4";
    }

    public void registerConnection(Connection c) {
        conns.add(c);
        System.out.println("Connection Registration: "+ c.getName());
    }

    public void unregisterConnection(Connection c) {
        conns.remove(c);
        System.out.println("Connection Unregistration: "+ c.getName());
    }

    public Message doAction(Message message) {
        counter = counter + 1;
        Trace.out(this.getName() +"MSG # "+ counter +"IN: "+ message);

        return message;
    }
    
}
