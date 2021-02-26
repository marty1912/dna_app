package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnaobject.DnaObject;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import dnaobject.proto.archetypes.TaskTrials;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;

/**
 * class SymbolicNumberComparisonTaskHandlerObject
 * this class represents our SymbolicNumberComparisonTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class SymbolicNumberComparisonTaskHandlerObject implements DnaObject implements TaskObject implements DnaEventSubscriber extends DnaObjectBase
{
	static final EVENTNAME_LEFT:String = "LEFT_NUM_SELECTED";
	static final EVENTNAME_RIGHT:String = "RIGHT_NUM_SELECTED";

	/**
	 * in this function we obtain our answer (which number has been selected?)
	 * @param event_name 
	 */
	public function getNotified(event_name:String)
	{
		if (event_name == EVENTNAME_LEFT)
		{
			this.answer = getLeftNum();
			DnaEventManager.instance.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
		}
		else if (event_name == EVENTNAME_RIGHT)
		{
			this.answer = getRightNum();
			DnaEventManager.instance.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
		}
	}

	/**
	 * isCorrect() checks if the task was answered correctly 
	 */
	public function isCorrect():Bool
	{
		if (Std.parseInt(getAnswer()) == getSolution())
		{
			return true;
		}

		return false;
	}

	/**
	 * getData - this function collects the data we want to have from the SymbolicNumberComparisonTaskHandler object.
	 * @return Dynamic - the
	 */
	public function getData():Dynamic
	{
		var current_trial:Dynamic = {
			left_num: getLeftNum(),
			right_num: getRightNum(),
			answer: getAnswer(),
			solution: getSolution()
		};

		return current_trial;
	}

	public var solution:Int;

	public var answer:String = "";

	/**
	 * returns the chosen answer (the answer member variable is set based on the event we receive)
	 */
	public function getAnswer():String
	{
		return this.answer;
	}

	/**
	 * returns the answer string that the user gave
	 * @return String
	 */
	public function getSolution():Int
	{
		return solution;
	}

	/**
	 * returns the problem string that the user gave
	 * @return String
	 */
	public function getLeftNum():String
	{
		var left_textbox:ITextBox = cast this.getParent().getObjectByName(target_num_left);
		var left_str:String = left_textbox.getText();
		return left_str;
	}

	/**
	 * returns the problem string that the user gave
	 * @return String
	 */
	public function getRightNum():String
	{
		var right_textbox:ITextBox = cast this.getParent().getObjectByName(target_num_right);
		var right_str:String = right_textbox.getText();
		return right_str;
	}

	/**
	 * setParams - this lets us set the parameters for the stimulus
	 * @param params - a dynamic object with fields: zero, ref, max and target
	 */
	public function setParams(params:Dynamic):Void
	{
		this.answer = "";
		var left_textbox:ITextBox = cast this.getParent().getObjectByName(target_num_left);
		left_textbox.setText(params.num_left, true);
		solution = params.solution;
		var right_textbox:ITextBox = cast this.getParent().getObjectByName(target_num_right);
		right_textbox.setText(params.num_right, true);
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('SymbolicNumberComparisonTaskHandlerObject');
		DnaEventManager.instance.addSubscriberForEvent(this, EVENTNAME_LEFT);
		DnaEventManager.instance.addSubscriberForEvent(this, EVENTNAME_RIGHT);
	}

	public var target_num_left:String;
	public var target_num_right:String;

	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target_num_left"))
		{
			this.target_num_left = jsonFile.target_num_left;
		}
		if (Reflect.hasField(jsonFile, "target_num_right"))
		{
			this.target_num_right = jsonFile.target_num_right;
		}
		super.fromFile(jsonFile);
		return;
	}
}
