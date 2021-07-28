package dnaobject.objects.corsi_task_states;

import Assertion.assert;
import dnaobject.components.TutorialFingerComponent;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.*;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import dnaobject.objects.corsi_task_states.*;
import flixel.FlxG;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalMouseWheel;
import flixel.math.FlxPoint;

class CorsiAnswerState implements IState
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

	public var pressed_seq:Array<DnaButtonObject> = new Array<DnaButtonObject>();

	public function saveTrial()
	{
		trace("save task.");
	}

	public function endTask()
	{
		trace("End task.");
		assert(false);
	}

	public function increaseLevel()
	{
		trace("increase level!");
		// all correct! here we increase the difficulty
		if (corsi_ctrl.currentSequenceLen >= corsi_ctrl.maxSequenceLen)
		{
			// max out
			saveTrial();
			endTask();
			return;
		}
		corsi_ctrl.currentSequenceLen++;
		corsi_ctrl.correctTrials = 0;
		corsi_ctrl.remainingTrials = corsi_ctrl.trialsPerLen;
	}

	public function onSequenceCorrect()
	{
		// sequence correct!
		corsi_ctrl.correctTrials++;
		corsi_ctrl.remainingTrials--;
		if (corsi_ctrl.correctTrials >= corsi_ctrl.minCorrect)
		{
			increaseLevel();
		}

		this.state_machine.setNextState(new CorsiInitialState());
		return;
	}

	public function onSequenceInCorrect()
	{
		corsi_ctrl.remainingTrials--;
		if (corsi_ctrl.remainingTrials <= 0 || corsi_ctrl.remainingTrials + corsi_ctrl.correctTrials < corsi_ctrl.minCorrect)
		{
			// error out
			saveTrial();
			endTask();
			return;
		}

		this.state_machine.setNextState(new CorsiInitialState());
		return;
	}

	public function onButtonPress(btn:DnaButtonObject)
	{
		pressed_seq.push(btn);
		var correct_seq = corsi_ctrl.sequence;
		var backwards = corsi_ctrl.backwards;
		if (corsi_ctrl.answerCorrectSoFar(correct_seq, pressed_seq, backwards))
		{
			if (correct_seq.length == pressed_seq.length)
			{
				onSequenceCorrect();
			}
		}
		else
		{
			onSequenceInCorrect();
		}
	}

	public function setDots(path:String) {}

	public function enter():Void
	{
		trace("corsi answer state enter!");
		for (btn in this.corsi_ctrl.corsi_obj.buttons)
		{
			btn.onPressCallback = this.onButtonPress.bind(btn);
			var comp = DnaComponentFactory.create("UserButtonComponent");
			btn.addComponent(comp);
		}
	}

	public function exit():Void
	{
		for (btn in this.corsi_ctrl.corsi_obj.buttons)
		{
			btn.onPressCallback = null;
			btn.removeComponentByType("UserButtonComponent");
			btn.setNextState(new ButtonStateNormal());
		}
	}
}
