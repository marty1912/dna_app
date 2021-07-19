

package dnaobject.objects.dotcompstates.real_task;
import dnaobject.objects.DotsTaskObject.DotsObjectStateFixation;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import flixel.util.FlxTimer;
import dnaobject.objects.dotcompstates.real_task.*;
import dnaobject.objects.*;

class FixationState implements IState
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
			state_machine.setNextState(new VisibleState());
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("fixation State enter");
		dots_ctrl.dots_disp_obj.state_machine.setNextState(new DotsObjectStateFixation());
		timer.start(0.5);
	}

	public function exit():Void {}
}