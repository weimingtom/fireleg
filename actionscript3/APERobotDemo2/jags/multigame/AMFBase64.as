package jags.multigame
{
	// Credit: code dervied from this thread http://mimswright.com/blog/?p=171#more-171 
	// and Actionscript 3.0 cookbook.
	
	import flash.events.TextEvent;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;

	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
		
	public class AMFBase64
	{
		public function AMFBase64() {
//			registerClassAlias("GameKit.Particle", Particle);	
			//registerClassAlias("Robot", Robot);		
		}
		
		public static function outComplete(obj:*, compress:Boolean = false):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(obj);
			
			if (compress) bytes.compress();
			
			bytes.position = 0;
			var b:Base64Encoder = new Base64Encoder();
			b.encodeBytes(bytes, 0, 0);
			
			// this last line drains the string,
			// then replaces all the newlines with the # symbol
			// which is not used in base64.
			// this avoids the newline termination, which the socket can't handle.
			return b.drain().split("\n").join("#");	
		}
		
		public static function incomingComplete(obj:String, decompress:Boolean = false):*
		{
			var b:Base64Decoder = new Base64Decoder();
			// we need to add the newlines back in for the base64 encoder
			b.decode(obj.split("#").join("\n"));
			var bytes:ByteArray = b.drain();
			
			if (decompress) bytes.uncompress();
			
			bytes.position = 0;			
			var part:* = bytes.readObject();
			
			return part;
		}		
		
		public static function outAMF(obj:*):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(obj);

			//if (compress) bytes.compress();

			// trying my luck to see what happens without using base64
			// over the socket.
			// newlines and nulls are problematic, but let's just see it in action.
			bytes.position = 0;
			
			return bytes.toString().split("\n").join("#~#").split("\u0000").join("!null!");
			//return bytes.toString();
		}
		
		public static function incomingAMF(obj:String):*
		{
			// we need to add the newlines back in.
			obj = obj.split("!null!").join("\u0000").split("#~#").join("\n");
			var bytes:ByteArray = fromString(obj);
		//	var bytes:ByteArray = new ByteArray();
//			bytes.writeObject(obj);
//			bytes.writeUTF(obj);

		//	if (decompress) bytes.uncompress();

			bytes.position = 0;			
			var part:* = bytes.readObject();
			
			return part;
		}		

		public static function fromString(s:String):ByteArray {
			var a:ByteArray = new ByteArray();
			a.length = s.length;
		    for (var i:int = 0; i < s.length; ++i) {
		    	a[i] = s.charCodeAt(i);
		    	if (a[i] == 0) trace("NULL located at "+ i);
		    	//trace(a[i] +" == "+ String.fromCharCode(a[i]));  
		    }
		    
		    return a;
		}		
		
	}
}
