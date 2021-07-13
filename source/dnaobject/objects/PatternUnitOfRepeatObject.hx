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
class PatternUnitOfRepeatObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternUnitOfRepeatObject");
	}

	public function onPatternChanged()
	{
		trace("the pattern changed.. ready:", patternReadyToSubmit());
		if (patternReadyToSubmit()) {}
		else {}
	}

	/**
	 * called when the user presses the button
	 */
	public function onButtonPress(button_index:Int)
	{
		trace("button nr:", button_index, "pressed.");
		this.choice = button_index;
		this.disabled = true;
		if (isCorrect() == DnaConstants.TASK_CORRECT)
		{
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT, true);
		}
		else
		{
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT, false);
		}
	}

	public var disabled(get, set):Bool;

	public function get_disabled():Bool
	{
		return pattern_display_obj.disabled;
	}

	public function set_disabled(value:Bool):Bool
	{
		pattern_display_obj.disabled = value;
		for (obj in this.pattern_choices_obj)
		{
			obj.disabled = value;
		}

		for (obj in this.choice_buttons_obj)
		{
			if (value)
			{
				obj.setNextState(new ButtonStateInactive());
			}
			else
			{
				obj.setNextState(new ButtonStateNormal());
			}
		}
		return value;
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
		for (pat in pattern_choices)
		{
			pattern_choices_obj.push(cast this.getParent().getObjectByName(getNestedObjectName(pat)));
		}
		for (but in choice_buttons)
		{
			choice_buttons_obj.push(cast this.getParent().getObjectByName(getNestedObjectName(but)));
			var button_index = choice_buttons_obj.length - 1;
			choice_buttons_obj[button_index].onPressCallback = this.onButtonPress.bind(button_index);
		}
	}

	public var pattern_display:String;
	public var pattern_choices:Array<String> = new Array<String>();
	public var choice_buttons:Array<String> = new Array<String>();
	public var pattern_display_obj:PatternDisplay;

	public var choice:Int = 0;
	public var pattern_choices_obj:Array<PatternDisplay> = new Array<PatternDisplay>();
	public var choice_buttons_obj:Array<DnaButtonObject> = new Array<DnaButtonObject>();

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

		if (Reflect.hasField(jsonFile, "pattern_assets")) {}
		if (Reflect.hasField(jsonFile, "pattern_choices"))
		{
			pattern_choices = jsonFile.pattern_choices;
		}
		if (Reflect.hasField(jsonFile, "choice_buttons"))
		{
			choice_buttons = jsonFile.choice_buttons;
		}
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
		if (Reflect.hasField(params, "choices"))
		{
			for (choice_index in 0...this.pattern_choices_obj.length)
			{
				pattern_choices_obj[choice_index].setPattern(params.choices[choice_index]);
			}
		}

		this.disabled = false;
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
		var answer = pattern_choices_obj[choice].getPattern();
		if (answer.length != correct_solution.length)
		{
			return DnaConstants.TASK_INCORRECT;
		}
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
