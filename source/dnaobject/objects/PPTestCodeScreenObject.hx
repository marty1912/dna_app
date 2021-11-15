package dnaobject.objects;

import dnadata.DnaDataManager;
import Assertion.assert;
import dnaEvent.DnaEventSubscriber;
import dnaobject.DnaObject;
import dnaobject.interfaces.ITextBox;

/**
 * class ProbcodeHandlerObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class PPTestCodeScreenObject implements DnaObject  implements DnaEventSubscriber extends DnaObjectBase
{

	public var answer_text:String;
	public var answer_text_obj:ITextBox;

	public var accept:String;
	public var accept_obj:DnaButtonObject;

	public var action_fin:String;
	public var action_fin_obj:ActionHandlerObject;


	private var answer:String = "";

	private var maxLen = 6;

	override public function onReady()
	{
		answer_text_obj = cast this.getParent().getObjectByName(this.getNestedObjectName(answer_text));
		accept_obj = cast this.getParent().getObjectByName(this.getNestedObjectName(accept));
		action_fin_obj = cast this.getParent().getObjectByName(this.getNestedObjectName(action_fin));

		for (i in 0...10)
		{
			this.getParent().eventManager.addSubscriberForEvent(this, "KEY_" + Std.string(i));
		}
		accept_obj.onPressCallback = this.onAcceptPressed;
		//this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.KEY_BACKSPACE);
	}

	public final pPCodeKey = "PPTestCode";
	public function onAcceptPressed(){
		DnaDataManager.instance.storeData(pPCodeKey,this.answer);
		updateDisplay();
		this.action_fin_obj.startQueue();
	}

	private function updateDisplay(){
		this.answer_text_obj.setText(answer,true);
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
		if (Reflect.hasField(jsonFile, "accept"))
		{
			this.accept= jsonFile.accept;
		}

		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			this.action_fin= jsonFile.action_fin;
		}

		super.fromFile(jsonFile);
		return;
	}
}
