package dnaobject.objects;

import dnaobject.interfaces.Scrollable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxPoint;

/**
 * class BackgroundObject
 * this class represents our Numberline. it is a Group of FlxBasic objects
 *
 */
class BackgroundObject implements DnaObject implements Scrollable extends DnaObjectBase
{
	/**
	 * this is our backdrop object
	 */
	public var backdrop:FlxSprite;

	/**
	 * this is the path to our background file.
	 */
	private var m_background_asset_path:String;

	/**
	 * constructor.
	 */
	public function new()
	{
		super('BackgroundObject');
		backdrop = new FlxSprite();
		addChild(backdrop);
	}

	public function setPosition(value:FlxPoint)
	{
		this.backdrop.setPosition(value.x, value.y);
	}

	public function getPosition():FlxPoint
	{
		return this.backdrop.getPosition();
	}

	/**
	 * backdrop can read every constant it uses from a file..
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "background_path"))
		{
			m_background_asset_path = jsonFile.background_path;
			backdrop.loadGraphic(m_background_asset_path);
			backdrop.setGraphicSize(FlxG.width, FlxG.height);
			backdrop.updateHitbox();
			trace("backdrop size:", backdrop.width, backdrop.height);
		}
		super.fromFile(jsonFile);
	}
}
