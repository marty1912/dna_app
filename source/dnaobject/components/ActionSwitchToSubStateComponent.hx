package dnaobject.components;

import Assertion.assert;
import Random;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.objects.SubStateObject;
import flixel.FlxG;
import flixel.FlxSubState;
import haxe.Timer;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionSwitchToSubStateComponent implements DnaComponent extends DnaActionBase implements DnaEventSubscriber
{
	public final NOT_SET_YET:Int = -1;
	public var duration:Int;
	public var duration_min:Int;
	public var duration_max:Int;

	/**
	 * this is the function that will be called whenever the substate is done.
	 * @param event_name 
	 * @param params 
	 */
	public function getNotified(event_name:String, params:Any = null)
	{
		this.finishAction();
	}

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSwitchToSubstateComponent");
		duration = NOT_SET_YET;
		duration_min = NOT_SET_YET;
		duration_max = NOT_SET_YET;
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "duration"))
		{
			duration = jsonFile.duration;
		}
		if (Reflect.hasField(jsonFile, "duration_min"))
		{
			duration_min = jsonFile.duration_min;
		}
		if (Reflect.hasField(jsonFile, "duration_max"))
		{
			duration_max = jsonFile.duration_max;
		}

		super.fromFile(jsonFile);
	}

	/**
	 * sets up the timers for returning from the substate again.
	 */
	private function setupTimer(substate:FlxSubState)
	{
		// if we have a min and a max we want  to randomly choose a time value
		if (duration_min != NOT_SET_YET && duration_max != NOT_SET_YET)
		{
			trace("creating timer..");
			var random_duration = Random.int(duration_min, duration_max);
			trace("got random time interval to close:", random_duration);
			Timer.delay(substate.close, random_duration);
		}
		// a set duration overrides the randomly generated one
		if (duration != NOT_SET_YET)
		{
			trace("creating fixed duration timer..", this.duration);
			Timer.delay(substate.close, this.duration);
		}
	}

	/**
	 * in here we switch our state. and finish our action.
	 */
	private function switchstates()
	{
		trace("actionswitchto substate duration:", duration);
		var obj:SubStateObject = cast this.getParent().getParent().getObjectByName(this.m_target_name);
		var substate = obj.sub_state;

		trace("switching to substate now:", substate.state_type);
		setupTimer(substate);
		this.getParent().getParent().eventManager.addSubscriberForEvent(this, obj.getSubstateClosedEventName());
		this.getParent().getParent().openSubState(substate);
	}

	/**
	 *  called when we first are added to the state.
	 */
	override public function onHaveParent()
	{
		switchstates();
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float) {}
}
