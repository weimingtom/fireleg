package org.cove.ape.JAGS
{
	import org.cove.ape.*;
	import flash.utils.*;
	
	public class JAGSGroup extends org.cove.ape.Group implements IExternalizable 
	{
		public var name:String = "";
		
		public function JAGSGroup(collideInternal:Boolean = false)
		{
			super(collideInternal);
		}

		public override function writeExternal(output:IDataOutput):void {
			super.writeExternal(output);
			output.writeObject(name);
		}
		  
		public override function readExternal(input:IDataInput):void {  
			super.readExternal(input);
			name = input.readObject() as String;
		}

		// Magically move your entire group of particles to this
		// exact location.		
		public function placeAbsolute(x:Number, y:Number):void {
			var v:Vector = getRelativeBearing(x,y);
			placeRelative(v.x, v.y);
		}
		
		// You need to find out where your point is relative
		// to the object before calling placeRelative.
		// This method does that by comparing the first particle
		// in the first composite.
		public function getRelativeBearing(x:Number, y:Number):Vector {
			var c:JAGSComposite = this.composites[0];
			if (c != null) {
				var firstPartcile:AbstractParticle = c.particles[0] as AbstractParticle;
				if (firstPartcile == null) {
					return new Vector(x, y);
				}
				else {
					var v:Vector = new Vector(firstPartcile.px - x, firstPartcile.py - y);
					return v;
				}
			}
			else return new Vector(x, y);
		}
		
		// moves all composite's particles witin the group.
		// the x and y are relative to where each x,y is
		public function placeRelative(x:Number, y:Number):void {
			var c:JAGSComposite;
			var p:AbstractParticle;
			
			for (var i:int = 0; i < this.composites.length; i++) {
				c = this.composites[i] as JAGSComposite;
				//trace("Moving Composite "+ c.name +" ("+ i +") with #particles =="+ c.particles.length);
								
				for (var j:int = 0; j < c.particles.length; j++) {
					p = c.particles[j] as AbstractParticle;
					p.px = p.px - x;
					p.py = p.py - y;
				}
				
			}
		}
		
	}
}