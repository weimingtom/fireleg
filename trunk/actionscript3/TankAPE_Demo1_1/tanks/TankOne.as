package tanks
{
	import org.cove.ape.JAGS.*;
	import org.cove.ape.WheelParticle;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.Composite;
	import org.cove.ape.SpringConstraint;
	import flash.utils.*;
	import org.cove.ape.AbstractParticle;
	
	public class TankOne extends org.cove.ape.JAGS.JAGSGroup implements IExternalizable	
	{
		// this determines if it's our tank or not
		public var ownedByMe:Boolean;
		
		public var wheelL:WheelParticle;
		public var wheelR:WheelParticle;
		public var frame:RectangleParticle;
		public var car:org.cove.ape.JAGS.JAGSComposite;
		public var cL:SpringConstraint;
		public var cR:SpringConstraint;
		
		public function TankOne() {
		}

		public override function writeExternal(output:IDataOutput):void {
			super.writeExternal(output);
			output.writeObject(wheelL);
			output.writeObject(wheelR);
			output.writeObject(frame);
			output.writeObject(car);	
			output.writeObject(cL);
			output.writeObject(cR);
		}
		  
		public override function readExternal(input:IDataInput):void {  
			super.readExternal(input);
			wheelL = input.readObject() as WheelParticle;
			wheelR = input.readObject() as WheelParticle;
			frame = input.readObject() as RectangleParticle;
			car = input.readObject() as org.cove.ape.JAGS.JAGSComposite;
			cL = input.readObject() as SpringConstraint;
			cR = input.readObject() as SpringConstraint;		
		}
				
		public function create():void {
			var wx:Number = 100;
			var wy:Number = 25;
			frame = new RectangleParticle(0,275,wx,wy,0);
			wheelL = new WheelParticle(-wx/2,275, wy);
			wheelR = new WheelParticle(wx/2,275,wy);
			
			car = new JAGSComposite();
			car.name = "car";
			car.addParticle(frame);
			car.addParticle(wheelL);
			car.addParticle(wheelR);
			
			wheelL.angularVelocity = 3.0;
			wheelR.angularVelocity = 3.0;
			wheelL.friction = 1;
			wheelR.friction = 1;
					
			cL = new SpringConstraint(wheelL, frame, 1);
			cR = new SpringConstraint(wheelR, frame, 1);					
					
			this.addComposite(car);
			this.addConstraint(cL);
			this.addConstraint(cR);
		}
		
		public function getPosition():tankPosition {
			var pos:tankPosition = new tankPosition();
			
			pos.name = this.name;
			
			var p:AbstractParticle = car.particles[0];
			pos.centerX = p.px;
			pos.centerY = p.py;
			
			//p = wheelL
			pos.wheelVelocity = wheelL.angularVelocity;
			
			return pos;
		}
		
		public function setPosition(pos:tankPosition):void {
			placeAbsolute(pos.centerX, pos.centerY);
			wheelL.angularVelocity = pos.wheelVelocity;
			wheelR.angularVelocity = pos.wheelVelocity;
		}
	}
}