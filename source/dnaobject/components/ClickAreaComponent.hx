package dnaobject.components;

import dnaobject.objects.DnaButtonObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class ClickAreaComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ClickAreaComponent");
	}

	public var target_name:String = "";

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target"))
		{
			target_name = jsonFile.target;
		}
	}

	public var first:Bool = true;

	override public function onHaveParent()
	{
		var target:DnaObject = getParent().getParent().getObjectByName(target_name);
		trace("target name:", target_name);
		var button:DnaButtonObject = cast this.getParent();
		button.button.alpha = 0;
		button.button.width = target.getWidth();
		button.button.height = target.getHeight();
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
