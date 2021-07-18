package dnaobject.objects.dotcompstates.no_time;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.DotsTaskObject;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class Feedback implements IState
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
		state_machine.setNextState(new AfterFeedback());
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("feedback State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateHidden());
		if (dots_ctrl.feedbackCallback != null)
		{
			// this means we are in practice mode.
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
