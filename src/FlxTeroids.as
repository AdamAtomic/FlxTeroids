package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class FlxTeroids extends FlxGame
	{
		public function FlxTeroids()
		{
			super(640,480,MenuState,1,50,50);
			forceDebugger = true;
		}
	}
}