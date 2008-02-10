package jags.multigame
{
	import flash.events.Event;

	public class CommandEvent extends Event
	{
		public static const PLACE_IT:String = "place";
		public static const CREATE_IT:String = "create";

		public var x:uint;
		public var y:uint;
		private var name:String;
		private var typeOf:String	
		private var	timeStamp:Number = -1;
		private var from:String = "";
		
		// Create particle type with x,y coords
		public function MessageEvent(command:String, typeOf:String, name:String, x:uint, y:uint, timeStamp:Number) {
			super(command, false, false);
			
			x = x;
			y = y;
			timeStamp = timeStamp;
			name = name;
			typeOf = typeOf;
		}

		
	}
}