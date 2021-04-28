package dnaobject.components;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Slideable;
import dnaobject.objects.NumberlineObject;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import osspec.OsManager;

/**
 * class PositionComponent.
 * this component keeps its parent in the center of the screen.
 */
class ActionCheckNumberlineComponent implements DnaComponent extends DnaActionBase
{
	public var tolerance:Float;

	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionCheckNumberlineComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		if (Reflect.hasField(jsonFile, "tolerance"))
		{
			// this is the wrong way around i know. but it works like this..
			this.tolerance = jsonFile.tolerance;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * this function checks if the numline result lies within the tolerance.
	 * if it is within the specified tolerance the event "NUMLINE_CORRECT" is broadcast.
	 * otherwise "NUMLINE_INCORRECT"
	 * @param numline_name - the name of the numberline to check.
	 * @param tol - max allowed deviation as a ratio to the whole numberline len.
	 */
	public function checkNumline(numline_name:String, tol:Float)
	{
		var numline:NumberlineObject = cast(getParent().getParent().getObjectByName(m_target_name));
		var selected:Float = numline.getSliderNum();
		var min:Float = numline.getNumZero();
		var max:Float = numline.getNumMax();
		var target_num:Float = numline.getNumTarget();
		var range:Float = max - min;
		var deviation:Float = range * tol;

		// trace("numline.slider.alpha:", numline.slider.alpha);
		if (numline.slider.alpha == 0)
		{
			this.getParent().getParent().eventManager.broadcastEvent(DnaConstants.TASK_TIMED_OUT_FEEDBACK);
		}
		else if (selected >= target_num - deviation && selected <= target_num + deviation)
		{
			this.getParent().getParent().eventManager.broadcastEvent(DnaConstants.TASK_CORRECT);
		}
		else
		{
			this.getParent().getParent().eventManager.broadcastEvent(DnaConstants.TASK_INCORRECT);
		}
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		checkNumline(this.m_target_name, this.tolerance);
		finishAction();
	}
}
