
package dnaobject.objects.dotcompstates.real_task;
import dnaobject.objects.DotsTaskObject.DotsObjectStateNoise;
import dnaobject.interfaces.IState;

import dnaobject.interfaces.IStateMachine;
import flixel.util.FlxTimer;

import dnaobject.objects.dotcompstates.real_task.*;
import dnaobject.objects.*;

class NoiseState implements IState
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

	public function update(elapsed:Float):Void
	{
		if (timer.finished)
		{
			state_machine.setNextState(new AfterNoiseState());
		}
	}

	public function onAnswered()
	{
		state_machine.setNextState(new FeedbackState());
	}

	public function enter():Void
	{
		trace("noise State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateNoise());
		timer.start(0.1);
		dots_ctrl.onCorrectCallback = this.onAnswered;
		dots_ctrl.onIncorrectCallback = this.onAnswered;
	}

	public function exit():Void
	{
		dots_ctrl.onCorrectCallback = null;
		dots_ctrl.onIncorrectCallback = null;
	}
}
