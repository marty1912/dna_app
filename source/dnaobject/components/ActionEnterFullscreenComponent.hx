package dnaobject.components;

import osspec.OsManager;

/**
 * this class will make an object appear based on an event.
 */
class ActionEnterFullscreenComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionEnterFullscreenComponent");
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		super.fromFile(jsonFile);
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		OsManager.get_instance().toFullscreen();
		this.finishAction();
	}
}
