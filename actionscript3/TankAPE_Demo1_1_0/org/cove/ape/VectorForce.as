/*
Copyright (c) 2006, 2007 Alec Cove

Permission is hereby granted, free of charge, to any person obtaining a copy of this 
software and associated documentation files (the "Software"), to deal in the Software 
without restriction, including without limitation the rights to use, copy, modify, 
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to the following 
conditions:

The above copyright notice and this permission notice shall be included in all copies 
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
TODO:
*/

package org.cove.ape {
	
	import flash.utils.*;
		
	/**
	 * A force represented by a 2D vector. 
	 */
	public class VectorForce implements IForce, IExternalizable {
	
		private var fvx:Number;
		private var fvy:Number;	
		
		private var value:Vector;	
		private var scaleMass:Boolean;
		
		
		public function VectorForce(useMass:Boolean = false, vx:Number = 0, vy:Number = 0) {
			fvx = vx;
			fvy = vy;
			scaleMass = useMass;
			value = new Vector(vx, vy);
		}
				
		public function writeExternal(output:IDataOutput):void {
			output.writeObject(fvx);
			output.writeObject(fvy);	
						
			output.writeObject(value);	
			output.writeBoolean(scaleMass);
		}
		  
		public function readExternal(input:IDataInput):void {  
			fvx = input.readObject() as Number;
			fvy = input.readObject() as Number;	
						
			value = input.readObject() as Vector;	
			scaleMass = input.readBoolean();
		}
		
		public function set vx(x:Number):void {
			fvx = x;
			value.x = x;
		}
		
		
		public function set vy(y:Number):void {
			fvy = y;
			value.y = y;
		}
		
		
		public function set useMass(b:Boolean):void {
			scaleMass = b
		}
		
		
		public function getValue(invmass:Number):Vector {
			if (scaleMass) { 
				value.setTo(fvx * invmass, fvy * invmass);
			}
			return value;
		}
	}
}