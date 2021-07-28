package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.components.UserButtonComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.corsi_task_states.CorsiInitialState;
import flixel.FlxSprite;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class CorsiTaskObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	public var corsi:String;

	public var corsi_obj:CorsiMachine;

	public var button_area:FlxRect;

	// parameters
	public var maxSequenceLen:Int = 9;
	public var minSequenceLen:Int = 2;
	public var trialsPerLen:Int = 3;
	public var minCorrect:Int = 2;
	public var backwards:Bool = true;

	public var currentSequenceLen:Int;
	public var correctTrials:Int = 0;
	public var remainingTrials:Int = 0;

	public var state_machine:StateMachineComponent;

	public var sequence:Array<DnaButtonObject>;

	public function answerCorrectSoFar(correct:Array<DnaButtonObject>, answered:Array<DnaButtonObject>, backwards:Bool = false)
	{
		var c = correct.copy();
		if (backwards)
		{
			c.reverse();
		}
		for (i in 0...answered.length)
		{
			if (c[i] != answered[i])
			{
				return false;
			}
		}
		return true;
	}

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("CorsiTaskObject");
		currentSequenceLen = minSequenceLen;
		remainingTrials = trialsPerLen;
		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(state_machine);
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		super.onReady();
		corsi_obj = cast this.getParent().getObjectByName(getNestedObjectName(corsi));
		this.state_machine.setNextState(new CorsiInitialState());
	}

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "corsi"))
		{
			this.corsi = cast jsonFile.corsi;
		}
	}

	public function generateRandomSequence() {}

	public function setParams(params:Dynamic)
	{
		// TODO: set the params like maxSequenceLen,.. etc.
	}

	public function getData():Dynamic
	{
		// we will break up our data structure a bit for this task.
		return {};
	}

	public function isCorrect():String
	{
		// corsi block task is always correct...
		return DnaConstants.TASK_CORRECT;
	}

	public override function update(elapsed:Float) {}
}
