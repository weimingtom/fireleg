package jags.multigame 
{
	public final class Config
	{
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
		public static var uniqueGameName:String = "public_ftp.tankape_demo.v1_0";

		// Choose fireleg if you aren't running your own JAGS server		
		//public static var URL:String = "fireleg.com";
		public static var URL:String = "localhost";
		public static var port:uint = 82;		
		
		public static var framesPerSecond:int = 24;
		// Zero means we synchronize the world every frame.
		// 1,2,3 means we count 1,2,3 frames before synching.
		// This keeps your world looking smooth while the network
		// can chill out a little bit.
		public static var dampenNetSyncBy:int = 96;
		
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