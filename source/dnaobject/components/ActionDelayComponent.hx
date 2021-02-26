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
	}

	private var m_elapsed_time:Float = 0;

	public var m_delay_time:Float;

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
		super.fromFile(jsonFile);
	}

	/**
	 * in this function we will make the object Delay..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		this.m_elapsed_time += elapsed;
		if (this.m_delay_time <= this.m_elapsed_time)
		{
			this.finishAction();
		}
	}
}
