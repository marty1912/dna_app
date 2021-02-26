package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import flixel.FlxG;
import flixel.math.FlxPoint;

/**
 * this enum will be used to let us know where we should position the parent object.
 */
enum PositionType
{
	Center;
	LeftTop;
	RightTop;
	LeftBottom;
	RightBottom;
	CenterBottom;
	CenterTop;
	RightCenter;
	LeftCenter;
}

/**
 * class PositionComponent.
 * this component keeps its parent in the center of the screen.
 */
class PositionComponent implements DnaComponent extends DnaComponentBase
{
	private var m_oneshot:Bool;
	private var m_target_name:String = "";

	public var m_position_type:PositionType;

	public function setPositionType(type:PositionType):Void
	{
		m_position_type = type;
	}

	public function getPositionType(type:PositionType):PositionType
	{
		return m_position_type;
	}

	public function new()
	{
		super('PositionComponent');
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		// first we get all the proportions for the numberline:
		if (Reflect.hasField(jsonFile, "oneshot"))
		{
			this.m_oneshot = jsonFile.oneshot;
		}
		if (Reflect.hasField(jsonFile, "position"))
		{
			if (jsonFile.position == "Center")
			{
				this.m_position_type = Center;
			}
			if (jsonFile.position == "LeftTop")
			{
				this.m_position_type = LeftTop;
			}
			if (jsonFile.position == "RightTop")
			{
				this.m_position_type = RightTop;
			}
			if (jsonFile.position == "LeftBottom")
			{
				this.m_position_type = LeftBottom;
			}
			if (jsonFile.position == "RightBottom")
			{
				this.m_position_type = RightBottom;
			}
			if (jsonFile.position == "CenterBottom")
			{
				this.m_position_type = CenterBottom;
			}
			if (jsonFile.position == "CenterTop")
			{
				this.m_position_type = CenterTop;
			}
			if (jsonFile.position == "LeftCenter")
			{
				this.m_position_type = LeftCenter;
			}
			if (jsonFile.position == "RightCenter")
			{
				this.m_position_type = RightCenter;
			}
		}
		if (Reflect.hasField(jsonFile, "target"))
		{
			this.m_target_name = jsonFile.target;
		}
	}

	/**
	 * this is used to determine the position on a target object. we use it to center text for example.
	 * @param screen_w
	 * @param screen_h
	 * @param obj_w
	 * @param obj_h
	 * @param position_type
	 */
	public static function getCorrectPos(screen_width:Int, screen_height:Int, obj_w:Int, obj_h:Int, position_type:PositionType):FlxPoint
	{
		var max_left_from_origin = 0;

		var max_up_from_origin = 0;
		var max_down_from_origin = obj_h;
		var max_right_from_origin = obj_w;

		/**
		 * here we get the distances we need to the left and right
		 * and up and down and then we move the object so that left and right distance is the same
		 * and up and down of course.
		 */
		var total_width = (-max_left_from_origin) + max_right_from_origin;

		var total_height = (-max_up_from_origin) + max_down_from_origin;
		var empty_space_left_rigth = screen_width - total_width;
		var empty_space_up_down = screen_height - total_height;

		var point = null;
		switch position_type
		{
			case Center:
				point = FlxPoint.get((empty_space_left_rigth / 2) + (-max_left_from_origin), (empty_space_up_down / 2) + (-max_up_from_origin));
			case CenterBottom:
				point = FlxPoint.get((empty_space_left_rigth / 2) + (-max_left_from_origin), screen_height - max_down_from_origin);
			case CenterTop:
				point = FlxPoint.get((empty_space_left_rigth / 2) + (-max_left_from_origin), (-max_up_from_origin));
			case LeftCenter:
				point = FlxPoint.get((-max_left_from_origin), (empty_space_up_down / 2) + (-max_up_from_origin));
			case RightCenter:
				point = FlxPoint.get(screen_width - max_right_from_origin, (empty_space_up_down / 2) + (-max_up_from_origin));
			case LeftTop:
				point = FlxPoint.get((-max_left_from_origin), (-max_up_from_origin));
			case LeftBottom:
				point = FlxPoint.get((-max_left_from_origin), screen_height - max_down_from_origin);
			case RightBottom:
				point = FlxPoint.get(screen_width - max_right_from_origin, screen_height - max_down_from_origin);
			case RightTop:
				point = FlxPoint.get(screen_width - max_right_from_origin, (-max_up_from_origin));
			default:
		}

		return point;
	}

	/**
	 * setPos - this function sets the position of the parent to the position given in this.position_type
	 */
	public function setPos()
	{
		var screen_height:Int = FlxG.height;
		var screen_width:Int = FlxG.width;

		if (this.m_target_name != "")
		{
			var target:DnaObject = getParent().getParent().getObjectByName(m_target_name);
			screen_height = target.getHeight();
			screen_width = target.getWidth();
		}

		/**
		 * in here we get 4 max distances from our origin.
		 * we want to view our DnaObject as a rectangle to position it
		 * nicely.
		 * therefore we have to get the max distances from its origin
		 * because there can be many objects in a DnaObject that are at different positions.
		 *
		 * here is a small drawing of what we do here:
		 * max_left | max_rigt
		 * ________________
		 * |               |= max_up_from_origin
		 * |      .origin  |
		 * |               | max_down_from_origin
		 * -----------------
		 *
		 * the max_left and max_up will be negative values. this is why we use
		 * Negative infinity and compare using <.
		 *
		 */

		var leftrightupdown = getParent().getMaxLeftRightUpDownFromOrigin();

		var max_left_from_origin = leftrightupdown[0];

		var max_up_from_origin = leftrightupdown[2];
		var max_down_from_origin = leftrightupdown[3];
		var max_right_from_origin = leftrightupdown[1];

		/**
		 * here we get the distances we need to the left and right
		 * and up and down and then we move the object so that left and right distance is the same
		 * and up and down of course.
		 */
		var total_width = (-max_left_from_origin) + max_right_from_origin;

		var total_height = (-max_up_from_origin) + max_down_from_origin;
		var empty_space_left_rigth = screen_width - total_width;
		var empty_space_up_down = screen_height - total_height;

		switch m_position_type
		{
			case Center:
				getParent().moveTo((empty_space_left_rigth / 2) + (-max_left_from_origin), (empty_space_up_down / 2) + (-max_up_from_origin));
			case CenterBottom:
				getParent().moveTo((empty_space_left_rigth / 2) + (-max_left_from_origin), screen_height - max_down_from_origin);
			case CenterTop:
				getParent().moveTo((empty_space_left_rigth / 2) + (-max_left_from_origin), (-max_up_from_origin));
			case LeftCenter:
				getParent().moveTo((-max_left_from_origin), (empty_space_up_down / 2) + (-max_up_from_origin));
			case RightCenter:
				getParent().moveTo(screen_width - max_right_from_origin, (empty_space_up_down / 2) + (-max_up_from_origin));
			case LeftTop:
				getParent().moveTo((-max_left_from_origin), (-max_up_from_origin));
			case LeftBottom:
				getParent().moveTo((-max_left_from_origin), screen_height - max_down_from_origin);
			case RightBottom:
				getParent().moveTo(screen_width - max_right_from_origin, screen_height - max_down_from_origin);
			case RightTop:
				getParent().moveTo(screen_width - max_right_from_origin, (-max_up_from_origin));
			default:
		}

		if (this.m_target_name != "")
		{
			var target:DnaObject = getParent().getParent().getObjectByName(m_target_name);
			getParent().moveTo(getParent().getOrigin().x + target.getOrigin().x, getParent().getOrigin().y + target.getOrigin().y);
		}
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		this.setPos();
		/**
		 * remove the component from the parent
		 */
		if (this.m_oneshot == true)
		{
			getParent().removeComponent(this.id);
		}
	}
}
