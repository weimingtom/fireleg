package jags.multigame 
{
	import org.cove.ape.*;
		
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import jags.multigame.MessageEvent;
	
    // Written by Travis Somerville
	
	/**********************************************************************
	 * ADD: "COMMANDS TO RECEIVE" and "COMMANDS TO SEND" in the 
	 * functions below as your game needs. 
	 *********************************************************************/
	// 
	public class Commands extends EventDispatcher implements IDataHandler
	{
		public const TYPE_CIRCLE:String 	= "1";
		public const TYPE_PADDLE:String 	= "2";
		public const TYPE_BOUNDARY:String	= "3";
		
		public var x:uint = 75;
		public var y:uint = 100;
		private var data:Array;
		private var name:String;
		private var type:String	
		private var	timeStamp:Number = -1;
		private var from:String = "";	
		
		private var e:MessageEvent;
		
		/*******************************************
		 * COMMANDS TO RECEIVE
		 ******************************************/
		public function parseCommand(incoming:String):Boolean {
			// -------------------------------------
			//  My chosen format is as follows:
			//  11119945553>conn_5c>group4_g>create:circle1:1:60,60
			//  Basically: timestamp > from > to > action
			// -------------------------------------
			try {				
				// EXTRACT Time>From>Command headers (time is optional)			
				var fromHeader:Array = incoming.split(NetworkConnection.HEADER_DELIMITER);
				var command:Array;			
				if (Config.useTimestamps == true) {
					command = fromHeader[2].split(NetworkConnection.DELIMITER);
					timeStamp = fromHeader[0];
					from = fromHeader[1];
				}
				else {
					command = fromHeader[1].split(NetworkConnection.DELIMITER);
					from = fromHeader[0];				
				}
					
				trace("IN: "+ incoming);
				
				if (command != null && command.length > 1) {
					if (command[0] == "place") {
						name = command[1];
						data = String(command[2]).split(",");
						x = data[0];
						y = data[1];
						trace("place "+ x+","+y);

						//e = new CommandEvent(CommandEvent.PLACE_IT, "particle", name, x, y, timeStamp);						
						//dispatchEvent(e);
						//world.place(name, x,y, timeStamp);					
					}
					if (command[0] == "create") {		
						type = command[2];
						name = command[1];			
						data = String(command[3]).split(",");
						x = data[0];
						y = data[1];
						
						trace("create "+ type +" "+ x+","+y);
						//e = new CommandEvent(CommandEvent.CREATE_IT, type, name, x, y, timeStamp);
						//dispatchEvent(e);
					}				
					return true;
				}
				else return false;
			}
			catch (e:Error) {
				trace("COMMAND ERROR: *** "+ incoming);
			}
			return false;			
		}
		
		/***********************************************************
		 * COMMANDS TO SEND
		 * 
		 * These helper functions create the string message
		 * to be sent to the game server.
		 * 
		 * They are the same strings you parse above.
		 * ********************************************************/
		public function create(name:String, type:String, x:int, y:int):String {
			return "create:"+name+":"+type+":"+x+","+y;
		}
		
		public function place(name:String, x:int, y:int):String {
			return "place:"+name+":"+x+","+y;
		}
	}
}