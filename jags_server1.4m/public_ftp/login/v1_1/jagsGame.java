package public_ftp.login.v1_1;


import jags.multigame.Connection;
import jags.multigame.IGame;
import jags.multigame.Message;
import java.util.ArrayList;

public class jagsGame implements IGame {
    
    private ArrayList<Connection> conns = new ArrayList();
    
    public String getName() {
        return "Realmics Login v1.1";
    }
    
    public void registerConnection(Connection c) {
        conns.add(c);
    }

    public void unregisterConnection(Connection c) {
        conns.remove(c);
    }

    public Message doAction(Message message) {
        return message;
    }
}
