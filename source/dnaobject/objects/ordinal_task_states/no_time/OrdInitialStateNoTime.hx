package dnaobject.objects.ordinal_task_states.no_time;

import Assertion.assert;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateHidden;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateInactive;
import dnaobject.objects.ordinal_task_states.*;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class OrdInitialStateNoTime implements IState
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

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		ord_ctrl.ord_task_obj.state_machine.setNextState(new OrdinalObjectStateInactive());

		state_machine.setNextState(new OrdAnswerStateNoTime());
	}

	public function exit():Void {}
}
