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
class LockScreenObject implements DnaObject  implements DnaEventSubscriber extends DnaObjectBase
{

	public var answer_text:String;
	public var answer_text_obj:ITextBox;

	public var backspace:String;
	public var backspace_obj:DnaButtonObject;

	public var action_fin:String;
	public var action_fin_obj:ActionHandlerObject;


	private var answer:String = "";

	private var correctCode= "9523";

	private var maxLen = 6;

	override public function onReady()
	{
		answer_text_obj = cast this.getParent().getObjectByName(this.getNestedObjectName(answer_text));
		backspace_obj = cast this.getParent().getObjectByName(this.getNestedObjectName(backspace));
		action_fin_obj = cast this.getParent().getObjectByName(this.getNestedObjectName(action_fin));

		for (i in 0...10)
		{
			this.getParent().eventManager.addSubscriberForEvent(this, "KEY_" + Std.string(i));
		}
		backspace_obj.onPressCallback = this.onBackspacePressed;
		//this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.KEY_BACKSPACE);
	}

	public function onBackspacePressed(){
		if(answer.length > 0){
			this.answer = "";
		}
		updateDisplay();
	}

	private function updateDisplay(){
		var codeDispChar = "*";
		var codeDisp= "";
		for(i in 0...answer.length){
			codeDisp += codeDispChar;
		}
		this.answer_text_obj.setText(codeDisp,true);

		if(isCorrect()){
			this.action_fin_obj.startQueue();
		}

	}

	public function getNotified(event_key:String, params:Any = null):Void
	{
		if(answer.length >= maxLen){
			return;
		}
		answer += event_key.charAt(event_key.length-1);
		updateDisplay();
	}


	/**
	 * returns the answer string that the user gave
	 * @return String
	 */
	public function getAnswer():String
	{
		return this.answer;
	}
	/**
	 * checks if the task was answered correctly
	 */
	public function isCorrect():Bool
	{
		return this.answer == this.correctCode;
			
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('LockScreenObject');
	}


	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "answer_text"))
		{
			this.answer_text= jsonFile.answer_text;
		}
		if (Reflect.hasField(jsonFile, "backspace"))
		{
			this.backspace= jsonFile.backspace;
		}

		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			this.action_fin= jsonFile.action_fin;
		}




		super.fromFile(jsonFile);
		return;
	}
}
