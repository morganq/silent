package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Morgan Quirk
	 */
	public class Player extends FlxSprite
	{
		[Embed (source = "../data/player2.png")] private var playerImg:Class;
		
		public var target:FlxPoint;
		
		public function Player(x:int, y:int) 
		{
			super(x, y);
			loadGraphic(playerImg, true, true, 32, 48);
			addAnimation("idle", [0], 0, true);
			addAnimation("walk", [1, 2, 3, 4, 5, 6], 6, true);
		}
		
		override public function update():void 
		{
			if (target)
			{
				if (target.x > x + width) {
					velocity.x = 40;
					play("walk");
					facing = RIGHT;
				}
				else if (target.x < x) {
					velocity.x = -40
					play("walk");
					facing = LEFT;
				}
				else {
					velocity.x = 0;
					play("idle");
				}
			}
			super.update();
		}
		
	}
	
}