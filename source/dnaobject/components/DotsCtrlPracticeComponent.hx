package dnaobject.components;

import constants.DnaConstants;
import dnaEvent.DnaEventSubscriber;
import dnaobject.interfaces.ITextBox;
import dnaobject.objects.ActionHandlerObject;
import dnaobject.objects.DnaButtonObject;
import dnaobject.objects.DotsCompCtrl;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class DotsCtrlPracticeComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("DotsCtrlPracticeComponent");
	}

	public var action_correct:String;
	public var action_incorrect:String;
	public var action_timeout:String;

	public var action_correct_obj:ActionHandlerObject;
	public var action_incorrect_obj:ActionHandlerObject;
	public var action_timeout_obj:ActionHandlerObject;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "action_correct"))
		{
			action_correct = jsonFile.action_correct;
		}
		if (Reflect.hasField(jsonFile, "action_incorrect"))
		{
			action_incorrect = jsonFile.action_incorrect;
		}
		if (Reflect.hasField(jsonFile, "action_timeout"))
		{
			action_timeout = jsonFile.action_timeout;
		}
	}

	public function doFeedback(callback:Void->Void)
	{
		if (dots_ctrl.dots_disp_obj.isCorrect() == DnaConstants.TASK_CORRECT)
		{
			dots_ctrl.loadTrial();
			action_correct_obj.startQueue(callback);
		}
		else if (dots_ctrl.dots_disp_obj.isCorrect() == DnaConstants.TASK_INCORRECT)
		{
			action_incorrect_obj.startQueue(callback);
		}
		else
		{
			action_timeout_obj.startQueue(callback);
		}
	}

	public var dots_ctrl:DotsCompCtrl;

	public override function onHaveParent() {}

	public override function onReady()
	{
		this.dots_ctrl = cast this.getParent();
		action_correct_obj = cast getParent().getParent().getObjectByName(action_correct);
		action_incorrect_obj = cast getParent().getParent().getObjectByName(action_incorrect);
		action_timeout_obj = cast getParent().getParent().getObjectByName(action_timeout);

		dots_ctrl.feedbackCallback = this.doFeedback;
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
