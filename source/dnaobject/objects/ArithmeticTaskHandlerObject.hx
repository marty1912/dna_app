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
 * class ArithmeticTaskHandlerObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class ArithmeticTaskHandlerObject implements DnaObject implements TaskObject extends DnaObjectBase
{
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
		problem_textbox.setText(params.problem, this.use_literal_text);
		solution = params.solution;
		var answer_textbox:ITextBox = cast this.getParent().getObjectByName(target_answer);
		answer_textbox.setText("", true);
		if (params.audio != null)
		{
			ActionPlaySoundComponent.stopAllSounds();
			ActionPlaySoundComponent.playSound(params.audio);
		}
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
		super('ArithmeticTaskHandlerObject');
	}

	public var target_problem:String;
	public var target_answer:String;
	public var use_literal_text:Bool = true;

	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
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
