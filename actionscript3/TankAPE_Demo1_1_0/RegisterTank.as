package
{
	import flash.net.registerClassAlias;
	import tanks.*;
	
	public class RegisterTank
	{
		public function RegisterTank() {
			registerClassAlias("tanks.TankOne", TankOne);
			registerClassAlias("tanks.tankPosition", tankPosition);
			//registerClassAlias("Robot", Robot);
			//registerClassAlias("Motor", Motor);
			//registerClassAlias("Leg", Leg);
			//registerClassAlias("Body", Body);			
		}
	}
}