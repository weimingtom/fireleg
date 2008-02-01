package {
	
	import org.cove.ape.*;
	
	import flash.display.Stage;
	import flash.display.Sprite;
	
    import flash.utils.Timer;
    import flash.events.TimerEvent;		
	import flash.events.Event;

	import flash.events.KeyboardEvent;
	import tanks.TankOne;
	
	// multiplayer stuff
	import jags.multigame.*;
	import flash.net.registerClassAlias;
	import org.cove.ape.JAGS.JAGSComposite;
	import org.cove.ape.JAGS.JAGSGroup;
		
	[SWF(width="800", height="400", backgroundColor="#000000")] 
	public class RobotDemo extends Sprite {
			
		// links all these classes to your swf
		private static var registerAPE:RegisterAPE = new RegisterAPE();
		
		private static var halfStageWidth:int = 400;
		private static var halfStageHeight:int = 200;
		//private var robot:Robot;
		private var robot:TankOne;
		private var robot2:Robot;
		private var robot2b64:String; // Base 64 byte representation of the robot
		private	var back:GameBackground;
		
		public static var gravity:Number = 10;
		public static var helium:Number = -1 * gravity * 1;
		public static var footGravity:Number = gravity * 1;
		public static var robotPower:Number = .05;
		public static var maxVelocity:Number = 100;
		
		public static var damping:Number = .75;
		private var zoom:Number = 1; // 1 = 100%	

		private var gameTimer:Timer;
		private var framesPerSecond:Number = 30;
		private var refreshMillis:uint = 1000/framesPerSecond;

		private var gameServer:NetworkConnection;
		
		var hello:String = "Hello\n byte encoder.\u0000";
		
		public function RobotDemo() {
			registerClassAlias("tanks.TankOne", TankOne);
			registerClassAlias("Robot", Robot);
			
			stage.frameRate = framesPerSecond;
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);

			setupAPE(this);					
			back = new GameBackground();	
			
			//robot2 = new Robot(1250, 260, 1.6, 0.02);		
			robot2 = new Robot(1000, 260, 1.6, robotPower);
			robot2b64 = AMFBase64.outComplete(robot2, false);
			var robotObjb64:* = AMFBase64.incomingComplete(robot2b64) as Robot;
			//trace("robotObjb64 Name = "+ robotObjb64.name);
						
			var jagComp:JAGSComposite = new JAGSComposite("foofer");
//			jagComp.name = "myjag64";
			var jagB64:String = AMFBase64.outComplete(jagComp, false);
			var jagObj64:JAGSComposite = AMFBase64.incomingComplete(jagB64, false) as JAGSComposite;
			trace("JAGComp64 Name = "+ jagObj64.name);

			jagComp.name = "myjagAMF";
			var jagAMF:String = AMFBase64.outAMF(jagComp);
			var jagObjAMF:* = AMFBase64.incomingAMF(jagAMF);
			trace("JAGCompAMF Name = "+ jagObjAMF.name);
			
			//robot = new TankOne();
			
//			APEngine.addGroup(robot);
	//		robot.addCollidable(back.terrainA);
		//	robot.addCollidable(back.terrainB);
			//robot.addCollidable(back.terrainC);
			//robot.togglePower();						
			
			/***************************************************************
			 * Make the game multiplayer by using a JAGS NetworkConnection.
			 ***************************************************************/
			setupJAGS();			
		}
		
		public function setupJAGS():void {			
			// --You-- create the function onIDReceived (see example below).
			// It is how you know when the server connection is ready.
			gameServer = new NetworkConnection(Config.URL, Config.port, onIDReceived);

			// This is how you will hear your own game commands.
			gameServer.addEventListener("my_command", onPlainText);
			gameServer.connect();			
		}
								
		// This event let's us know the server is ready for our game.
		public function onIDReceived(e:Event):void {
			trace("GameServer: Connection IDReceived"+ gameServer.id);

			// All the messages will be sent to everyone on this type of game.
			//
			// If we wanted a private instance of a game between just a couple
			// of players, then we would need to use groups or autojoin functions.
			//
			// For now, let's stick to the simplest example - one big group for
			// the whole game.
			
			// Let's start the game loop as soon as we have an ID.
			gameTimer = new Timer(refreshMillis, 0);			
			gameTimer.addEventListener(TimerEvent.TIMER, run);
			gameTimer.start();
			
			// sayAll will send you this message.
			// sayOthers will skip you, but send to everyone else.
			// Notice how the "my_command" matches our event listener in setupJAGS
			//gameServer.sayAll("my_command", "my text");
			
			// TODO: Try sending an object as xml and reconstituting it.
			
			// TODO: Try sending an object as AMF Base 64 Compressed and back.			
			var amf:AMFBase64 = new AMFBase64();
			
//			var b64Robot:String = AMFBase64.outComplete(robot, false);
			//var b64Robot:String = AMFBase64.outAMF(robot, false);
			//gameServer.sayAll("my_command", b64Robot);

			var aTank:TankOne = new TankOne();
		//	trace("Wheel radius "+ aTank.wheelL.radius3);
			var b64Tank:String = AMFBase64.outComplete(aTank, false);
			//var obj64Tank:TankOne = AMFBase64.incomingComplete(b64Tank, false);// as TankOne;
			//trace("Ojb64Tank car name = "+ obj64Tank.car.name);
//			trace("Ojb64Tank wheel = "+ obj64Tank.wheelL.radius3);	
			gameServer.sayAll("my_command", b64Tank);
			//gameServer.sayAll("my_command", robot2b64);
		}

		// Notice how this function matches the event listener in setupJAGS.
		// This is where you can receive all your commands,
		// and commands from all players in your game.		
		public function onPlainText(text:GameTextEvent):void {
			trace("GameText from "+ text.from +" size ="+ text.data.length +" data ="+ text.data);
			var robot:* = AMFBase64.incomingComplete(text.data, false);
			
			APEngine.addGroup(robot);
			robot.addCollidable(back.terrainA);
			robot.addCollidable(back.terrainB);
			robot.addCollidable(back.terrainC);			
			
			
			//var hello_decodedAMF:String = AMFBase64.incomingAMF(text.data);
			//var hello_decodedAMF:String = AMFBase64.incomingComplete(text.data, false);
			//trace("hello from AMF == "+ hello_decodedAMF);
			
//			var myRobot:TankOne = AMFBase64.incomingComplete(text.data, false) as TankOne;
			//var myRobot:TankOne = AMFBase64.incomingAMF(text.data, false) as TankOne;
			//trace("Name: "+ myRobot.car.name);
		}

			
		private function run(evt:Event):void {		
			APEngine.step();
			//robot.run();
			
			APEngine.paint();

			// Stay centered, even if we've zoomed in / out.
			//APEngine.container.x = -robot.wheelL.px * zoom + halfStageWidth;
			//APEngine.container.y = -robot.wheelL.py * zoom + halfStageHeight;		
		}
		
		private function setupAPE(robotD:RobotDemo):void {	
			APEngine.init(1/4);
			APEngine.container = robotD;
			APEngine.container.scaleX = zoom;
			APEngine.container.scaleY = zoom;
			
			APEngine.addForce(new VectorForce(false, 0, gravity));
			
			APEngine.damping = damping;
			APEngine.constraintCollisionCycles = 10;
		}
		
		private function keyHandler(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 80: // p
					//robot.togglePower();
					//robot2.togglePower();
					break;
				case 82: // r
				//	robot.toggleDirection();
					//robot2.toggleDirection();
					break;
				case 72: // h
				//	robot.toggleLegs();
					//robot2.toggleLegs();
					break;
				case 73: // i
					//robot2.placeAbsolute(1250, 200);
				//	robot.placeAbsolute(1000, 225);
					break;					
				case 32: // space = reset robot 
				//	robot.placeRelative(0,-50);
//					robot2.px = 1000;
//					robot2.py = 260;
					break;					
				default:
					break;
			}
		}
	}
}
