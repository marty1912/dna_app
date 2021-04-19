package dnaEvent;

/**
 * this class interface was copied from https://stackoverflow.com/questions/36299332/how-to-code-in-haxeflixel-in-game-events-in-a-practical-way
 */
interface DnaEventSubscriber
{
	public function getNotified(event_key:String, params:Any = null):Void;
}
