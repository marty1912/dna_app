package dnaobject.objects.dotcompstates.numerical_no_time;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.DotsTaskObject;
import dnaobject.objects.dotcompstates.numerical.NumInitialState;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class AfterFeedback implements IState
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
		// we use a timer for a short time to get over the state switch..
		if (timer.finished)
		{
			state_machine.setNextState(new NumInitialState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("initial State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateHidden());

		dots_ctrl.dots_disp_obj.answer = null;

		timer.start(0.2);
	}

	public function exit():Void {}
}
