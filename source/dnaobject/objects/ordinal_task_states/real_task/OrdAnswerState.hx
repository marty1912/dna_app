package dnaobject.objects.ordinal_task_states.real_task;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateHidden;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateVisible;
import dnaobject.objects.ordinal_task_states.*;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class OrdAnswerState implements IState
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

	public function onAnswered()
	{
		state_machine.setNextState(new OrdFeedbackState());
	}

	public function enter():Void
	{
		trace("Answer State enter");
		ord_ctrl.ord_task_obj.state_machine.setNextState(new OrdinalObjectStateVisible());

		var rand = new FlxRandom();
		timer.start(rand.float(2, 3));

		ord_ctrl.onCorrectCallback = this.onAnswered;
		ord_ctrl.onIncorrectCallback = this.onAnswered;
		// dots_ctrl.loadTrial();
	}

	public function exit():Void {}
}
