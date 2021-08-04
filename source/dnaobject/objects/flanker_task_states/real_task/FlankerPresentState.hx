package dnaobject.objects.flanker_task_states.real_task;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.CorsiMachineDome.CorsiDomeRotateLeft;
import dnaobject.objects.CorsiMachineDome.CorsiDomeRotateRight;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.FlankerMachine.FlankerMachineEmpty;
import dnaobject.objects.FlankerMachine.FlankerMachineFixation;
import dnaobject.objects.FlankerMachine.FlankerMachinePresent;
import dnaobject.objects.flanker_task_states.*;
import flixel.util.FlxTimer;
import haxe.Timer;

class FlankerPresentState implements IState
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

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			return;
		}
	}

	public function onFeedbackFinished() {}

	public function setDots(path:String) {}

	public var time(get, never):Float;

	public function get_time():Float
	{
		return this.time_start - this.time_end;
	}

	public var time_start:Float;
	public var time_end:Float;
	public var timer:FlxTimer = new FlxTimer();

	public function onAnswerTask(ans:String)
	{
		trace("answered: ", ans);
		this.flanker_ctrl.answer = ans;
		time_end = Timer.stamp();
		this.flanker_ctrl.time = time;
		// we only save the current trial if we are in the real task (no feedback) or if it is correct
		if (!flanker_ctrl.feedback || flanker_ctrl.correct)
		{
			this.flanker_ctrl.trialhandler_obj.saveCurrentTrial();
		}
		if (ans == "RIGHT")
		{
			this.flanker_ctrl.flanker_obj.dome_obj.state_machine.setNextState(new CorsiDomeRotateRight());
		}
		else
		{
			this.flanker_ctrl.flanker_obj.dome_obj.state_machine.setNextState(new CorsiDomeRotateLeft());
		}
		state_machine.setNextState(new FlankerFeedbackState());
	}

	public function enter():Void
	{
		trace("flanker loop start state enter!");
		this.flanker_ctrl.flanker_obj.state_machine.setNextState(new FlankerMachinePresent());

		this.flanker_ctrl.btn_left_obj.setNextState(new ButtonStateNormal());
		this.flanker_ctrl.btn_left_obj.onPressCallback = onAnswerTask.bind("LEFT");

		this.flanker_ctrl.btn_right_obj.setNextState(new ButtonStateNormal());
		this.flanker_ctrl.btn_right_obj.onPressCallback = onAnswerTask.bind("RIGHT");
		time_start = Timer.stamp();
	}

	public function exit():Void
	{
		this.flanker_ctrl.btn_left_obj.setNextState(new ButtonStateInactive());
		this.flanker_ctrl.btn_right_obj.setNextState(new ButtonStateInactive());
	}
}
