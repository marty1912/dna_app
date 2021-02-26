package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.components.ActionSetSliderPosComponent;
import dnaobject.interfaces.Slideable;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import osspec.OsManager;

/**
 * class PositionComponent.
 * this component keeps its parent in the center of the screen.
 */
class SliderComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * the area in which we register clicks or touches.
	 */
	private var m_click_area:FlxButton;

	/**
	 * this is the size of the click area relative to the slider sprite the user gives us.
	 * x direction
	 */
	private var m_pad_f_x:Float;

	/**
	 * this is the size of the click area relative to the slider sprite the user gives us.
	 * y direction
	 */
	private var m_pad_f_y:Float;

	/**
	 * ctor
	 */
	public function new()
	{
		super('SliderComponent');
		m_click_area = new FlxButton(0, 0, null, onClickAreaPress);
	}

	/**
	 * onClickAreaPress. this function will be called whenever the ClickArea (button) is pressed
	 */
	public function onClickAreaPress()
	{
		// play sound on press
		var sound:ActionPlaySoundComponent = new ActionPlaySoundComponent();
		sound.path = "assets/sounds/kenney_interfacesounds/Audio/select_001.ogg";
		sound.setupSound();
		getParent().addComponent(sound);
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
		FlxDestroyUtil.destroy(this.m_click_area);
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		if (Reflect.hasField(jsonFile, "click_area_pad_x"))
		{
			// this is the wrong way around i know. but it works like this..
			this.m_pad_f_x = jsonFile.click_area_pad_x;
		}
		if (Reflect.hasField(jsonFile, "click_area_pad_y"))
		{
			this.m_pad_f_y = jsonFile.click_area_pad_y;
		}
	}

	/**
	 * setParent - we override the setParent function so we can cast and make sure that the
	 * parent implements slideable.
	 * @param parent
	 */
	override public function setParent(parent:DnaObject)
	{
		this.m_parent_obj = parent;
		// parent must implement slideable interface
		var slide = cast(this.m_parent_obj, Slideable);
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// as this is an interactive component we do not want to run the update function if it is set inactive
		if (!active)
		{
			return;
		}

		var axis = cast(this.getParent(), Slideable).axis;

		this.m_click_area.width = axis.width * this.m_pad_f_x;
		this.m_click_area.height = axis.height * this.m_pad_f_y;
		this.m_click_area.setPosition(axis.getPosition().x - ((this.m_click_area.width - axis.width) / 2),
			axis.getPosition().y - ((this.m_click_area.height - axis.height) / 2));
		this.m_click_area.update(elapsed);
		if (this.m_click_area.status == FlxButton.PRESSED)
		{
			var mouse_pos = OsManager.get_instance().getInputPosition();

			// if we dont have a valid mouse position here then there is no point in doing anything else..
			if (mouse_pos == null)
			{
				return;
			}
			var action:ActionSetSliderPosComponent = cast DnaComponentFactory.create("ActionSetSliderPosComponent");
			action.setTarget(this.getParent().obj_name);
			action.setPosition(mouse_pos);
			this.getParent().addComponent(action);
		}
	}
}
