package dnaobject.objects.dotcompstates.numerical_no_time;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import dnaobject.objects.dotcompstates.numerical_no_time.*;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class NumInitialState implements IState
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
			state_machine.setNextState(new NumVisibleState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("numerical_no_time initial State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateHidden());

		dots_ctrl.dots_disp_obj.answer = null;

		var rand = new FlxRandom();
		timer.start(rand.float(1, 2));
		// dots_ctrl.loadTrial();
	}

	public function exit():Void {}
}
