package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEvent;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;
import haxe.Timer;

/**
 * class TaskTimeoutTimerObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class TaskTimeoutTimerObject implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	public var time_update_loop:Float = 0;
	public var time_timer:Float = 0;
	public var timestamp_start:Float = 0;
	public var timestamp_end:Float = 0;
	public var max_time:Float = 10;
	public var running = false;

	/**
	 * in this function we obtain our answer (which number has been selected?)
	 * @param event_name 
	 */
	public function getNotified(event_name:String)
	{
		if (event_name == DnaConstants.EVT_START_TRIAL_TIME)
		{
			trace("starting timer with:", max_time);
			this.running = true;
			this.time_update_loop = 0;
		}
		else if (event_name == DnaConstants.TASK_ANSWERED_EVENT)
		{
			this.running = false;
		}
	}

	/**
	 * this function is called when the timer is finished.
	 */
	public function onTimerFin()
	{
		this.running = false;
		this.getParent().eventManager.broadcastEvent(DnaConstants.EVT_TASK_TIMEOUT);
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('TaskTimeoutTimerObject');
	}

	/**
	 * register events in here
	 */
	override public function registerEvents()
	{
		this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.EVT_START_TRIAL_TIME);
		this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.TASK_ANSWERED_EVENT);
	}

	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "max_time"))
		{
			this.max_time = jsonFile.max_time;
		}
		super.fromFile(jsonFile);
		return;
	}

	/**
	 * in here we measure the time for the update timer
	 * @param elapsed
	 */
	override public function update(elapsed):Void
	{
		if (this.running)
		{
			time_update_loop += elapsed;
			if (time_update_loop > max_time)
			{
				onTimerFin();
			}
		}
		super.update(elapsed);
	}
}
