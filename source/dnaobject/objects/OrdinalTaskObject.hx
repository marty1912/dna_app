package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.components.SymbolSlotComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateHidden;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.DotsDisplay.DotsStateHidden;
import dnaobject.objects.DotsDisplay.DotsStateNoise;
import dnaobject.objects.DotsDisplay.DotsStateVisible;
import dnaobject.objects.DotsDisplay;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class OrdinalTaskObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("OrdinalTaskObject");
		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(cast state_machine);
	}

	override public function onHaveParent() {}

	public var answer:String = "";

	public function answerTask(value:String)
	{
		this.answer = value;
		if (this.isCorrect() == DnaConstants.TASK_CORRECT)
		{
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT, true);
		}
		else
		{
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT, false);
		}
	}

	public var solution:String = null;

	public function setParams(params:Dynamic)
	{
		this.answer = null;
		solution = params.solution;
		this.pattern_display_obj.setPattern(params.pattern);
	}

	/*
	 * isCorrect() checks if the task was answered correctly 
	 * 
	 */
	public function isCorrect():String
	{
		if (answer == solution)
		{
			return DnaConstants.TASK_CORRECT;
		}
		else if (answer == null)
		{
			return DnaConstants.TASK_TIMED_OUT_FEEDBACK;
		}
		return DnaConstants.TASK_INCORRECT;
	}

	public function getData():Dynamic
	{
		var current_trial:Dynamic = {
			pattern: pattern_display_obj.getPattern(),
			answer: this.answer,
			solution: this.solution
		};

		return current_trial;
	}

	public var state_machine:IStateMachine;

	override public function onReady()
	{
		super.onReady();

		fixation_obj = cast this.getParent().getObjectByName(getNestedObjectName(fixation));
		pattern_display_obj = cast this.getParent().getObjectByName(getNestedObjectName(pattern_display));
		button_left_obj = cast this.getParent().getObjectByName(getNestedObjectName(button_left));
		button_right_obj = cast this.getParent().getObjectByName(getNestedObjectName(button_right));

		indicator_left_obj = cast this.getParent().getObjectByName(getNestedObjectName(indicator_left));
		indicator_right_obj = cast this.getParent().getObjectByName(getNestedObjectName(indicator_right));

		if (DnaDataManager.instance.retrieveData(DnaDataManager.ORD_TASK_COND))
		{
			// a "true" means that the task will have the right side as in-order
			indicator_right_obj.setAssetPath("assets/gui_elements/buttonAccept.png");
			indicator_left_obj.setAssetPath("assets/gui_elements/buttonDecline.png");
			button_right_obj.onPressCallback = this.answerTask.bind("IN_ORDER");
			button_left_obj.onPressCallback = this.answerTask.bind("MIXED_ORDER");
		}
		else
		{
			indicator_right_obj.setAssetPath("assets/gui_elements/buttonDecline.png");
			indicator_left_obj.setAssetPath("assets/gui_elements/buttonAccept.png");

			button_right_obj.onPressCallback = this.answerTask.bind("MIXED_ORDER");
			button_left_obj.onPressCallback = this.answerTask.bind("IN_ORDER");
		}

		state_machine.setNextState(new OrdinalObjectStateVisible());
	}

	public var pattern_display:String;
	public var pattern_display_obj:PatternDisplay;

	public var button_left:String;
	public var button_right:String;
	public var button_left_obj:DnaButtonObject;
	public var button_right_obj:DnaButtonObject;

	public var indicator_left:String;
	public var indicator_right:String;
	public var indicator_left_obj:DnaButtonObject;
	public var indicator_right_obj:DnaButtonObject;

	public var fixation:String;
	public var fixation_obj:SpriteObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "pattern_display"))
		{
			this.pattern_display = cast jsonFile.pattern_display;
		}

		if (Reflect.hasField(jsonFile, "button_left"))
		{
			this.button_left = cast jsonFile.button_left;
		}
		if (Reflect.hasField(jsonFile, "button_right"))
		{
			this.button_right = cast jsonFile.button_right;
		}
		if (Reflect.hasField(jsonFile, "indicator_left"))
		{
			this.indicator_left = cast jsonFile.indicator_left;
		}
		if (Reflect.hasField(jsonFile, "indicator_right"))
		{
			this.indicator_right = cast jsonFile.indicator_right;
		}

		if (Reflect.hasField(jsonFile, "fixation"))
		{
			fixation = jsonFile.fixation;
		}
	}
}

class OrdinalObjectStateVisible implements IState
{
	public var ord_obj:OrdinalTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		ord_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		ord_obj.button_left_obj.setNextState(new ButtonStateNormal());
		ord_obj.button_right_obj.setNextState(new ButtonStateNormal());
		ord_obj.indicator_left_obj.setNextState(new ButtonStateNormal());
		ord_obj.indicator_right_obj.setNextState(new ButtonStateNormal());

		ord_obj.fixation_obj.sprite.alpha = 0.0;

		ord_obj.pattern_display_obj.setVisible(true);
	}

	public function exit():Void {}
}

class OrdinalObjectStateHidden implements IState
{
	public var ord_obj:OrdinalTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		ord_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		ord_obj.button_left_obj.setNextState(new ButtonStateHidden());
		ord_obj.button_right_obj.setNextState(new ButtonStateHidden());
		ord_obj.indicator_left_obj.setNextState(new ButtonStateHidden());
		ord_obj.indicator_right_obj.setNextState(new ButtonStateHidden());

		ord_obj.fixation_obj.sprite.alpha = 0.0;
		ord_obj.pattern_display_obj.setVisible(false);
	}

	public function exit():Void {}
}

class OrdinalObjectStateFixation implements IState
{
	public var ord_obj:OrdinalTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		ord_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		ord_obj.button_left_obj.setNextState(new ButtonStateHidden());
		ord_obj.button_right_obj.setNextState(new ButtonStateHidden());
		ord_obj.indicator_left_obj.setNextState(new ButtonStateHidden());
		ord_obj.indicator_right_obj.setNextState(new ButtonStateHidden());

		ord_obj.fixation_obj.setVisible(true);
		ord_obj.pattern_display_obj.setVisible(false);
	}

	public function exit():Void {}
}

class OrdinalObjectStateInactive implements IState
{
	public var ord_obj:OrdinalTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		ord_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		ord_obj.button_left_obj.setNextState(new ButtonStateInactive());
		ord_obj.button_right_obj.setNextState(new ButtonStateInactive());
		ord_obj.indicator_left_obj.setNextState(new ButtonStateInactive());
		ord_obj.indicator_right_obj.setNextState(new ButtonStateInactive());

		ord_obj.fixation_obj.setVisible(false);
		ord_obj.pattern_display_obj.setVisible(true);
	}

	public function exit():Void {}
}
