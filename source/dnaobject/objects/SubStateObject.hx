package dnaobject.objects;

/**
 * this class is used simply for using components that dont fit anywhere else..
 * it is merely a container for components.
 *
 */
class SubStateObject implements DnaObject extends DnaObjectBase
{
	public var sub_state:DnaState;

	/**
	 * constructor.
	 */
	public function new()
	{
		super('SubStateObject');
	}

	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "state"))
		{
			this.sub_state = DnaStateFactory.create(jsonFile.state);
			this.sub_state.create();
		}
		super.fromFile(jsonFile);
	}
}
