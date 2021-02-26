package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Scrollable;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * this enum is used to define the different modes we support in this component.
 */
enum ScrollMode
{
	Scroll;
	Wave;
	Circle;
}

/**
 * class InfiniteScrollComponent
 * this component scrolls an asset of its parent infinitely around.
 */
class InfiniteScrollComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * this is the total time that passed since we started scrolling.
	 * it is used for the wave mode.
	 */
	private var m_total_time_elapsed:Float = 0;

	/**
	 * this is the mode - possible values are: "scroll" "wave"
	 */
	private var m_mode:ScrollMode;

	/**
	 * this is our parent object but cast to Scrollable interface
	 */
	private var m_scrollable:Scrollable;

	/**
	 * the scroll speed in horizontal direction
	 */
	private var m_scroll_speed_x:Float;

	/**
	 * the scroll speed in vertical direction
	 */
	private var m_scroll_speed_y:Float;

	/**
	 * ctor
	 */
	public function new()
	{
		super('InfiniteScrollComponent');
	}

	/**
	 * dtor
	 */
	override public function destroy()
	{
		m_scrollable = null;
		super.destroy();
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		// first we get all the proportions for the numberline:
		if (Reflect.hasField(jsonFile, "scroll_speed_x"))
		{
			m_scroll_speed_x = jsonFile.scroll_speed_x;
		}
		if (Reflect.hasField(jsonFile, "scroll_speed_y"))
		{
			m_scroll_speed_y = jsonFile.scroll_speed_y;
		}
		if (Reflect.hasField(jsonFile, "mode"))
		{
			if (jsonFile.mode == "Scroll")
			{
				m_mode = Scroll;
			}
			if (jsonFile.mode == "Wave")
			{
				m_mode = Wave;
			}
			if (jsonFile.mode == "Circle")
			{
				m_mode = Circle;
			}
		}
	}

	/**
	 * setParent - we override the setParent function so we can cast and make sure that the
	 * parent implements scrollable.
	 * @param parent - dnaobject to set as new parent.
	 */
	override public function setParent(parent:DnaObject)
	{
		this.m_parent_obj = parent;
		// parent must implement scrollable interface
		m_scrollable = cast(this.m_parent_obj, Scrollable);
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		var scroll_x = m_scroll_speed_x;
		var scroll_y = m_scroll_speed_y;
		m_total_time_elapsed += elapsed;
		if (m_mode == Wave)
		{
			scroll_x = Math.sin(m_total_time_elapsed) * m_scroll_speed_x;
			scroll_y = Math.sin(m_total_time_elapsed) * m_scroll_speed_y;
		}
		if (m_mode == Circle)
		{
			scroll_x = Math.sin(m_total_time_elapsed) * m_scroll_speed_x;
			scroll_y = Math.cos(m_total_time_elapsed) * m_scroll_speed_y;
		}

		var old_pos = m_scrollable.backdrop.getPosition();
		m_scrollable.backdrop.setPosition(old_pos.x + (elapsed * scroll_x), old_pos.y + (elapsed * scroll_y));
	}
}
