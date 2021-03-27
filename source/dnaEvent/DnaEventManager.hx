package dnaEvent;

import Assertion.assert;
import haxe.ds.StringMap;

/**
 * class DnaEventManager
 * this class is modeled after this stackoverflow answer:
 * https://stackoverflow.com/questions/36299332/how-to-code-in-haxeflixel-in-game-events-in-a-practical-way
 * in here we will notify all event listeners and so on.
 * another useful link is the following:
 * https://gamedev.stackexchange.com/questions/14383/best-way-to-manage-in-game-events/14430#14430
 */
class DnaEventManager
{
	public static final KEY_EVENT_PREFIX:String = "KEY_";

	/**
	 * this is the only instance that will ever exist
	 *
	 */
	// public static final instance:DnaEventManager = new DnaEventManager();

	/**
	 * private ctor so nobody can create another singleton
	 */
	public function new()
	{
		event_list = new Array<DnaEvent>();
		event_subscribers = new StringMap<Array<DnaEventSubscriber>>();
	};

	/**
	 * this is the datastructure we use to keep track of every subscriber that needs to be
	 * notified for a given event.
	 *
	 * the key will be our event_name
	 * and the subscribers will be an array of subscribers for this event
	 */
	public var event_subscribers:StringMap<Array<DnaEventSubscriber>>;

	public var event_list:Array<DnaEvent>;

	/**
	 * addEvent - this function adds an event with the event name. if it already exists it does nothing.
	 * @param event_name - the name of the new event.
	 */
	public function addEvent(event_name:String):Void
	{
		var already_exists:Bool = false;

		for (event in event_list)
		{
			if (event.name == event_name)
			{
				already_exists = true;
				break;
			}
		}
		if (!already_exists)
		{
			event_list.push(new DnaEvent(event_name, this));
			var subscribers:Array<DnaEventSubscriber> = new Array<DnaEventSubscriber>();
			event_subscribers.set(event_name, subscribers);
		}
	}

	/**
	 * this function adds a subscriber for a given event name. if the event with the name given does not exist it will
	 * be created
	 * @param subscriber - the subscriber to be added to the list.
	 * @param event_name - the name of the event.
	 */
	public function addSubscriberForEvent(subscriber:DnaEventSubscriber, event_name:String):Void
	{
		this.addEvent(event_name);
		var subscribers:Array<DnaEventSubscriber> = event_subscribers.get(event_name);
		if (!subscribers.contains(subscriber))
		{
			subscribers.push(subscriber);
		}
	}

	/**
	 * this function notifies all subscribers of the event
	 * @param event_name - the name of the event
	 */
	public function broadcastEvent(event_name:String)
	{
		trace("event fired:", event_name);
		assert(event_name != null);

		var subscribers:Array<DnaEventSubscriber> = event_subscribers.get(event_name);
		if (subscribers == null)
		{
			return;
		}

		for (sub in subscribers)
		{
			sub.getNotified(event_name);
		}
	}

	/**
	 * clears all mappings and empties lists.
	 * this function can be used to reset a level for example.
	 */
	public function clearEvents():Void
	{
		while (event_list.length > 0)
		{
			event_list.pop();
		}

		event_subscribers = null;
		event_subscribers = new StringMap<Array<DnaEventSubscriber>>();
	}
}
