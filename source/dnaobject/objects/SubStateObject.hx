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

	override public function destroy()
	{
		this.sub_state.keep_alive = false;
		this.sub_state.destroy();
		super.destroy();
	}

	/**
	 * this function will be called whenever we close our substate.
	 */
	public function onSubstateClose():Void
	{
		trace("substate closed");
	}

	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "state"))
		{
			this.sub_state = DnaStateFactory.create(jsonFile.state);
			this.sub_state.closeCallback = this.onSubstateClose;
			this.sub_state.keep_alive = true;
		}
		super.fromFile(jsonFile);
	}
}