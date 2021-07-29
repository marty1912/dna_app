package dnaobject.objects.corsi_task_states;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.CorsiMachineDome.CorsiDomeCorrect;
import dnaobject.objects.CorsiMachineDome.CorsiDomeDefault;
import dnaobject.objects.corsi_task_states.*;

class CorsiGoState implements IState
{
	public var corsi_ctrl:CorsiTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var time:Float = 0;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_ctrl = cast comp.getParent();
	}

	public var moving:Bool = false;

	public function update(elapsed:Float):Void {}

	public function onFeedbackFinished() {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("corsi FeedbackContinue state enter!");
		this.corsi_ctrl.action_go_obj.startQueue(function()
		{
			this.state_machine.setNextState(new CorsiAnswerState());
		});
		// corsi_ctrl.corsi_obj.createButtons();
	}

	public function exit():Void {}
}
