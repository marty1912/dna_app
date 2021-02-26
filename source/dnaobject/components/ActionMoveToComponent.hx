package dnaobject.components;

import flixel.math.FlxPoint;

/**
 * this class will make an object MoveTo based on an event.
 */
class ActionMoveToComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionMoveToComponent");
	}

	/**
	 * this variable specifies the mode (the way we move)
	 */
	public var mode:String = "linear";

	public var m_to_object:String;

	public var m_to_x:Float = 0;
	public var m_to_y:Float = 0;
	public var m_speed:Float = 0;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "to_object"))
		{
			m_to_object = jsonFile.to_object;
		}
		if (Reflect.hasField(jsonFile, "to_x"))
		{
			m_to_x = jsonFile.to_x;
		}
		if (Reflect.hasField(jsonFile, "to_y"))
		{
			m_to_y = jsonFile.to_y;
		}
		if (Reflect.hasField(jsonFile, "speed"))
		{
			m_speed = jsonFile.speed;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * in this function we will make the object MoveTo..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// might look confusing at first.
		// with the first getParent we get the object. and with the 2nd the state.
		var target:DnaObject = getParent().getParent().getObjectByName(m_target_name);
		var goal_pos:FlxPoint = getParent().getParent().getObjectByName(m_to_object).getOrigin().copyTo(FlxPoint.get());
		var target_origin:FlxPoint = target.getOrigin().copyTo(FlxPoint.get());

		goal_pos.x += this.m_to_x;
		goal_pos.y += this.m_to_y;

		var offset_vec = goal_pos.copyTo(FlxPoint.get());
		offset_vec = offset_vec.subtractPoint(target_origin);

		var len = offset_vec.distanceTo(FlxPoint.get());

		var max_len = m_speed * elapsed;
		if (len >= max_len)
		{
			offset_vec.scale(max_len / len);
		}
		var new_pos = target_origin.addPoint(offset_vec);

		target.moveTo(new_pos.x, new_pos.y);

		target_origin.put();
		offset_vec.put();

		if (target.getOrigin().x == goal_pos.x && target.getOrigin().y == goal_pos.y)
		{
			this.finishAction();
		}
	}
}
