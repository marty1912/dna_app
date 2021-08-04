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
import dnaobject.interfaces.IStateFactory;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.flanker_task_states.real_task.FlankerDefaultFactory;
import flixel.FlxSprite;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class FlankerTaskObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	public var flanker:String;

	public var flanker_obj:FlankerMachine;

	public var button_area:FlxRect;

	// parameters
	public var maxSequenceLen:Int = 9;
	public var minSequenceLen:Int = 2;
	public var trialsPerLen:Int = 2;
	public var minCorrect:Int = 1;
	public var backwards:Bool = true;
	public var feedback:Bool = false;

	public var currentSequenceLen:Int;
	public var correctTrials:Int = 0;
	public var remainingTrials:Int = 0;

	public var state_machine:StateMachineComponent;

	public var sequence:Array<DnaButtonObject>;

	public var state_factory:IStateFactory;

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("FlankerTaskObject");
		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(state_machine);
		state_factory = new FlankerDefaultFactory();
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		super.onReady();
		flanker_obj = cast this.getParent().getObjectByName(getNestedObjectName(flanker));
		action_correct_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_correct));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		action_incorrect_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_incorrect));
		action_error_out_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_error_out));
		trialhandler_obj = cast this.getParent().getObjectByName(getNestedObjectName(trialhandler));
		// trialhandler_obj.reload_on_fin = true;

		btn_left_obj = cast this.getParent().getObjectByName(getNestedObjectName(btn_left));
		btn_right_obj = cast this.getParent().getObjectByName(getNestedObjectName(btn_right));

		action_go_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_go));
		action_initial_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_initial));
		this.state_machine.setNextState(state_factory.create());
	}

	public var action_correct:String;
	public var action_correct_obj:ActionHandlerObject;

	public var action_fin:String;
	public var action_fin_obj:ActionHandlerObject;
	public var action_error_out:String;
	public var action_error_out_obj:ActionHandlerObject;

	public var trialhandler:String;
	public var trialhandler_obj:TrialHandlerObject;
	public var action_incorrect:String;
	public var action_incorrect_obj:ActionHandlerObject;

	public var btn_left:String;
	public var btn_left_obj:DnaButtonObject;

	public var btn_right:String;
	public var btn_right_obj:DnaButtonObject;

	public var action_initial:String;
	public var action_initial_obj:ActionHandlerObject;
	public var action_go:String;
	public var action_go_obj:ActionHandlerObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "flanker"))
		{
			this.flanker = cast jsonFile.flanker;
		}
		if (Reflect.hasField(jsonFile, "action_correct"))
		{
			this.action_correct = cast jsonFile.action_correct;
		}
		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			this.action_fin = cast jsonFile.action_fin;
		}
		if (Reflect.hasField(jsonFile, "action_incorrect"))
		{
			this.action_incorrect = cast jsonFile.action_incorrect;
		}
		if (Reflect.hasField(jsonFile, "action_go"))
		{
			this.action_go = cast jsonFile.action_go;
		}
		if (Reflect.hasField(jsonFile, "action_initial"))
		{
			this.action_initial = cast jsonFile.action_initial;
		}
		if (Reflect.hasField(jsonFile, "action_error_out"))
		{
			this.action_error_out = cast jsonFile.action_error_out;
		}
		if (Reflect.hasField(jsonFile, "trialhandler"))
		{
			this.trialhandler = cast jsonFile.trialhandler;
		}

		if (Reflect.hasField(jsonFile, "btn_left"))
		{
			this.btn_left = cast jsonFile.btn_left;
		}

		if (Reflect.hasField(jsonFile, "feedback"))
		{
			this.feedback = cast jsonFile.feedback;
		}

		if (Reflect.hasField(jsonFile, "btn_right"))
		{
			this.btn_right = cast jsonFile.btn_right;
		}
	}

	public function generateRandomSequence() {}

	public function setParams(params:Dynamic)
	{
		// TODO: set the params like maxSequenceLen,.. etc.
		trace("params set for flanker:", params);
		this.solution = params.solution;
		this.flanker_obj.pattern_display_obj.setPattern(params.pattern);
	}

	public var correct(get, never):Bool;

	public var solution:String;

	public var time:Float;

	public var answer:String;

	public function get_correct():Bool
	{
		if (this.solution == this.answer)
		{
			return true;
		}
		return false;
	}

	public function getData():Dynamic
	{
		// we will break up our data structure a bit for this task.
		return {
			answer: answer,
			solution: solution,
			correct: correct,
			time: time
		};
	}

	public function isCorrect():String
	{
		// flanker block task is always correct...
		return DnaConstants.TASK_CORRECT;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
