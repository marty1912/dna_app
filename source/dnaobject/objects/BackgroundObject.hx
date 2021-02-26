package dnaobject.objects;

import dnaobject.interfaces.Scrollable;
import flixel.addons.display.FlxBackdrop;

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
	public var backdrop:FlxBackdrop;

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
		backdrop = new FlxBackdrop();
		addChild(backdrop);
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
		}
		super.fromFile(jsonFile);
	}
}
