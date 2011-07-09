package 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Morgan Quirk
	 */
	public class Main extends FlxGame 
	{
		public function Main():void 
		{
			FlxG.debug = true;
			
			super(320, 200, TestState, 2);
			FlxG.flashFramerate = 30;
		}
		
	}
	
}