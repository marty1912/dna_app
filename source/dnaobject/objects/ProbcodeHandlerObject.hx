package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
import dnaobject.components.ActionPlaySoundComponent;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;

/**
 * class ProbcodeHandlerObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class ProbcodeHandlerObject implements DnaObject implements TaskObject implements DnaEventSubscriber extends DnaObjectBase
{

	public var target_problem:String;
	public var target_repeat_question:String;
	public var target_answer:String;
	public var use_literal_text:Bool = true;
	/**
	 * getData - this function collects the data we want to have from the ArithmeticTaskHandler object.
	 * @return Dynamic - the
	 */
	public function getData():Dynamic
	{
		var current_trial:Dynamic = {
			problem: getProblem(),
			answer: getAnswer(),
			solution: getSolution()
		};

		return current_trial;
	}

	public var accept_button_obj:DnaButtonObject;
	public var accept_button:String = "AcceptButton";

	override public function onReady()
	{
		accept_button_obj = cast this.getParent().getObjectByName(accept_button);
		accept_button_obj.setNextState(new ButtonStateInactive());
		for (i in 0...10)
		{
			this.getParent().eventManager.addSubscriberForEvent(this, "KEY_" + Std.string(i));
		}
		this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.KEY_BACKSPACE);
	}

	public function getNotified(event_key:String, params:Any = null):Void
	{
		if (this.getAnswer() != "")
		{
			accept_button_obj.setNextState(new ButtonStateNormal());
		}
		else
		{
			accept_button_obj.setNextState(new ButtonStateInactive());
		}
	}

	public var solution:Int;

	/**
	 * returns the answer string that the user gave
	 * @return String
	 */
	public function getSolution():Int
	{
		return solution;
	}

	/**
	 * returns the answer string that the user gave
	 * @return String
	 */
	public function getAnswer():String
	{
		var answer_textbox:ITextBox = cast this.getParent().getObjectByName(target_answer);
		var answer_str:String = answer_textbox.getText();
		return answer_str;
	}

	/**
	 * returns the problem string that the user gave
	 * @return String
	 */
	public function getProblem():String
	{
		var problem_textbox:ITextBox = cast this.getParent().getObjectByName(target_problem);
		var problem_str:String = problem_textbox.getText();
		return problem_str;
	}

	/**
	 * setParams - this lets us set the parameters for the stimulus
	 * @param params - a dynamic object with fields: zero, ref, max and target
	 */
	public function setParams(params:Dynamic):Void
	{
		var problem_textbox:ITextBox = cast this.getParent().getObjectByName(target_problem);
		var repeat_question_textbox:ITextBox = cast this.getParent().getObjectByName(target_repeat_question);
		problem_textbox.setText(params.problem, this.use_literal_text);
		repeat_question_textbox.setText("",true);
		// start textbox.
		this.getParent().eventManager.broadcastEvent("KeyboardButtons_INACTIVE");
		problem_textbox.onFinCallback = function()
		{
			trace("params:",params);
			repeat_question_textbox.setText(params.repeat_question,this.use_literal_text);
			repeat_question_textbox.start();
			this.getParent().eventManager.broadcastEvent("KeyboardButtons_NORMAL");
		};
		problem_textbox.start();

		solution = params.solution;
		var answer_textbox:ITextBox = cast this.getParent().getObjectByName(target_answer);
		answer_textbox.setText("", true);
		
		accept_button_obj.setNextState(new ButtonStateInactive());
	}

	/**
	 * checks if the task was answered correctly
	 */
	public function isCorrect():String
	{
		var answer:String = getAnswer();
		var solution:Int = getSolution();
		/*
			if (answer == "")
			{
				return DnaConstants.TASK_TIMED_OUT_FEEDBACK;
			}
		 */
		if (Std.parseInt(answer) == solution)
		{
			return DnaConstants.TASK_CORRECT;
		}
		else
		{
			return DnaConstants.TASK_INCORRECT;
		}
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('ProbcodeHandlerObject');
	}


	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target_repeat_question"))
		{
			this.target_repeat_question= jsonFile.target_repeat_question;
		}
		if (Reflect.hasField(jsonFile, "target_problem"))
		{
			this.target_problem = jsonFile.target_problem;
		}
		if (Reflect.hasField(jsonFile, "target_answer"))
		{
			this.target_answer = jsonFile.target_answer;
		}
		if (Reflect.hasField(jsonFile, "use_literal_text"))
		{
			this.use_literal_text = jsonFile.use_literal_text;
		}
		super.fromFile(jsonFile);
		return;
	}
}
