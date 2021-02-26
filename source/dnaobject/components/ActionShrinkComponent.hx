package dnaobject.components;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class will make an object Shrink based on an event.
 */
class ActionShrinkComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionShrinkComponent");
	}

	public var m_to_x:Float = 0;
	public var m_to_y:Float = 0;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "to_x"))
		{
			m_to_x = jsonFile.to_x;
		}
		if (Reflect.hasField(jsonFile, "to_y"))
		{
			m_to_y = jsonFile.to_y;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// might look confusing at first.
		// with the first getParent we get the object. and with the 2nd the state.
		var target:DnaObject = getParent().getParent().getObjectByName(m_target_name);
		// this relies on the fact that we only use this scale action on sprite objects..
		// TODO fix this..
		cast(target.getChildren()[0], FlxSprite).scale.x = m_to_x;
		cast(target.getChildren()[0], FlxSprite).scale.y = m_to_y;

		this.finishAction();
	}
}
