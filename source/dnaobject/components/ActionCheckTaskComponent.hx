package dnaobject.components;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.ArithmeticTaskHandlerObject;
import dnaobject.objects.NumberlineObject;
import dnaobject.objects.TimerObject;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import osspec.OsManager;

/**
 * ActionCheckTask Component - this action checks wheter a task is correct or not and fires the events TASK_CORRECT or TASK_INCORRECT
 */
class ActionCheckTaskComponent implements DnaComponent implements DnaEventSubscriber extends DnaActionBase
{
	/**
	 * in here we will get notified for a timeout.
	 * @param event_name 
	 */
	public function getNotified(event_name:String, params:Any = null)
	{
		// trace("got notified:", event_name);
		if (event_name == DnaConstants.EVT_TASK_TIMEOUT)
		{
			this.timeout = true;
		}
	}

	public var timeout:Bool = false;

	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionCheckTaskComponent');
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
	 * in here we will register for the task timeout event.
	 */
	override public function onHaveParent()
	{
		getParent().getParent().eventManager.addSubscriberForEvent(this, DnaConstants.EVT_TASK_TIMEOUT);
	}

	/**
	 * this function checks if the numline result lies within the tolerance.
	 * if it is within the specified tolerance the event "TASK_CORRECT" is broadcast.
	 * otherwise "TASK_INCORRECT"
	 * @param numline_name - the name of the numberline to check.
	 * @param tol - max allowed deviation as a ratio to the whole numberline len.
	 */
	public function checkTask(target_name:String)
	{
		var task_handler:TaskObject = cast(getParent().getParent().getObjectByName(target_name));
		var correct:String = task_handler.isCorrect();
		if (correct == DnaConstants.TASK_CORRECT)
		{
			this.getParent().getParent().eventManager.broadcastEvent(DnaConstants.TASK_CORRECT);
		}
		else if (correct == DnaConstants.TASK_INCORRECT)
		{
			this.getParent().getParent().eventManager.broadcastEvent(DnaConstants.TASK_INCORRECT);
		}
		else
		{
			this.getParent().getParent().eventManager.broadcastEvent(DnaConstants.TASK_TIMED_OUT_FEEDBACK);
		}
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		checkTask(m_target_name);
		finishAction();
	}
}
