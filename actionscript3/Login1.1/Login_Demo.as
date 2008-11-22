package {
	// very useful for games
	import flash.display.Stage;
	import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.events.TimerEvent;		
	import flash.events.Event;
	import flash.events.KeyboardEvent;
		
	// multiplayer stuff
	import jags.multigame.*;
	import flash.net.registerClassAlias;
	import flash.net.NetConnection;
	import flash.events.IOErrorEvent;		

	import flash.utils.Dictionary;
	import flash.profiler.showRedrawRegions;
	import mx.controls.Alert;
	import mx.messaging.config.ServerConfig;
	
	[SWF(width="1200", height="400", backgroundColor="#000000")] 
	public class Login_Demo extends Sprite {
		/*************************************************************
		 * 				MXML DISPLAY STUFF
		 *************************************************************/
		public var display:Sprite;
		public var myStage:Stage;
		
		// keeps track of keyboard input up/down
		public 	var keyboard:MultiKeyPress;	
		
		/*************************************************************
		 * 				MULTI-PLAYER STUFF
		 *************************************************************/	
		[Bindable] public var gameServer:NetworkConnection;
		[Bindable] public var gameCommands:YourCommands;
		public var gameStarted:Boolean = false;
		private var gameTimer:Timer;
		private var framesPerSecond:int;
		private var refreshMillis:Number;
				
		public function Login_Demo(frameRate:int, display:Sprite) {				
			this.display = display;
			myStage = display.stage;
			keyboard = new MultiKeyPress(display.stage);
			myStage.addChild(this);
												
			this.framesPerSecond = frameRate;
			myStage.frameRate = frameRate;
			refreshMillis = 1000/framesPerSecond;

			/***************************************************************
			 * Make the game multiplayer by using a JAGS NetworkConnection.
			 ***************************************************************/
			gameCommands = new YourCommands();
			gameServer = gameCommands.gameServer;
										
			startGameLoop();													
		}

		/*************************************************************
		 *				THIS IS YOUR GAME LOOP
		 *************************************************************/	
		internal var syncCounter:int = 0;
		private function heartbeat(evt:Event):void {
			handleKeyboard();
			
			// SERVER SIDE - happens every x heartbeats.
			// This checks to make sure we have a working game connection.
			if (gameServer.receivedId) {
				syncCounter = syncCounter + 1;
				if (syncCounter >= Config.dampenNetSyncBy) {
					// Do whatever you would like here, such as:
					gameCommands.sendMyUpdate("my heart just beat");

					syncCounter = 0;
				}
			}			
			
			// CLIENT ONLY - happens every heartbeat.
			// If you need to repaint something, and regardless of whether you have
			// a game connection yet, put that code here.
			// such as repaintProgressBar();
		}
		
		public function startGameLoop():void {
			if (!gameStarted) {								
				gameTimer = new Timer(refreshMillis, 0);			
				gameTimer.addEventListener(TimerEvent.TIMER, heartbeat);
				gameTimer.start();
				gameStarted = true;					
			}			
		}				
			
		/******************************
		 *      KEYBOARD RESPONSE
		 ******************************/
		 private function handleKeyboard():void {
			if (keyboard.isDown(keyboard.LEFT)) {
			
			}
			
			if (keyboard.isDown(keyboard.RIGHT)) {
			
			}
			
			if (keyboard.isDown(keyboard.UP)) {	
			
			}
						
			if (keyboard.isDown(keyboard.DOWN)) {
			
			}		
		 }
		
	}

}