package dnaobject.objects.flanker_task_states.real_task;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.FlankerMachine.FlankerMachineEmpty;
import dnaobject.objects.FlankerMachine.FlankerMachineFixation;
import dnaobject.objects.flanker_task_states.*;
import flixel.util.FlxTimer;

class FlankerFixationState implements IState
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
			state_machine.setNextState(new FlankerPresentState());
			return;
		}
	}

	public function onFeedbackFinished() {}

	public function setDots(path:String) {}

	public var timer:FlxTimer = new FlxTimer();

	public function enter():Void
	{
		trace("flanker loop start state enter!");
		this.flanker_ctrl.flanker_obj.state_machine.setNextState(new FlankerMachineFixation());
		timer.start(1);
	}

	public function exit():Void {}
}
