package dnaobject.objects.flanker_task_states.real_task;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.flanker_task_states.*;

class FlankerInitialState implements IState
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

	public function enter():Void
	{
		trace("flanker initial state enter!");
		this.flanker_ctrl.btn_left_obj.setNextState(new ButtonStateInactive());
		this.flanker_ctrl.btn_right_obj.setNextState(new ButtonStateInactive());
		flanker_ctrl.trialhandler_obj.loadNextTrial();
		this.state_machine.setNextState(new FlankerStateLoopStart());
	}

	public function exit():Void {}
}
