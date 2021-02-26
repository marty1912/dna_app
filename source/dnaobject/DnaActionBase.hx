package dnaobject;

import dnaEvent.DnaEventManager;
import dnaobject.objects.ActionHandlerObject;

/**
 * this is the base class for our Actions.
 *
 */
class DnaActionBase implements DnaComponent extends DnaComponentBase
{
	/**
	 * this is the key function for our actions.
	 * after we finished we remove ourselfs from the components list of the parent
	 * and therefore our update funciton will not be called again.
	 */
	public function finishAction()
	{
		if (!this.oneshot)
		{
			cast(this.m_parent_obj, ActionHandlerObject).addAction(this);
		}
		this.m_parent_obj.removeComponent(this.id);
		DnaEventManager.instance.broadcastEvent(getFinishedEventName());
		// this.destroy();
	}

	/**
	 * returns the name of the event that will be fired when this action is finished
	 */
	public function getFinishedEventName()
	{
		var event_name:String = this.id + "_fin";
		return event_name;
	}

	/**
	 * sets the target member variable
	 * @param name - the name of the target object
	 */
	public function setTarget(name:String)
	{
		this.m_target_name = name;
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target"))
		{
			this.setTarget(jsonFile.target);
		}
		if (Reflect.hasField(jsonFile, "on_event"))
		{
			this.on_event = jsonFile.on_event;
		}
		if (Reflect.hasField(jsonFile, "oneshot"))
		{
			this.oneshot = jsonFile.oneshot;
		}
	}

	/**
	 * this is the event on which we want to execute this action
	 * if used in a sequence use "sequential" to run it after the previous action is finished.
	 */
	public var on_event:String;

	/**
	 * the name of our target
	 */
	private var m_target_name:String;

	/**
	 * whether or not to remove the action after it executed (in Actionhandlers)
	 */
	public var oneshot:Bool = true;
}
