package {
	
	// physics
	import org.cove.ape.*;
	import tanks.TankOne;  // you can get more creative here for your game...
	
	import flash.display.Stage;
	import flash.display.Sprite;
	
    import flash.utils.Timer;
    import flash.events.TimerEvent;		
	import flash.events.Event;

	import flash.events.KeyboardEvent;
		
	// multiplayer stuff
	import jags.multigame.*;
	import flash.net.registerClassAlias;
	import org.cove.ape.JAGS.JAGSComposite;
	import org.cove.ape.JAGS.JAGSGroup;
	import mx.messaging.config.ServerConfig;
	import flash.utils.Dictionary;
	import flash.profiler.showRedrawRegions;
	import tanks.tankPosition;
		
	[SWF(width="1200", height="400", backgroundColor="#000000")] 
	public class TankAPE_Demo extends Sprite {
		/*************************************************************
		 * 				MXML DISPLAY STUFF
		 *************************************************************/
		public var display:Sprite;
		public var myStage:Stage;
		
		// keeps track of keyboard input up/down
		public 	var keyboard:MultiKeyPress;	
		
		// enemy position
		[Bindable] public var positionX:int;			
		[Bindable] public var positionY:int;

		// your position
		[Bindable] public var myX:int;
		[Bindable] public var myY:int;

		/*************************************************************
		 * 				MULTI-PLAYER STUFF
		 *************************************************************/					
		// Important: must have - links all these classes to your swf
		private static var registerAPE:RegisterAPE = new RegisterAPE();
		private static var registerTank:RegisterTank = new RegisterTank();
		
		[Bindable] public var gameServer:NetworkConnection;
		public var gameStarted:Boolean = false;

		public var myTank:TankOne;		
		public var aTank:TankOne;
		public var deserializedTank:TankOne;
		public var otherTanks:Dictionary = new Dictionary(true);
		
		/*************************************************************
		 * 				APE PHYSICS STUFF
		 *************************************************************/
		private static var halfStageWidth:int = 400;
		private static var halfStageHeight:int = 200;
		private var back:GameBackground;
		
		public static var gravity:Number = 10;
		public static var helium:Number = -1 * gravity * 1;
		public static var footGravity:Number = gravity * 1;
		public static var robotPower:Number = .02;
		public static var maxVelocity:Number = 100;
		
		public static var damping:Number = .75;
		private var zoom:Number = .2; // 1 = 100%, .5 = 50% (objects are further away, more view)

		private var gameTimer:Timer;
		private var framesPerSecond:Number = 30;
		private var refreshMillis:uint = 1000/framesPerSecond;
		
		
		public function TankAPE_Demo(frameRate:int, display:Sprite) {		
			this.display = display;
			myStage = display.stage;
			keyboard = new MultiKeyPress(display.stage);
			myStage.addChild(this);
												
			myStage.frameRate = frameRate;
			myStage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);

			setupAPE(this);
			back = new GameBackground();		
			
			startGameLoop();
											
			/***************************************************************
			 * Make the game multiplayer by using a JAGS NetworkConnection.
			 ***************************************************************/
			setupJAGS();			
		}

		/*************************************************************
		 *				THIS IS YOUR GAME LOOP
		 *************************************************************/	
		internal var syncCounter:int = 0;
		private function run(evt:Event):void {		
			APEngine.step();
			APEngine.paint();
			
			centerViewOnGroup(myTank);
			if (myTank != null) {			
				var location:Vector = myTank.getRelativeBearing(0,0);
				myX = location.x;
				myY = location.y;
			}
			
			if (gameServer.receivedId) {
				// update my tank position for others, every x frames
				syncCounter = syncCounter + 1;
				if (syncCounter >= 24) {
					sendUpdateTank();
					syncCounter = 0;
				}
			}
			
		}
	
		public function sendUpdateTank():void {
//			var b64Tank:String = AMFBase64.outComplete(myTank, false);
			var position:tankPosition = myTank.getPosition();
			var serializedPosition:String = AMFBase64.outComplete(position, false);
			//gameServer.sayOthers("update_tank", b64Tank);
			gameServer.sayOthers("update_tank", serializedPosition);
		}

		public function onUpdateTank(text:GameTextEvent):void {
			trace("Incoming Tank Position "+ text.from +" size ="+ text.data.length);
			//deserializedTank = AMFBase64.incomingComplete(text.data, false);
			//deserializedTank.create();
			var position:tankPosition = AMFBase64.incomingComplete(text.data, false) as tankPosition;

			// create tank if not yet in existance, or just update if we have it			
			var lookup:TankOne = getByName(position.name, otherTanks);
			if (lookup != null) {
				lookup.setPosition(position);
			}
			else {
				var newTank:TankOne = new TankOne();
				newTank.create();
				newTank.name = position.name;
				newTank.setPosition(position);
				
				newTank.ownedByMe = false;
				newTank.frame.fillColor = 0x220000;
				addAPEGroup(newTank);
				otherTanks[newTank.name] = newTank;
			}
		}		

		public function createMyTank(name:String):TankOne {
			aTank = new TankOne();
			aTank.name = name;
			aTank.create();	
			aTank.ownedByMe = true;
			addAPEGroup(aTank);
			
			return aTank;
		}
				
		public function setupJAGS():void {
			gameServer = new NetworkConnection(Config.URL, Config.port, onIDReceived);

			// This is how you will hear your own game commands.
			gameServer.addEventListener("update_tank", onUpdateTank);
			gameServer.connect();			
		}
								
		// This event let's us know the server is ready for our game.
		public function onIDReceived(e:Event):void {
			trace("GameServer: Connection IDReceived"+ gameServer.id);
			myTank = createMyTank(gameServer.id +"_tank");
			sendUpdateTank();
		}
			
		public function addAPEGroup(obj:*):void {
			APEngine.addGroup(obj);		
			obj.addCollidable(back.terrainA);
			obj.addCollidable(back.terrainB);
			obj.addCollidable(back.terrainC);				
		}

		public function startGameLoop():void {
			if (!gameStarted) {								
				gameTimer = new Timer(refreshMillis, 0);			
				gameTimer.addEventListener(TimerEvent.TIMER, run);
				gameTimer.start();
				gameStarted = true;					
			}			
		}
		
		// Stay centered, even if we've zoomed in / out.
		public function centerViewOnGroup(r:JAGSGroup):void {
			//APEngine.container.x = -robot.sprite.x * zoom + halfStageWidth;
			if (r != null) {
				APEngine.container.x = r.getRelativeBearing(0,0).x * -1 * zoom + halfStageWidth;
				APEngine.container.y = r.getRelativeBearing(0,0).y * -1 * zoom + halfStageHeight;		
			}			
		}
		
		public function centerViewOnXY(x:int, y:int):void {
				APEngine.container.x = x * zoom + halfStageWidth;
				APEngine.container.y = y * zoom + halfStageHeight;
		}
		
		private function setupAPE(ourDisplay:Sprite):void {	
			APEngine.init(1/4);
			APEngine.container = ourDisplay;
			APEngine.container.scaleX = zoom;
			APEngine.container.scaleY = zoom;
			
			APEngine.addForce(new VectorForce(false, 0, gravity));
			
			APEngine.damping = damping;
			APEngine.constraintCollisionCycles = 10;
			
			APEngine.container.x = 0;
			APEngine.container.y = 0;			
		}
		
		private function keyHandler(evt:KeyboardEvent):void {
			trace("Key press "+ evt.keyCode);
			switch (evt.keyCode) {
				case 80: // p
					myTank.wheelL.angularVelocity = myTank.wheelL.angularVelocity * -1;
					myTank.wheelR.angularVelocity = myTank.wheelR.angularVelocity * -1;
					break;
				case 82: // r
					//robotObjb64.toggleDirection();
					myTank.placeRelative(25,0);
					break;
				case 84: // t
					//robotObjb64.toggleLegs();
					myTank.placeRelative(-25,0);
					break;
				case 73: // i
					myTank.placeRelative(0,25);
					//robotObjb64.placeAbsolute(1000, 225);
					break;					
				case 32:
					sendUpdateTank();
					break;	
				
				// Allows you to see different areas, move syour perspective around.
			/*	case 98:
					APEngine.container.y = APEngine.container.y - 100;				
					break;
				case 100:
					APEngine.container.x = APEngine.container.x + 100;
					break;
				case 102:
					APEngine.container.x = APEngine.container.x - 100;					
					break;
				case 104:	
					APEngine.container.y = APEngine.container.y + 100;
					break;							
					*/
				default:
					break;
			}
			
			sendUpdateTank();
		}
		
		// Dictionary utility function for ones that reference by String
		public function getByName(name:String, dict:Dictionary):* {
			for (var key:String in dict) {
				if (key.valueOf() == name.valueOf()) return dict[key];
 			}
 			
 			return null;
		}		
	}	
}
