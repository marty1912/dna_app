
package dnaobject.objects.dotcompstates.real_task;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import flixel.util.FlxTimer;

import dnaobject.objects.dotcompstates.real_task.*;
import dnaobject.objects.*;

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

		dots_ctrl.timer_obj.stopTime();

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