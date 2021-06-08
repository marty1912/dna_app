package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
import dnaobject.interfaces.IResourcePath;
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
 * class FeedbackTaskHandlerObject
 * this class represents our FeedbackTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class FeedbackTaskHandlerObject implements DnaObject implements TaskObject implements DnaEventSubscriber extends DnaObjectBase
{
	static final EVT_FEEDBACK_GIVEN:String = "FEEDBACK_PRESSED";
	static final EVT_PLAY_GREEN:String = "GREEN_PLAY";
	static final EVT_PLAY_YELLOW:String = "YELLOW_PLAY";
	static final EVT_PLAY_ORANGE:String = "ORANGE_PLAY";
	static final EVT_PLAY_RED:String = "RED_PLAY";
	static final GREEN:String = "GREEN";
	static final YELLOW:String = "YELLOW";
	static final ORANGE:String = "ORANGE";
	static final RED:String = "RED";

	/**
	 * in this function we obtain our answer (which number has been selected?)
	 * @param event_name 
	 */
	public function getNotified(event_name:String, params:Any = null)
	{
		if (event_name == EVT_FEEDBACK_GIVEN)
		{
			this.answer = params;

			var srt:ITextBox = cast this.getParent().getObjectByName(target_srt);
			srt.setText(feedbacks_map[this.answer].srt);
			var audio:IResourcePath = cast this.getParent().getObjectByName(target_audio);
			audio.setResource(feedbacks_map[this.answer].audio);

			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
			this.getParent().eventManager.broadcastEvent(feedbacks_map[this.answer].event_name);
		}
		else if (event_name == DnaConstants.EVT_TASK_TIMEOUT)
		{
			this.getParent().eventManager.broadcastEvent(DnaConstants.TASK_ANSWERED_EVENT);
		}
	}

	/*
	 * isCorrect() checks if the task was answered correctly 
	 * not applicable here.
	 * 
	 */
	public function isCorrect():String
	{
		// not applicable here. so we just say every answer is correct.
		return DnaConstants.TASK_CORRECT;
	}

	/**
	 * getData - this function collects the data we want to have from the FeedbackTaskHandler object.
	 * @return Dynamic - the
	 */
	public function getData():Dynamic
	{
		var current_trial:Dynamic = {
			question: getQuestion(),
			answer: getAnswer()
		};

		return current_trial;
	}

	public var answer:String = "";

	public function getQuestion()
	{
		var textbox:ITextBox = cast this.getParent().getObjectByName(target_question);
		var str:String = textbox.getText();
		return str;
	}

	/**
	 * returns the chosen answer (the answer member variable is set based on the event we receive)
	 */
	public function getAnswer():String
	{
		return this.answer;
	}

	/**
	 * setParams - this lets us set the parameters for the stimulus
	 * @param params - a dynamic object with fields: zero, ref, max and target
	 */
	public function setParams(params:Dynamic):Void
	{
		this.answer = "";
		var textbox:ITextBox = cast this.getParent().getObjectByName(target_question);
		textbox.setText(params.question, false);
		var audio:IResourcePath = cast this.getParent().getObjectByName(question_audio);
		audio.setResource(params.question_audio);
		var question_subs:ITextBox = cast this.getParent().getObjectByName(question_srt);
		question_subs.setText(params.question_srt);

		feedbacks_map[GREEN].srt = params.srt_green;
		feedbacks_map[YELLOW].srt = params.srt_yellow;
		feedbacks_map[ORANGE].srt = params.srt_orange;
		feedbacks_map[RED].srt = params.srt_red;

		feedbacks_map[GREEN].audio = params.audio_green;
		feedbacks_map[YELLOW].audio = params.audio_yellow;
		feedbacks_map[ORANGE].audio = params.audio_orange;
		feedbacks_map[RED].audio = params.audio_red;
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('FeedbackTaskHandlerObject');
		feedbacks_map[GREEN] = {};
		feedbacks_map[GREEN].event_name = EVT_PLAY_GREEN;
		feedbacks_map[YELLOW] = {};
		feedbacks_map[YELLOW].event_name = EVT_PLAY_YELLOW;
		feedbacks_map[ORANGE] = {};
		feedbacks_map[ORANGE].event_name = EVT_PLAY_ORANGE;
		feedbacks_map[RED] = {};
		feedbacks_map[RED].event_name = EVT_PLAY_RED;
	}

	public var feedbacks_map = new Map<String, Dynamic>();
	public var target_question:String;

	public var target_srt:String;
	public var target_audio:String;
	public var question_srt:String;
	public var question_audio:String;

	/**
	 * register events in here
	 */
	override public function onHaveParent()
	{
		// trace(this.getParent());
		this.getParent().eventManager.addSubscriberForEvent(this, EVT_FEEDBACK_GIVEN);
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
		if (Reflect.hasField(jsonFile, "target_question"))
		{
			this.target_question = jsonFile.target_question;
		}

		if (Reflect.hasField(jsonFile, "target_srt"))
		{
			this.target_srt = jsonFile.target_srt;
		}

		if (Reflect.hasField(jsonFile, "target_audio"))
		{
			this.target_audio = jsonFile.target_audio;
		}
		if (Reflect.hasField(jsonFile, "question_audio"))
		{
			this.question_audio = jsonFile.question_audio;
		}

		if (Reflect.hasField(jsonFile, "question_srt"))
		{
			this.question_srt = jsonFile.question_srt;
		}

		super.fromFile(jsonFile);
		return;
	}
}
