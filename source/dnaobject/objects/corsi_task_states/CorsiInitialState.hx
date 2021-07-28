package dnaobject.objects.corsi_task_states;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import dnaobject.objects.corsi_task_states.*;

class CorsiInitialState implements IState
{
	public var corsi_ctrl:CorsiTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function onFeedbackFinished() {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("corsi initial state enter!");
		corsi_ctrl.corsi_obj.createButtons();
		corsi_ctrl.sequence = corsi_ctrl.corsi_obj.generateSequence(corsi_ctrl.currentSequenceLen);
		this.state_machine.setNextState(new CorsiPresentState());
	}

	public function exit():Void {}
}
