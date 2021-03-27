package dnaobject;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnaobject.components.ActionFireEventComponent;
import dnaobject.objects.ActionHandlerObject;

/**
 * this class will make an object appear based on an event.
 */
class DnaActionGroup implements DnaComponent implements DnaEventSubscriber extends DnaActionBase
{
	public var action_handler:ActionHandlerObject;
	public var action_queue:Array<DnaActionBase>;
	public var first:Bool = true;

	/**
	 * getNotified() - we will register for the event where the last action is done..
	 * @param event_name 
	 */
	public function getNotified(event_name:String):Void
	{
		this.first = true;
		this.getParent().getParent().removeObject(action_handler.id);
		finishAction();
	}

	/**
	 * in here we generate a unique name for our actionhandler object
	 * @return String
	 */
	public function getActionHandlerName():String
	{
		return "ActionHandler_group_" + Std.string(this.id);
	}

	/**
	 * in here we generate a unique name for our actionhandler object
	 * @return String
	 */
	public function getStartEventName():String
	{
		return "first_action_for_group_" + Std.string(this.id);
	}

	/**
	 * in here we generate a unique name for our actionhandler object
	 * @return String
	 */
	public function getLastActionEventName():String
	{
		if (this.action_queue.length == 0)
		{
			assert(this.action_queue.length != 0);
			return null;
		}
		return this.action_queue[action_queue.length - 1].getFinishedEventName();
	}

	/**
	 * this function adds an action to the queue
	 * @param action 
	 */
	public function addActionToQueue(action:DnaActionBase):Void
	{
		this.action_queue.push(action);
	}

	/**
	 * ctor
	 */
	public function new(name:String)
	{
		super(name);
		action_queue = new Array<DnaActionBase>();
		action_handler = cast DnaObjectFactory.create("ActionHandlerObject");
		action_handler.obj_name = getActionHandlerName();
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		// TODO:
		// 1. create a new actionhandler with unique name and add it to the state
		// 2. create the first action we need with on_event = some unique id.
		// 3. create the other actions with on_event = seq
		// 4. register as listener for unique end id
		// 5. add actionFireEvent as last action  with unique end id.
		// 6. fire unique start event.
		// 7. on unique end event do the following:
		// - remove the actionhandler with unique name from the state
		// - finishAction()
		// for  doing all the overhead (everything except step 3) it would probably be nice to have a base class to inherit from.
		// call it ActionGroupComponent or something
		super.fromFile(jsonFile);
	}

	/**
	 * in here we setup the action handler. we add the queue of actions to it and add it to our state.
	 */
	public function setupActionHandler()
	{
		assert(this.action_queue.length != 0);
		action_queue[0].on_event = getStartEventName();
		this.getParent().getParent().eventManager.addSubscriberForEvent(this, action_queue[action_queue.length - 1].getFinishedEventName());

		for (action in action_queue)
		{
			action_handler.addAction(action);
		}
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		if (first)
		{
			first = false;
			setupActionHandler();
			getParent().getParent().addObject(action_handler);
			this.getParent().getParent().eventManager.broadcastEvent(getStartEventName());
		}
	}
}
