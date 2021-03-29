package dnaobject.components;

import Assertion.assert;
import Random;
import dnadata.DnaDataManager;
import dnaobject.objects.SubStateObject;
import flixel.FlxG;
import flixel.FlxSubState;
import haxe.Timer;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionSwitchToSubStateComponent implements DnaComponent extends DnaActionBase
{
	public final NOT_SET_YET:Int = -1;
	public var duration:Int;
	public var duration_min:Int;
	public var duration_max:Int;

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
		if (duration != NOT_SET_YET)
		{
			trace("creating timer..");
			Timer.delay(substate.close, this.duration);
		}
		else if (duration_min != NOT_SET_YET && duration_max != NOT_SET_YET)
		{
			trace("creating timer..");
			this.duration = Random.int(duration_min, duration_max);
			Timer.delay(substate.close, this.duration);
			this.duration = NOT_SET_YET;
		}
	}

	/**
	 * in here we switch our state. and finish our action.
	 */
	private function switchstates()
	{
		trace("actionswitchto substate", duration);
		var obj:SubStateObject = cast this.getParent().getParent().getObjectByName(this.m_target_name);
		var substate = obj.sub_state;

		trace("switching to substate now:", substate.state_type);
		setupTimer(substate);
		this.getParent().getParent().openSubState(substate);
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float)
	{
		switchstates();
		this.finishAction();
	}
}
