package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
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
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;
import haxe.Timer;

/**
 * class OrdinalTaskHandlerObject
 * this class represents our OrdinalTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class OrdinalTaskHandlerObject implements DnaObject implements TaskObject implements DnaEventSubscriber extends DnaObjectBase
{
	static final EVT_ANSWER_IN_ORDER:String = "ANSWER_IN_ORDER";
	static final EVT_ANSWER_MIXED_ORDER:String = "ANSWER_MIXED_ORDER";

	/**
	 * in this function we obtain our answer (which number has been selected?)
	 * @param event_name 
	 */
	public function getNotified(event_name:String)
	{
		if (event_name == EVT_ANSWER_IN_ORDER)
		{
			this.answer = "IN_ORDER";
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
		}
		else if (event_name == EVT_ANSWER_MIXED_ORDER)
		{
			this.answer = "MIXED_ORDER";
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
		}
		else if (event_name == DnaConstants.EVT_TASK_TIMEOUT)
		{
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
		}
	}

	/*
	 * isCorrect() checks if the task was answered correctly 
	 * 
	 */
	public function isCorrect():String
	{
		if (getAnswer() == getSolution())
		{
			return DnaConstants.TASK_CORRECT;
		}
		else if (this.getAnswer() == "")
		{
			return DnaConstants.TASK_TIMED_OUT_FEEDBACK;
		}

		return DnaConstants.TASK_INCORRECT;
	}

	/**
	 * getData - this function collects the data we want to have from the OrdinalTaskHandler object.
	 * @return Dynamic - the
	 */
	public function getData():Dynamic
	{
		var current_trial:Dynamic = {
			triplet: getTriplet(),
			answer: getAnswer(),
			solution: getSolution()
		};

		return current_trial;
	}

	public var solution:String;

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
	public function getSolution():String
	{
		return solution;
	}

	/**
	 * returns the problem string that the user sees
	 * @return String
	 */
	public function getTriplet():String
	{
		var left_textbox:ITextBox = cast this.getParent().getObjectByName(target_triplet);
		var left_str:String = left_textbox.getText();
		return left_str;
	}

	/**
	 * setParams - this lets us set the parameters for the stimulus
	 * @param params - a dynamic object with fields: zero, ref, max and target
	 */
	public function setParams(params:Dynamic):Void
	{
		this.answer = "";
		var left_textbox:ITextBox = cast this.getParent().getObjectByName(target_triplet);
		left_textbox.setText(params.triplet, true);
		solution = params.solution;
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('OrdinalTaskHandlerObject');
	}

	public var target_triplet:String;

	/**
	 * register events in here
	 */
	override public function registerEvents()
	{
		trace(this.getParent());
		this.getParent().eventManager.addSubscriberForEvent(this, EVT_ANSWER_IN_ORDER);
		this.getParent().eventManager.addSubscriberForEvent(this, EVT_ANSWER_MIXED_ORDER);
		this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.EVT_TASK_TIMEOUT);
	}

	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target_triplet"))
		{
			this.target_triplet = jsonFile.target_triplet;
		}

		super.fromFile(jsonFile);
		return;
	}
}
