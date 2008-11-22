package
{
	import jags.multigame.NetworkConnection;
	import jags.multigame.GameTextEvent;
	import jags.multigame.Config;
	import flash.events.Event;
	
	public class YourCommands
	{
		[Bindable] public var gameServer:jags.multigame.NetworkConnection;

		// Items related to this demo or your specific game
		[Bindable] public var loggedIn:Boolean = false;
		[Bindable] public var numberOfPlayers:int;
		[Bindable] public var language:String;

		// Really important!  Please set a uniqueGameName.
		//
		// Something like "public.johns_racegame.v1_0" would work.
		// Yes, literally put "public." in front of your name,
		// and then end it with ".versionx_x".
		//
		// I use those dots to find folders with your java code on
		// the back-end server.  If you're not writing any custom
		// java code on the back-end, just play along and make up a name.
		//
		// Until you change this, your will get communications from
		// everyone else that didn't change it... your games will
		// chatter at each other...
		public static var gameName:String = "public_ftp.login.v1_1";
				
		public function YourCommands() {
			gameServer = new NetworkConnection(gameName, Config.URL, Config.port, onIDReceived);
			registerCommands();
			gameServer.connect();
		}
		
		/******************************
		 *  COMMUNICATING TO PLAYERS
		 ******************************/
		public function sendMyUpdate(any_data_you_want:String):void {
			gameServer.sayMyGroup("your_game_command_1", any_data_you_want);
		}				
		
		/**********************************************
		 *  JAGS Server Events and Your Own Commands
		 *********************************************/	
		public function registerCommands():void {
			// Some built in server events.  There are more.
			gameServer.addEventListener(NetworkConnection.AddPlayerEvent, onAddPlayer);
			gameServer.addEventListener(NetworkConnection.RemovePlayer, onRemovePlayer);
			gameServer.addEventListener(NetworkConnection.GroupNameReceivedEvent, onGroupName);
			gameServer.addEventListener(NetworkConnection.StartGameEvent, onStartGame);
			

			// Your Player Commands
			gameServer.addEventListener("your_game_command_1", onCommand1);
			gameServer.addEventListener("successful_login", onSuccessfulLogin);
			gameServer.addEventListener("language_chosen", onLanguageChosen);			
			gameServer.addEventListener("wrong_username", onWrongUsername);
			gameServer.addEventListener("wrong_password", onWrongPassword);
		}
		
		// This happens when our physical socket connection warms up 100%.
		public function onIDReceived(e:Event):void {
			trace("GameServer: Connection IDReceived"+ gameServer.id);
			// You may want to let others know you've joined the server.

			// Or you mayt want to save that notification for when you have logged in
			// through whatever security you put in your game itself on the server side.
			
			// In this case, we will tell the server to automatically pair us up with
			// a 2 person game.
			gameServer.autoJoin(2);
		}
		
		public function onGroupName(e:Event):void {			
		}
		
		public function onStartGame(e:Event):void {	
		}
		
		public function onAddPlayer(e:Event):void {	
		}
		
		public function onRemovePlayer(e:Event):void {
		}
		
		/**********************************************
		 * LOGIN FUNCTIONS - or any function you want
		 *********************************************/		
		public function onSuccessfulLogin(text:GameTextEvent):void {
			loggedIn = true;
		}

		public function onLanguageChosen(text:GameTextEvent):void {
			// parse out the language chosen response from server...
		}
		
		public function onWrongUsername(text:GameTextEvent):void {
		}
		
		public function onWrongPassword(text:GameTextEvent):void {	
		}
		
		// example of receiving arbitrarily named commands
		public function onCommand1(text:GameTextEvent):void {
			// Example of simple String commands
			trace("From: "+ text.from +" size ="+ text.data.length);
			trace("Message: "+ text.data);
		}		
	}
}