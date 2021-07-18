package dnaobject.objects.dotcompstates.no_time;

import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.DotsTaskObject;
import dnaobject.objects.dotcompstates.no_time.Feedback;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class Initial implements IState
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

	public function update(elapsed:Float):Void {}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("initial State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateHidden());

		dots_ctrl.dots_disp_obj.answer = null;

		state_machine.setNextState(new ShowStim());
	}

	public function exit():Void {}
}
