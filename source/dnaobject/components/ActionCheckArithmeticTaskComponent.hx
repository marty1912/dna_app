package dnaobject.components;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.ArithmeticTaskHandlerObject;
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
class ActionCheckArithmeticTaskComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionCheckArithmeticTaskComponent');
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
		super.fromFile(jsonFile);
	}

	/**
	 * this function checks if the numline result lies within the tolerance.
	 * if it is within the specified tolerance the event "NUMLINE_CORRECT" is broadcast.
	 * otherwise "NUMLINE_INCORRECT"
	 * @param numline_name - the name of the numberline to check.
	 * @param tol - max allowed deviation as a ratio to the whole numberline len.
	 */
	public function checkArithmeticTask(target_name:String)
	{
		var task_handler:ArithmeticTaskHandlerObject = cast(getParent().getParent().getObjectByName(target_name));
		var answer:Int = task_handler.getAnswer();
		var solution:Int = task_handler.getSolution();
		if (answer == solution)
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
		checkArithmeticTask(m_target_name);
		finishAction();
	}
}
