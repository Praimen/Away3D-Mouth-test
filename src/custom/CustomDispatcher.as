package custom
{
	import flash.events.EventDispatcher;
	
	public class CustomDispatcher extends EventDispatcher
	{
		private static var dispatcher:CustomDispatcher = null;
		public function CustomDispatcher (enforcer:SingletonEnforcer) : void {
			if (!enforcer) {
				throw new Error("Direct instatiation is not allowed");
			}
			return;
		}// end function
		
		
		public static function GetInstance() : CustomDispatcher {
			if (!dispatcher) {
				dispatcher= new CustomDispatcher (new SingletonEnforcer());
			}// end if
			return dispatcher;
		}// end function
	}
}
class SingletonEnforcer {}
