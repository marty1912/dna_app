package dnaobject.objects;

import Assertion.assert;
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
class PatternGeneralizeObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternGeneralizeObject");
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
			button_obj.setNextState(new ButtonStateHidden());
		}
	}

	/**
	 * called when the user presses the button
	 */
	public function onButtonPress()
	{
		button_obj.setNextState(new ButtonStateHidden());
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
		return pattern_input_obj.disabled;
	}

	public function set_disabled(value:Bool):Bool
	{
		pattern_input_obj.disabled = value;
		for (obj in this.dragables_obj)
		{
			obj.disabled = value;
		}
		return value;
	}

	/**
	 * this helper function checks the pattern array for completeness
	 * @param arr 
	 */
	public function patternReadyToSubmit()
	{
		trace("pattern generalize correct:", isCorrect());
		if (pattern_input_obj.fields_to_fill == pattern_input_obj.filled_fields)
		{
			return true;
		}

		return false;
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		pattern_display_obj = cast this.getParent().getObjectByName(getNestedObjectName(pattern_display));
		// pattern_display_obj.onPatternChanged = this.onPatternChanged;

		pattern_input_obj = cast this.getParent().getObjectByName(getNestedObjectName(pattern_input));
		pattern_input_obj.onPatternChanged = this.onPatternChanged;
		button_obj = cast this.getParent().getObjectByName(getNestedObjectName(button));
		button_obj.setNextState(new ButtonStateHidden());
		button_obj.onPressCallback = this.onButtonPress;
		for (drag in dragables)
		{
			dragables_obj.push(cast this.getParent().getObjectByName(getNestedObjectName(drag)));
		}
	}

	public var pattern_display:String;
	public var pattern_input:String;
	public var dragables:Array<String> = new Array<String>();
	public var pattern_display_obj:PatternDisplay;
	public var pattern_input_obj:PatternDisplay;
	public var button:String;
	public var button_obj:DnaButtonObject;
	public var dragables_obj:Array<SymbolDragable> = new Array<SymbolDragable>();

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
		if (Reflect.hasField(jsonFile, "pattern_input"))
		{
			pattern_input = jsonFile.pattern_input;
		}
		if (Reflect.hasField(jsonFile, "button"))
		{
			button = jsonFile.button;
		}

		if (Reflect.hasField(jsonFile, "pattern_assets")) {}
		if (Reflect.hasField(jsonFile, "dragables"))
		{
			dragables = jsonFile.dragables;
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
		pattern_input_obj.setPattern(params.input);
		correct_solution = params.solution;
		if (Reflect.hasField(params, "choices"))
		{
			for (choice_index in 0...this.dragables_obj.length)
			{
				dragables_obj[choice_index].symbol_obj.setAssetPath(params.choices[choice_index]);
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
		return {pattern_answer: pattern_input_obj.getPattern(), correct: this.isCorrect()};
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
		/*
		 * the tasks will be to create the same pattern using different symbols.
		 * so we will try and create a dict from the values in the solution to the values we get from the user.
		 */
		var answer = pattern_input_obj.getPattern();
		assert(answer.length == correct_solution.length);
		var map = new Map<String, String>();
		for (index in 0...correct_solution.length)
		{
			var key = correct_solution[index];
			var value = answer[index];
			if (map.exists(key) && map.get(key) != value)
			{
				return DnaConstants.TASK_INCORRECT;
			}
			map[key] = value;
		}
		/*
			// each entry is only allowed one value
			// otherwise users could just use the same symbol for the complete pattern like this:
			// ABABAB
			// CCCCCC
			// by forcing the values to be unique we
		 */

		var counts = new Map<String, Int>();
		for (value in map)
		{
			if (counts.exists(value))
			{
				counts[value]++;
			}
			else
			{
				counts[value] = 1;
			}
		}
		for (value in counts)
		{
			if (value > 1)
			{
				return DnaConstants.TASK_INCORRECT;
			}
		}
		return DnaConstants.TASK_CORRECT;
	}
}
