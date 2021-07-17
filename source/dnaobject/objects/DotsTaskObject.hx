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
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.DotsDisplay.DotsStateHidden;
import dnaobject.objects.DotsDisplay.DotsStateNoise;
import dnaobject.objects.DotsDisplay.DotsStateVisible;
import dnaobject.objects.DotsDisplay;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class DotsTaskObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("DotsTaskObject");
	}

	override public function onHaveParent() {}

	public var answer:String = "";

	public function answerTask(dots_path:String)
	{
		this.answer = dots_path;
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
		dots_left_obj.setDots(params.img_left);
		dots_right_obj.setDots(params.img_right);
		button_left_obj.onPressCallback = answerTask.bind(dots_left_obj.getDots());
		button_right_obj.onPressCallback = answerTask.bind(dots_right_obj.getDots());
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
			left_num: dots_left_obj.getDots(),
			right_num: dots_right_obj.getDots(),
			answer: this.answer,
			solution: this.solution
		};

		return current_trial;
	}

	public var state_machine:IStateMachine;

	override public function onReady()
	{
		super.onReady();

		this.dots_left_obj = cast getParent().getObjectByName(getNestedObjectName(dots_left));
		assert(dots_left_obj != null);
		this.dots_right_obj = cast getParent().getObjectByName(getNestedObjectName(dots_right));

		assert(dots_right_obj != null);

		this.button_left_obj = cast getParent().getObjectByName(getNestedObjectName(button_left));
		assert(button_left_obj != null);
		this.button_right_obj = cast getParent().getObjectByName(getNestedObjectName(button_right));
		assert(button_right_obj != null);
		button_left_obj.onPressCallback = answerTask.bind(dots_left_obj.getDots());
		button_right_obj.onPressCallback = answerTask.bind(dots_right_obj.getDots());

		fixation_obj = cast this.getParent().getObjectByName(getNestedObjectName(fixation));

		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(cast state_machine);
		state_machine.setNextState(new DotsObjectStateDisabled());
	}

	public var dots_left:String;
	public var dots_right:String;
	public var dots_left_obj:DotsDisplay;
	public var dots_right_obj:DotsDisplay;

	public var button_left:String;
	public var button_right:String;
	public var button_left_obj:DnaButtonObject;
	public var button_right_obj:DnaButtonObject;

	public var fixation:String;
	public var fixation_obj:SpriteObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "dots_left"))
		{
			this.dots_left = cast jsonFile.dots_left;
		}
		if (Reflect.hasField(jsonFile, "dots_right"))
		{
			this.dots_right = cast jsonFile.dots_right;
		}

		if (Reflect.hasField(jsonFile, "button_left"))
		{
			this.button_left = cast jsonFile.button_left;
		}
		if (Reflect.hasField(jsonFile, "button_right"))
		{
			this.button_right = cast jsonFile.button_right;
		}

		if (Reflect.hasField(jsonFile, "fixation"))
		{
			fixation = jsonFile.fixation;
		}
	}
}

class DotsObjectStateHidden implements IState
{
	public var dots_obj:DotsTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		dots_obj.fixation_obj.sprite.alpha = 0;
		dots_obj.button_left_obj.setNextState(new ButtonStateInactive());
		dots_obj.button_right_obj.setNextState(new ButtonStateInactive());
		dots_obj.dots_left_obj.state_machine.setNextState(new DotsStateHidden());
		dots_obj.dots_right_obj.state_machine.setNextState(new DotsStateHidden());
	}

	public function exit():Void {}
}

class DotsObjectStateDisabled implements IState
{
	public var dots_obj:DotsTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		dots_obj.fixation_obj.sprite.alpha = 0;
		dots_obj.button_left_obj.setNextState(new ButtonStateInactive());
		dots_obj.button_right_obj.setNextState(new ButtonStateInactive());

		dots_obj.dots_left_obj.state_machine.setNextState(new DotsStateVisible());
		dots_obj.dots_right_obj.state_machine.setNextState(new DotsStateVisible());
	}

	public function exit():Void {}
}

class DotsObjectStateFixation implements IState
{
	public var dots_obj:DotsTaskObject;
	public var state_machine:IStateMachine;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		dots_obj.button_left_obj.setNextState(new ButtonStateInactive());
		dots_obj.button_right_obj.setNextState(new ButtonStateInactive());

		dots_obj.fixation_obj.sprite.alpha = 1.0;
		dots_obj.dots_left_obj.state_machine.setNextState(new DotsStateHidden());
		dots_obj.dots_right_obj.state_machine.setNextState(new DotsStateHidden());
	}

	public function exit():Void
	{
		dots_obj.fixation_obj.sprite.alpha = 0;
	}
}

class DotsObjectStateNormal implements IState
{
	public var dots_obj:DotsTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		dots_obj.fixation_obj.sprite.alpha = 0;
		dots_obj.button_left_obj.setNextState(new ButtonStateNormal());
		dots_obj.button_right_obj.setNextState(new ButtonStateNormal());

		dots_obj.dots_left_obj.state_machine.setNextState(new DotsStateVisible());
		dots_obj.dots_right_obj.state_machine.setNextState(new DotsStateVisible());
	}

	public function exit():Void {}
}

class DotsObjectStateNoise implements IState
{
	public var dots_obj:DotsTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		dots_obj.fixation_obj.sprite.alpha = 0;
		dots_obj.button_left_obj.setNextState(new ButtonStateNormal());
		dots_obj.button_right_obj.setNextState(new ButtonStateNormal());
		dots_obj.dots_left_obj.state_machine.setNextState(new DotsStateNoise());
		dots_obj.dots_right_obj.state_machine.setNextState(new DotsStateNoise());
	}

	public function exit():Void {}
}

class DotsObjectStateAfterNoise implements IState
{
	public var dots_obj:DotsTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_obj = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		dots_obj.fixation_obj.sprite.alpha = 0;
		dots_obj.button_left_obj.setNextState(new ButtonStateNormal());
		dots_obj.button_right_obj.setNextState(new ButtonStateNormal());

		dots_obj.dots_left_obj.state_machine.setNextState(new DotsStateAfterNoise());
		dots_obj.dots_right_obj.state_machine.setNextState(new DotsStateAfterNoise());
	}

	public function exit():Void {}
}
