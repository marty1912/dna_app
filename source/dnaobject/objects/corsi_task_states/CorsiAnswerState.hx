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
import haxe.Timer;

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
		corsi_ctrl.trialhandler_obj.loadNextTrial();
		this.corsi_ctrl.trialhandler_obj.saveCurrentTrial();
	}

	public function endTask()
	{
		trace("End task.");
		state_machine.setNextState(new CorsiFeedbackStateErrorOut());
	}

	public function increaseLevel()
	{
		trace("increase level!");
		// all correct! here we increase the difficulty
		if (corsi_ctrl.currentSequenceLen >= corsi_ctrl.maxSequenceLen)
		{
			// max out
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
		saveTrial();
		corsi_ctrl.correctTrials++;
		corsi_ctrl.remainingTrials--;
		if (corsi_ctrl.correctTrials >= corsi_ctrl.minCorrect)
		{
			increaseLevel();
		}

		this.state_machine.setNextState(new CorsiFeedbackStateContinue());
		return;
	}

	public function onSequenceInCorrect()
	{
		saveTrial();
		corsi_ctrl.remainingTrials--;
		if (corsi_ctrl.currentSequenceLen == corsi_ctrl.minSequenceLen)
		{
			// if somebody does not get the initial sequence len correct it is likely that the task was simply not understood..
			corsi_ctrl.remainingTrials++;
		}
		if (corsi_ctrl.remainingTrials <= 0 || corsi_ctrl.remainingTrials + corsi_ctrl.correctTrials < corsi_ctrl.minCorrect)
		{
			// error out
			endTask();
			return;
		}

		this.state_machine.setNextState(new CorsiFeedbackStateError());
		return;
	}

	public var correct(get, null):Bool;

	public function get_correct():Bool
	{
		var correct_seq = corsi_ctrl.sequence;
		var backwards = corsi_ctrl.backwards;
		if (corsi_ctrl.answerCorrectSoFar(correct_seq, pressed_seq, backwards))
		{
			if (correct_seq.length == pressed_seq.length)
			{
				return true;
			}
		}
		else
		{
			return false;
		}
		return null;
	}

	public function onButtonPress(btn:DnaButtonObject)
	{
		pressed_seq.push(btn);
		if (correct == true)
		{
			onSequenceCorrect();
			return;
		}
		else if (correct == false)
		{
			onSequenceInCorrect();
			return;
		}
		// third case: correct is null. therefore we do not do anything yet.
	}

	public var time(get, never):Float;

	public function get_time():Float
	{
		assert(timeStart != null);
		return Timer.stamp() - timeStart;
	}

	public var timeStart:Float;

	public function setDots(path:String) {}

	public function enter():Void
	{
		timeStart = Timer.stamp();
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
