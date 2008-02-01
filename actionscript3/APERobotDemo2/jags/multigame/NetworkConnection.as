package jags.multigame 
{
    // Written by Travis Somerville	

	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
//	import mx.controls.TextArea;
//	import mx.utils.StringUtil;
	import flash.system.Security;	
	
	public class NetworkConnection extends EventDispatcher {		
		/****************************************
		 * USAGE: Set to true for games that 
		 * do not use any network at all.
		 ***************************************/
		public var BypassNetwork:Boolean = false;
		 
		/**************************************************
		 * These events are sent to anyone listening.
		 * They are the important actions from the server.
		 **************************************************/
		public static var StartGameEvent:String 		= "!start_game";
		public static var JoinedHostEvent:String 		= "!joined_host";
		public static var GroupNameReceivedEvent:String = "!name_group";
		public static var IDReceivedEvent:String 		= "!your_id";
		public static var YouHostEvent:String 			= "!you_host";
		public static var AddPlayerEvent:String 		= "!add_player";
		public static var GameCommandEvent:String 		= "!game_command";
		public static var SocketOpenEvent:String 		= "!connected";
		public static var DisconnectedEvent:String 		= "!disconnected";	
		public static var WarmedUpEvent:String			= "!warmed_up";
		
		/*****************************************************
		 * These are the various destinations for a message
		 ****************************************************/
		public static var TELL_ALL:String 		= "!ALL";
		public static var TELL_OTHERS:String 	= "!Others";
		public static var TELL_SERVER:String	= "!Server";
		public static var TELL_GROUP:String	= "!Group";
		
		/*****************************************************
		 * These are the various formats for the data
		 ****************************************************/
		public static var FORMAT_TEXT:String 	= "text";
		public static var FORMAT_XML4:String 	= "xml4";
		public static var FORMAT_AMF3:String 	= "amf3";
		public static var FORMAT_BASE64:String = "Bx64";
		
		private var e:Event;
		 
		private var socket:Socket;
		public 	var connected:Boolean = false;
		public	var msgCount: uint = 0;		
		
		public	var receivedId:Boolean = false;  
		public	var id:String = "no_id"+ Math.random();
		public	var groupName:String = "!ALL";
		public 	var isHost:Boolean = false;
		public	var hostConnID:String = "";
		public	var numberOfPlayers:int = 1;
		public	var connectedToHost:Boolean = false;
		public	var gameStarted:Boolean = false;
		 
		public static var DELIMITER:String = ":";
		public static var HEADER_DELIMITER:String = ">";
		private var word:String;
		
		private var URL:String;
		public 	var port:uint;
		
		public var lastMessageIn:String;  // from Server
		public var lastMessageOut:String;  // To Server		
		
		public function NetworkConnection(URL:String, port:uint, IDCallback:Function) {
			this.URL = URL;
			this.port = port;
			
			if (!BypassNetwork) {
				socket = new Socket();
				socket.addEventListener(Event.CONNECT, onConnect);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				socket.addEventListener(Event.CLOSE, onClose);					  
				this.addEventListener(IDReceivedEvent, IDCallback);				
			}							
			
		}
			
		/****************************************************
		 * Sends game commands that are specific to hosting
		 * and joining games.
		 ***************************************************/
		 public function getID():void {
		 	sayServer("!whats_my_name", "");	
		 }	
		 
		 public function autoJoin(numberOfPlayers:int):void {
			 sayServer("!auto_match"+ DELIMITER + numberOfPlayers, "");
		 }
		  
		 public function startGame(numberOfPlayers:int):void {
			 sayServer("!start_game"+ DELIMITER + numberOfPlayers, "");
		 }
		  				
		/****************************************************
		 * Listens to game server and passes game commands
		 * to data listener.
		 ***************************************************/	
		public function onSocketData(event:ProgressEvent):String {
			var valid:Boolean;
			var length:int;	
			
			lastMessageIn = socket.readUTFBytes(socket.bytesAvailable);
			trace("IN: "+ lastMessageIn);
			
			// -----------------------------------------
			// Split data into single commands
			// -----------------------------------------
			var lines:Array = lastMessageIn.split("\n");
			for(var oneCommand:String in lines) {
				word = lines[oneCommand].toString();
				length = word.length;
				if (word != "" && word != "\n") {
					msgCount++;
					
					// First message means server connection is really ready.
					if (msgCount == 1) {	
						e = new Event(WarmedUpEvent);
						dispatchEvent(e);
					}
					
					connected = true;
					word = word.replace("\r", "");
					
					// -----------------------------------------
					// Core protocol, not game commands
					// -----------------------------------------
					var parts:Array;
					if (word.indexOf("!ru_alive") > -1) {
						// send a response back to server to prove we are here
						sayServer("!iam_alive", "");
					}
					else if (word.indexOf("!what_is_your_game") > -1) {
						sayServer("!set_my_game" + DELIMITER + Config.uniqueGameName, "");
					}
					else if (word.indexOf(GroupNameReceivedEvent) > -1) {
						parts = word.split(DELIMITER);
						groupName = parts[1];
						e = new Event(GroupNameReceivedEvent, false, false);
						dispatchEvent(e);						
					}
					else if (word.indexOf(IDReceivedEvent) > -1) {
						parts = word.split(DELIMITER);
						this.id = parts[1];
						receivedId = true;
						e = new Event(IDReceivedEvent, false, false);
						dispatchEvent(e);	
					}
					else if (word.indexOf(YouHostEvent) > -1) {
						parts = word.split(DELIMITER);
						isHost = true;
						connectedToHost = true;
						hostConnID = parts[1];
						e = new Event(YouHostEvent, false, false);
						dispatchEvent(e);						
					}
					else if (word.indexOf(AddPlayerEvent) > -1) {
						numberOfPlayers ++;
						e = new Event(AddPlayerEvent, false, false);
						dispatchEvent(e);					
					}						
					else if (word.indexOf(JoinedHostEvent) > -1) {
						parts = word.split(DELIMITER);
						hostConnID = parts[1];
						connectedToHost = true;
						e = new Event(JoinedHostEvent, false, false);
						dispatchEvent(e);						
					}	
					else if (word.indexOf(StartGameEvent) > -1) {
						//parts = word.split(DELIMITER);
						//numberOfPlayers = parts[1];
						gameStarted = true;	
						e = new Event(StartGameEvent, false, false);
						dispatchEvent(e);
					}
					else if (word.indexOf("<cross-domain-policy>") > -1) {
						trace("Your sandbox is trusted and you can ignore this: "+ word);
					}
					else {							
						announceGameEvent(word);			
					}		
				}					
			}
			
			return lastMessageIn;
		}
		
		// Sends this message to your Actionscript game client
		// if you added listeners for the command.
		public function announceGameEvent(gameData:String):void {

			// --------------------------------------------
			// Notify the any listeners of the message.
			// In other words, your game gets the message.
			// --------------------------------------------											
			var data:String;
			var name:String;
			var type:String	
			var	timeStamp:Number = -1;
			var from:String = "";							
			var command:String;			
			var format:String;
			
			// EXTRACT Time>From>Format(text|XML4|AMF3|Bx64)>Command>Data (timeStamp is optional)
			var messageHeader:Array = gameData.split(NetworkConnection.HEADER_DELIMITER);
			
			if (Config.useTimestamps == true) timeStamp = messageHeader.shift();

			from = messageHeader.shift() as String;
			format = messageHeader.shift() as String;
			var remainder:String = messageHeader.shift() as String;
			var temp:Array = remainder.split(DELIMITER);
			command = temp.shift();

			if (command != null && command.length > 1) {
				if (format == "text") {
					data = temp.join(NetworkConnection.DELIMITER);
					e = new GameTextEvent(command, timeStamp, from, data);
					dispatchEvent(e);
				}							
			}			
		}

		/***********************************************
		 * Main function to send messages to server.
		 * time>from>format>to>message
		 **********************************************/
		public function send(who:String, format:String, message:String):void {			
			if (!BypassNetwork) message = who + NetworkConnection.HEADER_DELIMITER + message;

			message = id + NetworkConnection.HEADER_DELIMITER 
					+ format + NetworkConnection.HEADER_DELIMITER + message;
			
			if (Config.useTimestamps == true) {
				var time:Number = new Date().time;
				message = time + NetworkConnection.HEADER_DELIMITER + message;
			}
			
			trace("SENDING ("+ format +") "+ message);
			lastMessageOut = message;
			
			// SEND via Internet or Locally
			if (!BypassNetwork) {
				socket.writeUTFBytes(message);
				socket.flush();
			}
			else 
				announceGameEvent(message);
		}
		
		/***************************************************************
		 * Like send() but adds a newline and helps build your message.
		 ***************************************************************/
		public function sayServer(command:String, message:String):void {
			try {
				send(TELL_SERVER, FORMAT_TEXT, command + HEADER_DELIMITER + message +"\n");
			}
			catch (e:Error) {}
		}

		public function sayAll(command:String, message:String):void {
			try {
				send(TELL_ALL, FORMAT_TEXT, command + DELIMITER + message +"\n");
			}
			catch (e:Error) {}
		}
		
		public function sayOthers(command:String, message:String):void {
			try {
				send(TELL_OTHERS, FORMAT_TEXT, command + HEADER_DELIMITER + message +"\n");
			}
			catch (e:Error) {}
		}
		
		public function saySelect(groups:String, command:String, message:String):void {
			try {
				send(groups, FORMAT_TEXT, command + HEADER_DELIMITER + message +"\n");
			}
			catch (e:Error) {}
		}
		
		public function sayMyGroup(command:String, message:String):void {
			try {
				send(groupName, FORMAT_TEXT, command + HEADER_DELIMITER + message +"\n");
			}
			catch (e:Error) {}
		}

		/********************************************
		 * Functions that make a solid connection
		 * with the Game Server.
		 ********************************************/								
		private function onConnect(event:Event ):void {
			trace("The socket is now connected...");
			connected = true;
			e = new Event(SocketOpenEvent, false, false);
			dispatchEvent(e);
			
			sayServer("Ping", "");	
			this.addEventListener(WarmedUpEvent, onWarmedUpHandler);												
		}
		
		public function onWarmedUpHandler(event:Event):void {
			// game client should listen for IDReceived.
			this.getID();
		}
		
		public function connect():void {
			if (!connected) socket.connect(URL, port);
			socket.flush();
		}
		
		public function onClose(event:Event):void {
			connected = false;
			e = new Event(DisconnectedEvent, false, false);
			dispatchEvent(e);			
		}		
	}
}