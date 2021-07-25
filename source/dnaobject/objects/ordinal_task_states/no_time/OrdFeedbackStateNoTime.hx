package dnaobject.objects.ordinal_task_states.no_time;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateHidden;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateInactive;
import dnaobject.objects.ordinal_task_states.*;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class OrdFeedbackStateNoTime implements IState
{
	public var ord_ctrl:OrdinalTaskCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		ord_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished) {}
	}

	public function setDots(path:String) {}

	public function onFeedbackFinished()
	{
		trace("feedback done.");
		state_machine.setNextState(new OrdAfterFeedbackStateNoTime());
	}

	public function enter():Void
	{
		trace("Feedback State enter");
		ord_ctrl.ord_task_obj.state_machine.setNextState(new OrdinalObjectStateInactive());

		var rand = new FlxRandom();
		timer.start(rand.float(2, 3));

		if (ord_ctrl.feedbackCallback != null)
		{
			ord_ctrl.feedbackCallback(onFeedbackFinished);
		}
		else
		{
			// if we do not have feedback we are in the "real" mode so we load the next trial.
			ord_ctrl.loadTrial();
			onFeedbackFinished();
		}

		// dots_ctrl.loadTrial();
	}

	public function exit():Void {}
}
