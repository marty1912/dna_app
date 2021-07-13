package dnaobject.components;

import Assertion.assert;
import dnaobject.objects.DnaButtonObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class ButtonScaleComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ButtonScaleComponent");
	}

	public var target_name:String = "";
	public var keep_ratio:Bool = true;
	public var oneshot:Bool = false;

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
		if (Reflect.hasField(jsonFile, "keep_ratio"))
		{
			keep_ratio = jsonFile.keep_ratio;
		}
		if (Reflect.hasField(jsonFile, "oneshot"))
		{
			oneshot = jsonFile.oneshot;
		}
	}

	override public function onHaveParent()
	{
		var target:DnaObject = getParent().getParent().getObjectByName(target_name);
		if (target == null)
		{
			trace("could not find target with name:", target_name, "all names:", getParent().getParent().getAllObjectNames());
		}

		var button:DnaButtonObject = cast this.getParent();
		var want_width = target.getWidth();
		var want_height = target.getHeight();

		var have_width = button.button.width;
		var have_height = button.button.height;

		var factor_width = want_width / have_width;
		var factor_height = want_height / have_height;

		if (keep_ratio)
		{
			if (factor_height > factor_width)
			{
				factor_height = factor_width;
			}
			if (factor_height < factor_width)
			{
				factor_width = factor_height;
			}
		}

		// button.button.scale.x *= factor_width;
		// button.button.scale.y *= factor_height;
		if (keep_ratio)
		{
			button.button.setGraphicSize(want_width);
		}
		else
		{
			button.button.setGraphicSize(want_width, want_height);
		}
		button.button.updateHitbox();

		// button.button.width = have_width * factor_width;
		// button.button.height = have_height * factor_height;
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		if (!this.oneshot)
		{
			onHaveParent();
		}
	}
}
