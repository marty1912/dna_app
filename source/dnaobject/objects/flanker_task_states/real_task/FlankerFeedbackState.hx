package dnaobject.objects.flanker_task_states.real_task;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.FlankerMachine.FlankerMachineEmpty;
import dnaobject.objects.FlankerMachine.FlankerMachineFixation;
import dnaobject.objects.FlankerMachine.FlankerMachinePresent;
import dnaobject.objects.flanker_task_states.*;
import flixel.util.FlxTimer;

class FlankerFeedbackState implements IState
{
	public var flanker_ctrl:FlankerTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		flanker_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function onFeedbackFinished() {}

	public function setDots(path:String) {}

	public var timer:FlxTimer = new FlxTimer();

	public function onFeedbackDone()
	{
		flanker_ctrl.trialhandler_obj.loadNextTrial();
		if (flanker_ctrl.trialhandler_obj.all_trials_done)
		{
			flanker_ctrl.action_fin_obj.startQueue();
			return;
		}
		this.state_machine.setNextState(new FlankerStateLoopStart());
		return;
	}

	public function enter():Void
	{
		trace("flanker feedback state enter!");
		this.flanker_ctrl.flanker_obj.state_machine.setNextState(new FlankerMachineEmpty());
		if (!flanker_ctrl.feedback)
		{
			var timer:FlxTimer = new FlxTimer();
			// short time interval so we can see the helix rotate.
			timer.start(2, function(timer:FlxTimer)
			{
				this.onFeedbackDone();
				return;
			});
			return;
		}
		if (flanker_ctrl.correct)
		{
			flanker_ctrl.action_correct_obj.startQueue(this.onFeedbackDone);
		}
		else
		{
			flanker_ctrl.action_incorrect_obj.startQueue(this.onFeedbackDone);
		}
	}

	public function exit():Void {}
}
