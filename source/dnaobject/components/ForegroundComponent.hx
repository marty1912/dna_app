package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.components.ActionSetSliderPosComponent;
import dnaobject.interfaces.Slideable;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import osspec.OsManager;

/**
 * class PositionComponent.
 * this component keeps its parent in the center of the screen.
 */
class ForegroundComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('ForegroundComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
	}

	public var oneshot:Bool = true;

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		if (Reflect.hasField(jsonFile, "oneshot"))
		{
			// this is the wrong way around i know. but it works like this..
			this.oneshot = jsonFile.oneshot;
		}
	}

	public function putIntoForeground(object:DnaObject)
	{
		var child_list = object.getChildren();
		var to_add = new Array<FlxObject>();
		trace("before childlist:", child_list.length);
		for (child in child_list)
		{
			object.removeChild(child);
			to_add.push(child);
		}

		for (child in to_add)
		{
			object.addChild(child);
		}
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// as this is an interactive component we do not want to run the update function if it is set inactive
		if (!active)
		{
			return;
		}
		putIntoForeground(getParent());
		if (oneshot)
		{
			this.getParent().removeComponent(this.id);
		}
	}
}
