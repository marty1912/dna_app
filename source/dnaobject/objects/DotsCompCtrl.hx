package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventSubscriber;
import dnaobject.components.StateMachineComponent;
import dnaobject.objects.DotsTaskObject;
import dnaobject.interfaces.IStateFactory;
import dnaobject.objects.dotcompstates.real_task.DotCompDefaultFactory;
import dnaobject.objects.dotcompstates.no_time.DotCompTutorialFactory;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class DotsCompCtrl implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("DotsCompCtrl");
		states_factory = new DotCompDefaultFactory();
		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(cast state_machine);

	}

	public var states_factory:IStateFactory;
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
	}

	public function onIncorrect()
	{
		if (this.onIncorrectCallback != null)
		{
			onIncorrectCallback();
			return;
		}
	}

	public var onCorrectCallback:Void->Void = null;
	public var onIncorrectCallback:Void->Void = null;

	public var feedbackCallback:(Void->Void) -> Void = null;
	public var state_machine:StateMachineComponent = null;

	override public function onReady()
	{
		super.onReady();

		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_load_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_load));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		trial_handler_obj = cast this.getParent().getObjectByName(getNestedObjectName(trial_handler));

		dots_disp_obj = cast this.getParent().getObjectByName((dots_disp));

		timer_obj = cast this.getParent().getObjectByName((timer));

		getParent().eventManager.addSubscriberForEvent(this, DnaConstants.TASK_ANSWERED_EVENT);
		trial_handler_obj.loadNextTrial();


		
		state_machine.setNextState(states_factory.create());
	}

	public var states:String;
	public var timer:String;
	public var action_load:String;
	public var action_fin:String;
	public var action_init:String;
	public var trial_handler:String;
	public var dots_disp:String;
	public var action_load_obj:ActionHandlerObject;
	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var trial_handler_obj:TrialHandlerObject;
	public var dots_disp_obj:DotsTaskObject;
	public var timer_obj:TimerObject;

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
		if (Reflect.hasField(jsonFile, "dots_disp"))
		{
			dots_disp = jsonFile.dots_disp;
		}

		if (Reflect.hasField(jsonFile, "states"))
		{
			states = jsonFile.states;
		}
		if (Reflect.hasField(jsonFile, "timer"))
		{
			timer = jsonFile.timer;
		}
	}
}







