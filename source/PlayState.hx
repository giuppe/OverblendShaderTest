package;

import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxGroup;
import flixel.addons.display.FlxShaderMaskCamera;
import openfl.ui.Mouse;
import openfl.display.Shape;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var sunSprite:FlxSprite;
	private var buildingsGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	private var overShader:OverblendShader;
	private var overShaderBg:OverblendShader;
	private var shaderMask:FlxShaderMaskCamera;

	override public function create():Void
	{
		super.create();

		FlxG.camera.antialiasing = true;
		FlxG.mouse.load(new FlxSprite().makeGraphic(1, 1));

		var bg = new FlxSprite();
		bg.loadGraphic("assets/brick-0207.jpg");
		add(bg);

		sunSprite = new FlxSprite();
		sunSprite.makeGraphic(50, 50, FlxColor.TRANSPARENT);
		var sunShape:Shape = new Shape();

		sunShape.graphics.beginFill(0xFFEECC);
		sunShape.graphics.drawCircle(25, 25, 25);
		sunShape.graphics.endFill();
		sunSprite.graphic.bitmap.draw(sunShape);
		add(sunSprite);

		var buildings = [
			{
				x: 10,
				y: 10,
				w: 100,
				h: 600
			},
			{
				x: 200,
				y: 100,
				w: 100,
				h: 600
			},
			{
				x: 400,
				y: 50,
				w: 100,
				h: 600
			}
		];
		for (b in buildings)
		{
			var buildingsSprite = new FlxSprite();
			buildingsSprite.makeGraphic(b.w, b.h, FlxColor.fromRGB(11, 11, 11));
			buildingsSprite.x = b.x;
			buildingsSprite.y = b.y;
			buildingsSprite.collisonXDrag = false;
			buildingsGroup.add(buildingsSprite);
		}
		add(buildingsGroup);
		overShader = new OverblendShader();
		shaderMask = new FlxShaderMaskCamera(overShader);
		FlxG.cameras.reset(shaderMask);
		var mask = new FlxSprite(0, 0);

		mask.makeGraphic(512, 512, FlxColor.WHITE);
		shaderMask.addMaskObject(mask);
		overShaderBg = new OverblendShader();
		bg.shader = overShaderBg;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		sunSprite.x = FlxG.mouse.screenX - sunSprite.width / 2;
		sunSprite.y = FlxG.mouse.screenY - sunSprite.height / 2;

		overShader.sunPosition.value = [FlxG.mouse.screenX / 512, FlxG.mouse.screenY / 512];
		overShader.sunRadius.value = [0.1];
		overShaderBg.sunPosition.value = [FlxG.mouse.screenX / 512, FlxG.mouse.screenY / 512];
		overShaderBg.sunRadius.value = [0.1];
		var collision:Bool = false;
		buildingsGroup.forEach((s:FlxSprite) ->
		{
			if (s.overlapsPoint(new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY)))
			{
				collision = true;
			}
		});
		if (collision == true)
		{
			overShader.enabled.value = [0.0];
			overShaderBg.enabled.value = [1.0];
		}
		else
		{
			overShaderBg.enabled.value = [0.0];
			overShader.enabled.value = [1.0];
		}
	}
}
