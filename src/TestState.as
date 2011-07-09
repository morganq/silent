package  
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Morgan Quirk
	 */
	public class TestState extends FlxState
	{
		[Embed (source = "../data/bg3.png")] private var bgImg:Class;
		[Embed (source = "../data/o_frameborder2.png")] private var borderImg:Class;
		[Embed (source = "../data/o_defects2.png")] private var defectsImg:Class;
		[Embed (source = "../data/o_grain2.png")] private var grainImg:Class;
		[Embed (source = "../data/o_vignette2.png")] private var vignetteImg:Class;
		
		[Embed (source = "../data/projector.mp3")] private var projectorSnd:Class;
		[Embed (source = "../data/piano.mp3")] private var pianoSnd:Class;
		
		public var border:BitmapData;
		public var defects:Array = new Array();
		public var grain:BitmapData;
		public var vignette:BitmapData;
		public var frameTimer:int = 0;
		public var flickerTimer:Number = 0;
		
		public var player:Player;
		
		public var yOffset:Number = 0;
		public var numYears:int = 10;
		
		public function TestState() 
		{
			FlxG.mouse.show();
			
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			add(bg);
			
			border = FlxG.addBitmap(borderImg);
			grain = FlxG.addBitmap(grainImg);
			vignette = FlxG.addBitmap(vignetteImg);
			var allDefects:BitmapData = FlxG.addBitmap(defectsImg);
			for (var i:int = 0; i < allDefects.width / 50; i++)
			{
				defects.push(new BitmapData(50, 50));
				defects[i].copyPixels(allDefects, new Rectangle(i * 50, 0, 50, 50), new Point(0, 0));
			}
			
			player = new Player(100, 100);
			
			add(player);
			
		}
		
		override public function create():void 
		{
			FlxG.play(projectorSnd, 1.0, true);
			FlxG.playMusic(pianoSnd);
			super.create();
			
			for (var i:int = 0; i < numYears; i++)
			{
				var c:FlxCamera = new FlxCamera(0, -i * FlxG.height * 2, FlxG.width, FlxG.height, 2);
				FlxG.addCamera(c);
				var t:FlxText = new FlxText(7, 174, 100, (1922 + i).toString());
				t.setFormat(null, 16, 0x000000);
				t.cameras = [c];
				add(t);
			}
		}
		
		
		override public function update():void 
		{
			if (FlxG.mouse.justPressed()) {
				player.target = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			}
			
			yOffset = Math.min(yOffset + FlxG.elapsed * 5, FlxG.height * (numYears-1));
			setCameraPositions();
			
			super.update();
		}
		
		public function getCamerasForYears(start:int, end:int)
		{
			var cams:Array = new Array();
			for (var i:int = start; i < end; i++)
			{
				cams.push(FlxG.cameras[i + 1]);
			}
			return cams;
		}
		
		public function setCameraPositions():void
		{
			for (var i:int = 0; i < FlxG.cameras.length - 1; i++ )
			{
				FlxG.cameras[i+1].y = yOffset * 2 - i * FlxG.height * 2;
			}
		}
		
		public function getYearCamera(year:int):FlxCamera
		{
			return FlxG.cameras[year+1];
		}
		
		public function getActiveCameras():Array
		{
			var cams:Array = new Array();
			var baseYear:int = yOffset / FlxG.height;
			cams.push(getYearCamera(baseYear));
			if (baseYear < (numYears-1))
			{
				cams.push(getYearCamera(baseYear+1));
			}
			FlxG.log(cams);
			return cams;
		}
		
		override public function draw():void 
		{
			super.draw();
			FlxG.log(FlxG.cameras.length);
			frameTimer++;
			for each (var c:FlxCamera in getActiveCameras())
			{		
				var mtx:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
				c.buffer.draw(border, mtx, null, "multiply");
				
				mtx = new Matrix(1, 0, 0, 1, Math.random() * -320, 0);
				var ct:ColorTransform = new ColorTransform(1, 1, 1, Math.random()*0.5+0.5, 0, 0, 0, 0);
				c.buffer.draw(grain, mtx, ct, "overlay");
				
				if (Math.random() < 0.3)
				{
					mtx = new Matrix(Math.random() * 2, 0, 0, Math.random() * 2, Math.random()*270,Math.random()*190);
					c.buffer.draw(defects[Math.floor(Math.random() * defects.length)], mtx, null, "overlay");
				}
				
				var br:Number = Math.sin(frameTimer / 5) * 0.25 + 1 + Math.random() * 0.25;
				ct = new ColorTransform(br, br, br, 0.7, 0,0,0, 0);
				c.buffer.draw(vignette, null, ct, "overlay");
				
				var black:BitmapData = new BitmapData(320, 240, true, 0xff000000);
				flickerTimer += FlxG.elapsed;
				if (frameTimer % 4 == 0)
				{
					flickerTimer = 0;
					c.buffer.draw(black, null, new ColorTransform(1, 1, 1, 0.4, 0, 0, 0, 0));
				}
			}
		}
		
	}
	
}