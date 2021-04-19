package dnaEvent;

/**
 * this class is modeled after the following stackoverflow answer:
 * https://stackoverflow.com/questions/36299332/how-to-code-in-haxeflixel-in-game-events-in-a-practical-way
 *
 * this is the class that handles events. with this class we will be doing scripted events
 * like showing the tutorial (first freeeze everything then move something and so on.)
 */
class DnaEvent implements DnaEventSubscriber
{
	public static var s_event_id:Int = 0;

	public final id:Int;
	public var name:String;
	public var prequisite_events:Array<String>;
	public var eventManager:DnaEventManager;

	/**
	 * ctor -
	 * @param name - (unique) name of this event.
	 */
	public function new(name:String, event_manager:DnaEventManager)
	{
		this.id = s_event_id++;
		this.name = name;
		this.prequisite_events = new Array<String>();
		eventManager = event_manager;
	}

	/**
	 * getNotified - this is the function that will be called whenever an event is broadcast.
	 * which we subsribed.
	 *
	 * @param event_name - name of the event
	 */
	public function getNotified(event_name:String, params:Any = null):Void
	{
		this.eventTriggered(event_name);
	}

	/**
	 * this adds a prequisite to this event.
	 * when all prequisites are fullfilled (have fired) we fire this event.
	 * @param event_name
	 */
	public function addPrequisite(event_name:String)
	{
		if (event_name == null || event_name.length == 0)
		{
			trace("invalid event name", event_name);
			return;
		}
		var already_have:Bool = false;
		for (event in prequisite_events)
		{
			if (event == event_name)
			{
				already_have = true;
			}
		}
		if (!already_have)
		{
			prequisite_events.push(event_name);
			eventManager.addSubscriberForEvent(this, event_name);
		}
	}

	/**
	 * this function will be called if an event is triggered.
	 * after going through all our preqisites it triggers this event
	 * @param event_name - the event that just triggered
	 */
	public function eventTriggered(event_name:String, params:Any = null)
	{
		var is_prequisite:Bool = false;

		for (event in prequisite_events)
		{
			if (event == event_name)
			{
				prequisite_events.remove(event);
				break;
			}
		}
		if (prequisite_events.length == 0)
		{
			eventManager.broadcastEvent(this.name, params);
		}
	}
}
