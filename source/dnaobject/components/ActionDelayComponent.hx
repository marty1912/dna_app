package dnaobject.components;

/**
 * this class will make a Delay used mostly for sequential actions.
 */
class ActionDelayComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionDelayComponent");
		this.update_event_name = this.id + "_update";
	}

	private var m_elapsed_time:Float = 0;

	public var m_delay_time:Float;

	public var update_event_name:String;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "delay"))
		{
			this.m_delay_time = jsonFile.delay;
		}
		if (Reflect.hasField(jsonFile, "update_event_name"))
		{
			this.update_event_name = jsonFile.update_event_name;
		}

		super.fromFile(jsonFile);
	}

	/**
	 *  we have to reset the delay time in here..
	 */
	override public function finishAction()
	{
		this.m_elapsed_time = 0;
		super.finishAction();
	}

	/**
	 * in this function we will make the object Delay..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		this.m_elapsed_time += elapsed;
		// emit event with parameters to use for example for displaying the time.
		var params = new Array<Float>();
		params.push(this.m_elapsed_time);
		params.push(this.m_delay_time);
		this.getParent().getParent().eventManager.broadcastEvent(this.update_event_name, params);

		trace("delay ", m_delay_time, "elapsed:", m_elapsed_time, "value:", (this.m_delay_time >= this.m_elapsed_time));
		if (this.m_delay_time <= this.m_elapsed_time)
		{
			// reset time.
			trace("delay fin");
			this.finishAction();
		}
	}
}
