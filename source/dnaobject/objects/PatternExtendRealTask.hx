package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateHidden;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class PatternExtendRealTask implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternExtendRealTask");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>)
	{
		if (DnaConstants.TASK_ANSWERED_EVENT == event_name)
		{
			if (params == true)
			{
				onCorrect();
			}
			else
			{
				onIncorrect();
			}
		}
	}

	public function loadTrial()
	{
		trial_handler_obj.saveCurrentTrial();
		trial_handler_obj.loadNextTrial();
		if (this.trial_handler_obj.all_trials_done)
		{
			action_fin_obj.startQueue();
		}
	}

	public function onCorrect()
	{
		if (this.onCorrectCallback != null)
		{
			onCorrectCallback();
			return;
		}
		loadTrial();
	}

	public function onIncorrect()
	{
		if (this.onIncorrectCallback != null)
		{
			onIncorrectCallback();
			return;
		}

		loadTrial();
	}

	public var onCorrectCallback:Void->Void = null;
	public var onIncorrectCallback:Void->Void = null;

	override public function onReady()
	{
		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_load_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_load));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		trial_handler_obj = cast this.getParent().getObjectByName(getNestedObjectName(trial_handler));

		pattern_disp_obj = cast this.getParent().getObjectByName((pattern_disp));
		getParent().eventManager.addSubscriberForEvent(this, DnaConstants.TASK_ANSWERED_EVENT);
		trial_handler_obj.loadNextTrial();
		super.onReady();
	}

	public var action_load:String;
	public var action_fin:String;
	public var action_init:String;
	public var trial_handler:String;
	public var pattern_disp:String;
	public var action_load_obj:ActionHandlerObject;
	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var trial_handler_obj:TrialHandlerObject;
	public var pattern_disp_obj:PatternExtendObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "action_load"))
		{
			action_load = jsonFile.action_load;
		}
		if (Reflect.hasField(jsonFile, "action_init"))
		{
			action_init = jsonFile.action_init;
		}
		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			action_fin = jsonFile.action_fin;
		}
		if (Reflect.hasField(jsonFile, "trial_handler"))
		{
			trial_handler = jsonFile.trial_handler;
		}
		if (Reflect.hasField(jsonFile, "pattern_disp"))
		{
			pattern_disp = jsonFile.pattern_disp;
		}
	}

	public override function update(elapsed:Float) {}
}
