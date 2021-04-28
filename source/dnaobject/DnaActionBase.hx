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
		// //trace(this.comp_type, "finish action, canceled:", canceled);
		if (this.getParent() == null)
		{
			// trace(this.id, "parent null", this.getParent());
			return;
		}
		if (!this.oneshot)
		{
			cast(this.getParent(), ActionHandlerObject).addAction(this);
		}
		if (!canceled)
		{
			this.getParent().getParent().eventManager.broadcastEvent(getFinishedEventName());
		}
		if (canceled)
		{
			// reset canceled for next time
			canceled = false;
		}
		this.m_parent_obj.removeComponent(this.id);
		// this.destroy();
	}

	public var canceled(default, set):Bool = false;

	/**
	 * setter for canceled
	 * @param value 
	 * @return Bool
	 */
	public function set_canceled(value:Bool):Bool
	{
		this.canceled = value;
		// trace(this.comp_type, "used setter to set canceled to:", canceled);
		if (canceled)
		{
			this.finishAction();
		}
		return canceled;
	}

	/**
	 * call this function to execute stuff for all targets.
	 */
	public function doActionOnAllTargets()
	{
		if (this.m_target_name != "")
		{
			this.targets.push(m_target_name);
		}
		for (target_name in this.targets)
		{
			doActionPerTarget(target_name);
		}
	}

	/**
	 * this function can be overriden for easy handling of multiple targets.
	 * @param target_name 
	 */
	public function doActionPerTarget(target_name:String) {}

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

	public var targets:Array<String> = new Array<String>();

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
		if (Reflect.hasField(jsonFile, "targets"))
		{
			var targets_file:Array<String> = jsonFile.targets;
			for (target in targets_file)
			{
				targets.push(target);
			}
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
	private var m_target_name(get, default):String;

	public function get_m_target_name()
	{
		return m_target_name;
	}

	/**
	 * whether or not to remove the action after it executed (in Actionhandlers)
	 */
	public var oneshot:Bool = true;
}
