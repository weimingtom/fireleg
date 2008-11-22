package jags.multigame 
{
	// This class borrowed from Senocular.com
	// http://www.senocular.com/flash/actionscript.php?file=ActionScript_3.0/com/senocular/utils/KeyObject.as
	// 
	// The class name was changed only to better remind me of its purpose.
		
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * The MultiKeyPress class recreates functionality of
	 * Key.isDown of ActionScript 1 and 2
	 *
	 * Usage:
	 * var key:MultiKeyPress = new MultiKeyPress(stage);
	 * if (key.isDown(key.LEFT)) { ... }
	 */
	dynamic public class MultiKeyPress extends Proxy {
		
		private static var stage:Object;
		private static var keysDown:Object;
		
		public function MultiKeyPress(stage:Object) {
			construct(stage);
		}
		
		public function construct(stage:Object):void {
			MultiKeyPress.stage = stage;
			keysDown = new Object();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		flash_proxy override function getProperty(name:*):* {
			return (name in Keyboard) ? Keyboard[name] : -1;
		}
		
		public function isDown(keyCode:uint):Boolean {
			return Boolean(keyCode in keysDown);
		}
		
		public function deconstruct():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			keysDown = new Object();
			MultiKeyPress.stage = null;
		}
		
		public function keyPressed(evt:KeyboardEvent):void {
			keysDown[evt.keyCode] = true;
			trace("key DOWN "+ evt.keyCode);
		}
		
		public function keyReleased(evt:KeyboardEvent):void {
			delete keysDown[evt.keyCode];
			trace("key UP "+ evt.keyCode);			
		}
	}
}