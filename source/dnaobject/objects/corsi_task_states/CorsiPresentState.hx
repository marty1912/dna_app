package dnaobject.objects.corsi_task_states;

import dnaobject.components.TutorialFingerComponent;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import dnaobject.objects.corsi_task_states.*;
import flixel.FlxG;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalMouseWheel;
import flixel.math.FlxPoint;

class CorsiPresentState implements IState
{
	public var corsi_ctrl:CorsiTaskObject;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_ctrl = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function onDone()
	{
		trace("present done");
		this.state_machine.setNextState(new CorsiAnswerState());
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("corsi present state enter!");
		this.corsi_ctrl.corsi_obj.finger_obj.sprite.alpha = 1;
		this.corsi_ctrl.corsi_obj.presentSequence(this.corsi_ctrl.sequence, onDone);
	}

	public function exit():Void
	{
		var tutFinger:TutorialFingerComponent = cast this.corsi_ctrl.corsi_obj.finger_obj.getComponentByType("TutorialFingerComponent");
		tutFinger.moveToPos(FlxPoint.get(FlxG.width / 2, FlxG.height), function()
		{
			this.corsi_ctrl.corsi_obj.finger_obj.sprite.alpha = 0;
		});
	}
}
