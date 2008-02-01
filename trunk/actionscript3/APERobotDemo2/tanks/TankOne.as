package tanks
{
	import org.cove.ape.JAGS.*;
	import org.cove.ape.WheelParticle;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.Composite;
	import org.cove.ape.SpringConstraint;
	
	public class TankOne extends org.cove.ape.JAGS.JAGSGroup
	{
		public var wheelL:WheelParticle;
		public var wheelR:WheelParticle;
		//public var frame:RectangleParticle;
		public var car:org.cove.ape.JAGS.JAGSComposite;
		
		public function TankOne() {
			var wx:Number = 100;
			var wy:Number = 25;
			//frame = new RectangleParticle(0,275,wx,wy,0);
			wheelL = new WheelParticle(0,275, wy);
			wheelR = new WheelParticle(wx,275,wy);
			
			car = new JAGSComposite();
			car.name = "car";
			//car.addParticle(frame);
			car.addParticle(wheelL);
			car.addParticle(wheelR);
			
			wheelL.angularVelocity = 3.6;
			wheelR.angularVelocity = 3.6;
			wheelL.friction = 1;
			wheelR.friction = 1;
					
			//var cL:SpringConstraint = new SpringConstraint(wheelL, frame, 1);
			//var cR:SpringConstraint = new SpringConstraint(wheelR, frame, 1);					
					
			this.addComposite(car);
			//this.addConstraint(cL);
			//this.addConstraint(cR);
		}
	}
}