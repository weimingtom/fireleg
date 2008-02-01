package
{
	import org.cove.ape.*;
	import flash.display.Sprite;
	
	public class GameBackground
	{
		public var terrainA:Group;
		public var terrainB:Group;
		public var terrainC:Group;
		
		public function GameBackground() {
			this.init();
		}
		
		public function init():void {				
			terrainA = new Group();
			terrainB = new Group(true);
			terrainC = new Group();
			
			var floor:RectangleParticle = new RectangleParticle(600,390,1700,100,0,true,1,0,1);
			floor.setStyle(0,0,0,0x999999);
			terrainA.addParticle(floor);
			
			
			// pyramid of boxes
			var box0:RectangleParticle = new RectangleParticle(600,337,600,7,0,true,10,0,1);
			box0.setStyle(1,0x999999,1,0x336699);
			terrainA.addParticle(box0);
			
			var box1:RectangleParticle = new RectangleParticle(600,330,500,7,0,true,10,0,1);
			box1.setStyle(1,0x999999,1,0x336699);
			terrainA.addParticle(box1);
			
			var box2:RectangleParticle = new RectangleParticle(600,323,400,7,0,true,10,0,1);
			box2.setStyle(1,0x999999,1,0x336699);
			terrainA.addParticle(box2);
			
			var box3:RectangleParticle = new RectangleParticle(600,316,300,7,0,true,10,0,1);
			box3.setStyle(1,0x999999,1,0x336699);
			terrainA.addParticle(box3);
			
			var box4:RectangleParticle = new RectangleParticle(600,309,200,7,0,true,10,0,1);
			box4.setStyle(1,0x999999,1,0x336699);
			terrainA.addParticle(box4);
				
			var box5:RectangleParticle = new RectangleParticle(600,302,100,7,0,true,10,0,1);
			box5.setStyle(1,0x999999,1,0x336699);
			terrainA.addParticle(box5);
			
			
			// left side floor
			var floor2:RectangleParticle = new RectangleParticle(-100,390,1100,100,0.3,true,1,0,1);
			floor2.setStyle(0,0,0,0x999999);
			terrainB.addParticle(floor2);
			
			var floor3:RectangleParticle = new RectangleParticle(-959,232,700,100,0,true,1,0,1);
			floor3.setStyle(0,0,0,0x999999);
			terrainB.addParticle(floor3);
			
			var box6:RectangleParticle = new RectangleParticle(-990,12,50,25,0);
			box6.setStyle(1,0x999999,1,0x336699);
			terrainB.addParticle(box6);
			
			var floor5:RectangleParticle = new RectangleParticle(-1284,170,50,100,0,true);
			floor5.setStyle(0,0,0,0x999999);
			terrainB.addParticle(floor5);
			
			
			// right side floor
			var floor6:RectangleParticle = new RectangleParticle(1430,320,50,60,0,true);
			floor6.setStyle(0,0,0,0x999999);
			terrainC.addParticle(floor6);
			

			APEngine.addGroup(terrainA);
			APEngine.addGroup(terrainB);
			APEngine.addGroup(terrainC);
			
		}
	}
}