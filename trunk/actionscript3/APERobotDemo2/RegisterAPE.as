package
{
	
	import flash.net.registerClassAlias;
	import org.cove.ape.*;
	import org.cove.ape.JAGS.*;
	import tanks.*;
	
	public class RegisterAPE
	{	
		public function RegisterAPE() {		
			registerClassAlias("org.cove.ape.WheelParticle", WheelParticle);
			registerClassAlias("org.cove.ape.JAGS.JAGSComposite", JAGSComposite);
			registerClassAlias("org.cove.ape.JAGS.JAGSGroup", JAGSGroup);			
			registerClassAlias("org.cove.ape.RectangleParticle", org.cove.ape.RectangleParticle);
			registerClassAlias("org.cove.ape.AbstractCollection", org.cove.ape.AbstractCollection);
			registerClassAlias("org.cove.ape.AbstractConstraint", org.cove.ape.AbstractConstraint);
			registerClassAlias("org.cove.ape.AbstractItem", org.cove.ape.AbstractItem);
			registerClassAlias("org.cove.ape.AbstractParticle", org.cove.ape.AbstractParticle);
// does not compile			registerClassAlias("org.cove.ape.AngularConstraint", org.cove.ape.AngularConstraint);
			registerClassAlias("org.cove.ape.APEngine", org.cove.ape.APEngine);
			registerClassAlias("org.cove.ape.CircleParticle", org.cove.ape.CircleParticle);
			registerClassAlias("org.cove.ape.Collision", org.cove.ape.Collision);
			registerClassAlias("org.cove.ape.CollisionDetector", org.cove.ape.CollisionDetector);
			registerClassAlias("org.cove.ape.CollisionEvent", org.cove.ape.CollisionEvent);
			registerClassAlias("org.cove.ape.CollisionResolver", org.cove.ape.CollisionResolver);
			registerClassAlias("org.cove.ape.Composite", org.cove.ape.Composite);
			registerClassAlias("org.cove.ape.Group", org.cove.ape.Group);
			registerClassAlias("org.cove.ape.IForce", org.cove.ape.IForce);
			//registerClassAlias("org.cove.ape.Interval", org.cove.ape.Interval);
			//registerClassAlias("org.cove.ape.MathUtil", org.cove.ape.MathUtil);
			registerClassAlias("org.cove.ape.RimParticle", org.cove.ape.RimParticle);
			registerClassAlias("org.cove.ape.SpringConstraint", org.cove.ape.SpringConstraint);
			registerClassAlias("org.cove.ape.SpringConstraintParticle", org.cove.ape.SpringConstraintParticle);
			registerClassAlias("org.cove.ape.Vector", org.cove.ape.Vector);
			registerClassAlias("org.cove.ape.VectorForce", org.cove.ape.VectorForce);
			registerClassAlias("org.cove.ape.WheelParticle", org.cove.ape.WheelParticle);		
		}
	}
}