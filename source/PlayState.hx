package;

import flixel.FlxCamera;
import openfl.display.BitmapData;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

using StringTools;

class PlayState extends FlxState
{
	var spriteHXCode = [];
	var spriteSelected:FlxSprite;
	var stageSprites:Array<FlxSprite> = [];

	var dad:FlxSprite;
	var boyfriend:FlxSprite;

	var stageCam:FlxCamera;
	var charCam:FlxCamera;

	override public function create()
	{
		super.create();

		stageCam = new FlxCamera();
		FlxG.cameras.add(stageCam);

		var spriteIndex = -1;

		FlxG.stage.window.onDropFile.add(function(path:String)
		{
			spriteIndex++;

			var sprite = new FlxSprite();
			var graphicBS = BitmapData.fromBytes(File.read(path).readAll());
			sprite.loadGraphic(graphicBS);
			sprite.ID = spriteIndex;
			stageSprites.push(sprite);
			sprite.cameras = [stageCam];
			add(sprite);

			var normalizedPath:String = path.replace("\\", "/");
			var filename:String = normalizedPath.substring(normalizedPath.lastIndexOf("/") + 1);

			spriteHXCode.push('	var sprite$spriteIndex = new FlxSprite().loadGraphic(Paths.image("${filename.replace(".png", "")}"));\n	add(sprite$spriteIndex);');
		});

		charCam = new FlxCamera();
		charCam.bgColor.alpha = 0;
		FlxG.cameras.add(charCam);

		dad = new FlxSprite(100, 100);
		dad.frames = Paths.getSparrowAtlas("DADDY_DEAREST");
		dad.animation.addByPrefix("idle", "Dad idle dance", 24);
		dad.animation.play("idle");
		dad.cameras = [charCam];
		add(dad);

		boyfriend = new FlxSprite(770, 450);
		boyfriend.frames = Paths.getSparrowAtlas("BOYFRIEND");
		boyfriend.animation.addByPrefix("idle", "BF idle dance", 24);
		boyfriend.animation.play("idle");
		boyfriend.cameras = [charCam];
		add(boyfriend);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		for (spr in stageSprites)
		{
			if (FlxG.mouse.overlaps(spr, stageCam) && FlxG.mouse.justPressed)
			{
				spriteSelected = spr;
			}
		}

		if (spriteSelected != null)
		{
			if (FlxG.keys.justPressed.W)
				spriteSelected.y -= 15;
			if (FlxG.keys.justPressed.S)
				spriteSelected.y += 15;
			if (FlxG.keys.justPressed.A)
				spriteSelected.x -= 15;
			if (FlxG.keys.justPressed.D)
				spriteSelected.x += 15;
			if (FlxG.mouse.overlaps(spriteSelected, stageCam) && FlxG.mouse.pressed) {
				spriteSelected.setPosition(FlxG.mouse.x - spriteSelected.width / 2, FlxG.mouse.y - spriteSelected.height / 2);
			}
		}

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
		{
			var heyheyhey = "";

			for (i => hxcode in spriteHXCode)
			{
				heyheyhey += if (i > 0) "\n\n" + hxcode + "\n" else "\n" + hxcode;
				heyheyhey += '\n	sprite${i}.setPosition(${stageSprites[i].x}, ${stageSprites[i].y});';
			}

			if (FlxG.keys.pressed.P)
			{
				var psychJsonExport = {
					"directory": "",
					"defaultZoom": 1,
					"boyfriend": [770, 100],
					"girlfriend": [400, 130],
					"opponent": [100, 100],
				};

				sys.io.File.saveBytes('./stage.hx', haxe.io.Bytes.ofString('//made with 504brandons epic stage editor\nfunction onCreate(){$heyheyhey\n}'));
				sys.io.File.saveBytes('./stage.json', haxe.io.Bytes.ofString(haxe.Json.stringify(psychJsonExport)));
			}
			else
			{
				sys.io.File.saveBytes('./stage.hx', haxe.io.Bytes.ofString('//made with 504brandons epic stage editor\nfunction create(){$heyheyhey\n}'));
			}
		}

		if (FlxG.mouse.wheel < 0)
			FlxG.camera.zoom -= 0.15;

		if (FlxG.mouse.wheel > 0)
			FlxG.camera.zoom += 0.15;

		if (FlxG.keys.pressed.UP)
			FlxG.camera.scroll.y -= 10;

		if (FlxG.keys.pressed.DOWN)
			FlxG.camera.scroll.y += 10;

		if (FlxG.keys.pressed.LEFT)
			FlxG.camera.scroll.x -= 10;

		if (FlxG.keys.pressed.RIGHT)
			FlxG.camera.scroll.x += 10;

		stageCam.zoom = FlxG.camera.zoom;
		stageCam.scroll.set(FlxG.camera.scroll.x, FlxG.camera.scroll.y);

		charCam.zoom = FlxG.camera.zoom;
		charCam.scroll.set(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
	}
}
