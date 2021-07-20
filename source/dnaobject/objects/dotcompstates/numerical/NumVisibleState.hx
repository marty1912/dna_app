package dnaobject.objects.dotcompstates.numerical;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.DotsTaskObject.DotsObjectStateNormal;
import dnaobject.objects.dotcompstates.numerical.*;
import flixel.util.FlxTimer;

class NumVisibleState implements IState
{
	public var dots_ctrl:DotsCompCtrl;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;
	public var timer:FlxTimer = new FlxTimer();

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_ctrl = cast comp.getParent();
	}

	public function onAnswered()
	{
		state_machine.setNextState(new NumFeedbackState());
	}

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			// state_machine.setNextState(new NumFeedbackState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("numerical visible State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateNormal());
		timer.start(0.5);
		dots_ctrl.timer_obj.resetTime();
		dots_ctrl.onCorrectCallback = this.onAnswered;
		dots_ctrl.onIncorrectCallback = this.onAnswered;
	}

	public function exit():Void
	{
		dots_ctrl.timer_obj.stopTime();
		dots_ctrl.onCorrectCallback = null;
		dots_ctrl.onIncorrectCallback = null;
	}
}
