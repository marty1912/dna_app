package dnaobject.objects;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;

/**
 * this is the actionHandler.
 * in this object we have a list of components (actions) that we want to execute on some events or something
 *
 */
class ActionHandlerObject implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	static final CODE_SEQUENTIAL = "seq";
	static final CODE_SAME_TIME = "same";

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionHandlerObject");
		m_inactive_actions_queue = new Array<DnaActionBase>();
	}

	private var m_inactive_actions_queue:Array<DnaActionBase>;

	/**
	 * aborts all running actions.
	 * also might abort future actions that depend on the current action to finish.
	 */
	public function abortRunningActions()
	{
		trace(this.obj_name, " - canceling actions:", this.m_component_list);
		for (act in this.m_inactive_actions_queue)
		{
			trace(this.obj_name, " - inactive action:", act.id, " - ", act.comp_type);
		}
		for (comp in this.m_component_list)
		{
			if (comp.comp_type.indexOf("Action") == -1)
			{
				continue;
			}
			var action:DnaActionBase = cast comp;
			action.canceled = true;
			trace("action canceled!", action.comp_type);
		}
	}

	/**
	 * adds an action to our queue and registers this object with the corresponding handler.
	 * @param action - the action to add
	 */
	public function addAction(action:DnaActionBase)
	{
		trace("adding action", action.id, " on event:", action.on_event);
		if (action.on_event == CODE_SEQUENTIAL)
		{
			assert(this.m_inactive_actions_queue.length != 0); // , "sequential actions need a predecessor!");
			var last_element = this.m_inactive_actions_queue[m_inactive_actions_queue.length - 1];
			var last_element_ev_fin = last_element.getFinishedEventName();
			action.on_event = last_element_ev_fin;
		}
		else if (action.on_event == CODE_SAME_TIME)
		{
			var last_element = this.m_inactive_actions_queue[m_inactive_actions_queue.length - 1];
			action.on_event = last_element.on_event;
		}
		assert(action.on_event != action.getFinishedEventName());
		this.getParent().eventManager.addSubscriberForEvent(this, action.on_event);

		this.m_inactive_actions_queue.push(action);
	}

	/**
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "actions"))
		{
			var actions:Array<Dynamic> = jsonFile.actions;

			for (action in actions)
			{
				trace(action);
				var to_add = DnaComponentFactory.create(action.type);
				to_add.fromFile(action);
				addAction(cast(to_add, DnaActionBase));
			}
		}
		super.fromFile(jsonFile);
	};

	static var calls = 0;

	/**
	 * this is called whenever an event that is part of our inactive actions list is called..
	 * @param event_key
	 */
	public function getNotified(event_key:String, params:Any = null):Void
	{
		var index = 0;
		// step 1 find firing actoins
		var firing_actions:Array<DnaActionBase> = new Array<DnaActionBase>();
		while (index < this.m_inactive_actions_queue.length)
		{
			var action = m_inactive_actions_queue[index];

			assert(action.on_event != action.getFinishedEventName());
			if (action.on_event == event_key)
			{
				firing_actions.push(action);
			}
			index++;
		}

		// step 2 fire.
		index = 0;
		while (index < firing_actions.length)
		{
			var action = firing_actions[index];
			m_inactive_actions_queue.remove(action);
			this.addComponent(cast(action));
			index++;
		}
	}
}
