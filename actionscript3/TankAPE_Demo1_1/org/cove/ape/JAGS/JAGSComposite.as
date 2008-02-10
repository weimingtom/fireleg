package org.cove.ape.JAGS
{
	import org.cove.ape.Composite;
	import flash.utils.*;

	public class JAGSComposite extends Composite implements IExternalizable	{
		// need names to keep track of these things
		private var _name:String;
		
		public function JAGSComposite(name:String = "")
		{
			super();
			this._name = name;
		}

		public override function writeExternal(output:IDataOutput):void {
			super.writeExternal(output);
			output.writeObject(_name);
		}
		  
		public override function readExternal(input:IDataInput):void {  
			super.readExternal(input);
			_name = input.readObject() as String;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(name:String):void {
			this._name = name;
		}
		
	}
}