package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateHidden;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class PatternExtendObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternExtendObject");
	}

	public function onPatternChanged()
	{
		trace("the pattern changed.. ready:", patternReadyToSubmit());
		if (patternReadyToSubmit())
		{
			button_obj.setNextState(new ButtonStateNormal());
		}
		else
		{
			button_obj.setNextState(new ButtonStateInactive());
		}
	}

	/**
	 * this helper function checks the pattern array for completeness
	 * @param arr 
	 */
	public function patternReadyToSubmit()
	{
		if (pattern_display_obj.fields_to_fill == pattern_display_obj.filled_fields)
		{
			return true;
		}

		return false;
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		pattern_display_obj = cast this.getParent().getObjectByName(getNestedObjectName(pattern_display));
		pattern_display_obj.onPatternChanged = this.onPatternChanged;
		button_obj = cast this.getParent().getObjectByName(getNestedObjectName(button));
		button_obj.setNextState(new ButtonStateHidden());
	}

	public var pattern_display:String;
	public var pattern_display_obj:PatternDisplay;
	public var button:String;
	public var button_obj:DnaButtonObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "pattern_display"))
		{
			pattern_display = jsonFile.pattern_display;
		}
		if (Reflect.hasField(jsonFile, "button"))
		{
			button = jsonFile.button;
		}

		if (Reflect.hasField(jsonFile, "pattern_assets")) {}
	}

	public override function update(elapsed:Float) {}

	/**
	 * each task must know how to adjust its own parameters.
	 * for this we need something like:
	 * @param params {pattern:["path1","path2",""],solution:["path1","path2","path3"]}
	 */
	public function setParams(params:Dynamic):Void
	{
		pattern_display_obj.setPattern(params.pattern);
		correct_solution = params.solution;
	}

	public var correct_solution:Array<String>;

	/**
	 * each Task should know how to collect its own data.
	 * @return Dynamic
	 */
	public function getData():Dynamic
	{
		return {pattern_answer: pattern_display_obj.getPattern(), correct: this.isCorrect()};
	}

	/**
	 * returns wheter or not the task was answered correctly (should be possible to say for most taskObjects.)
	 * 
	 * @return String. either 
	 * DnaConstants.TASK_CORRECT
	 * DnaConstants.TASK_INCORRECT
	 * DnaConstants.TASK_TIMEDOUT_FEEDBACK
	 */
	public function isCorrect():String
	{
		var all_same = true;
		var answer = pattern_display_obj.getPattern();
		for (index in 0...correct_solution.length)
		{
			if (correct_solution[index] != answer[index])
			{
				all_same = false;
				break;
			}
		}
		if (all_same)
		{
			return DnaConstants.TASK_CORRECT;
		}

		return DnaConstants.TASK_INCORRECT;
	}
}
