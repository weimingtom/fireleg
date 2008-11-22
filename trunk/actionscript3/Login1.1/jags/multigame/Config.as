package jags.multigame 
{
	public final class Config
	{
		// Choose fireleg if you aren't running your own JAGS server		
		//public static var URL:String = "fireleg.com";
		public static var URL:String = "localhost";
		public static var port:uint = 81;		
		
		public static var framesPerSecond:int = 2;
		// Zero means we synchronize the world every frame.
		// 1,2,3 means we count 1,2,3 frames before synching.
		// This keeps your world looking smooth while the network
		// can chill out a little bit.
		public static var dampenNetSyncBy:int = 4;
		
		// Set to true to allow other functions related to time
		// Set to false if you don't want that extra info taking up header space.
		public static var useTimestamps:Boolean = true;
		
		// Set to true to reject particle messages that arrive late.
		// Set to false if every single particle message is critical.
		public static var rejectLateParticleData:Boolean = true;
		
		// Meta delimiter used in messaging
		public static var systemBang:String = "!";
	}
}