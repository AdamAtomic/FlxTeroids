package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class FlxTeroids extends FlxGame
	{
		public function FlxTeroids()
		{
			super(320,240,MenuState,2,0xff000000,false); //logo off for dev
		}
	}
}
