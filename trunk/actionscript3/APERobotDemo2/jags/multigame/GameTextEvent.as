package jags.multigame
{
	import flash.events.Event;

	public class GameTextEvent extends Event
	{
		public var typeOf:String	
		public var timeStamp:Number = -1;
		public var from:String = "";
		public var data:String;
		
		// Create particle type with x,y coords
		public function GameTextEvent(
				typeOf:String,
				timeStamp:Number, 
				from:String, 
				data:String) {
					
			super(typeOf, false, false);
			
			this.typeOf = typeOf;
			this.timeStamp = timeStamp;
			this.from = from;
			this.data = data;
		}
	}
}
