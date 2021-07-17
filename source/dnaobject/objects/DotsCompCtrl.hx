package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateHidden;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import dnaobject.objects.DotsTaskObject;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class DotsCompCtrl implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("DotsCompCtrl");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>)
	{
		if (DnaConstants.TASK_ANSWERED_EVENT == event_name)
		{
			if (params == true)
			{
				onCorrect();
			}
			else
			{
				onIncorrect();
			}
		}
	}

	public function loadTrial()
	{
		trial_handler_obj.saveCurrentTrial();
		trial_handler_obj.loadNextTrial();
		if (this.trial_handler_obj.all_trials_done)
		{
			action_fin_obj.startQueue();
		}
	}

	public function onCorrect()
	{
		if (this.onCorrectCallback != null)
		{
			onCorrectCallback();
			return;
		}
	}

	public function onIncorrect()
	{
		if (this.onIncorrectCallback != null)
		{
			onIncorrectCallback();
			return;
		}
	}

	public var onCorrectCallback:Void->Void = null;
	public var onIncorrectCallback:Void->Void = null;

	public var feedbackCallback:(Void->Void) -> Void = null;
	public var state_machine:StateMachineComponent = null;

	override public function onReady()
	{
		super.onReady();

		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_load_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_load));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		trial_handler_obj = cast this.getParent().getObjectByName(getNestedObjectName(trial_handler));

		dots_disp_obj = cast this.getParent().getObjectByName((dots_disp));

		getParent().eventManager.addSubscriberForEvent(this, DnaConstants.TASK_ANSWERED_EVENT);
		trial_handler_obj.loadNextTrial();

		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(cast state_machine);
		state_machine.setNextState(new InitialState());
	}

	public var action_load:String;
	public var action_fin:String;
	public var action_init:String;
	public var trial_handler:String;
	public var dots_disp:String;
	public var action_load_obj:ActionHandlerObject;
	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var trial_handler_obj:TrialHandlerObject;
	public var dots_disp_obj:DotsTaskObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "action_load"))
		{
			action_load = jsonFile.action_load;
		}
		if (Reflect.hasField(jsonFile, "action_init"))
		{
			action_init = jsonFile.action_init;
		}
		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			action_fin = jsonFile.action_fin;
		}
		if (Reflect.hasField(jsonFile, "trial_handler"))
		{
			trial_handler = jsonFile.trial_handler;
		}
		if (Reflect.hasField(jsonFile, "dots_disp"))
		{
			dots_disp = jsonFile.dots_disp;
		}
	}
}

class InitialState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			state_machine.setNextState(new FixationState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("initial State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateHidden());

		dots_ctrl.dots_disp_obj.answer = null;

		var rand = new FlxRandom();
		timer.start(rand.float(1, 2));
		// dots_ctrl.loadTrial();
	}

	public function exit():Void {}
}

class FixationState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			state_machine.setNextState(new VisibleState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("fixation State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateFixation());
		timer.start(0.5);
	}

	public function exit():Void {}
}

class VisibleState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function onAnswered()
	{
		state_machine.setNextState(new FeedbackState());
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			state_machine.setNextState(new NoiseState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("visible State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateNormal());
		timer.start(0.5);
		dots_ctrl.onCorrectCallback = this.onAnswered;
		dots_ctrl.onIncorrectCallback = this.onAnswered;
	}

	public function exit():Void
	{
		dots_ctrl.onCorrectCallback = null;
		dots_ctrl.onIncorrectCallback = null;
	}
}

class NoiseState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			state_machine.setNextState(new AfterNoiseState());
		}
	}

	public function onAnswered()
	{
		state_machine.setNextState(new FeedbackState());
	}

	public function enter():Void
	{
		trace("noise State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateNoise());
		timer.start(0.1);
		dots_ctrl.onCorrectCallback = this.onAnswered;
		dots_ctrl.onIncorrectCallback = this.onAnswered;
	}

	public function exit():Void
	{
		dots_ctrl.onCorrectCallback = null;
		dots_ctrl.onIncorrectCallback = null;
	}
}

class AfterNoiseState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function onAnswered()
	{
		state_machine.setNextState(new FeedbackState());
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			state_machine.setNextState(new FeedbackState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("afternoise State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateAfterNoise());
		timer.start(0.5);
		dots_ctrl.onCorrectCallback = this.onAnswered;
		dots_ctrl.onIncorrectCallback = this.onAnswered;
	}

	public function exit():Void
	{
		dots_ctrl.onCorrectCallback = null;
		dots_ctrl.onIncorrectCallback = null;
	}
}

class FeedbackState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function onFeedbackFinished()
	{
		state_machine.setNextState(new InitialState());
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("feedback State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateHidden());
		if (dots_ctrl.feedbackCallback != null)
		{
			dots_ctrl.feedbackCallback(onFeedbackFinished);
		}
		else
		{
			// if we do not have feedback we are in the "real" mode so we load the next trial.
			dots_ctrl.loadTrial();
			onFeedbackFinished();
		}
	}

	public function exit():Void {}
}
