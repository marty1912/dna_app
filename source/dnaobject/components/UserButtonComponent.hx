package dnaobject.components;

import Assertion.assert;
import dnaobject.interfaces.IStateMachine;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import openfl.display.Preloader.DefaultPreloader;

/**
 * this class is used to make our buttons interactice.
 */
class UserButtonComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * the area in which we register clicks or touches.
	 */
	public var m_click_area:FlxButton;

	/**
	 * ctor
	 */
	public function new()
	{
		super('UserButtonComponent');
		m_click_area = new FlxButton();
		m_click_area.allowSwiping = false;
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
		if (Reflect.hasField(jsonFile, "click_target"))
		{
			target_name = jsonFile.click_target;
		}
	}

	public var target_name:String = "";

	private var current_status:Int = FlxButton.NORMAL;

	/**
	 * this function sets our status member variable.
	 * @param status
	 */
	public function setStatus(status:Int)
	{
		// little hack to make buttons responsive on touchscreen.
		// (Highlight does somehow work there but it should not.)

		if (current_status != status)
		{
			current_status = status;
			onStatusChanged(current_status);
		}
	}

	public var state_machine:IStateMachine = null;

	/**
	 * this function will be called whenever the status of our click area changed.
	 */
	public function onStatusChanged(new_status:Int)
	{
		var parent:IStateMachine;
		if (state_machine == null)
		{
			parent = cast(this.getParent());
		}
		else
		{
			parent = state_machine;
		}

		switch (new_status)
		{
			case FlxButton.NORMAL:
				parent.setState(StateEnum.NORMAL);
			// parent.setNextState(new ButtonStateNormal());
			case FlxButton.HIGHLIGHT:
				parent.setState(StateEnum.HIGHLIGHT);
			// parent.setNextState(new ButtonStateHighlight());
			case FlxButton.PRESSED:
				parent.setState(StateEnum.PRESSED);
			// parent.setNextState(new ButtonStatePressed());
			default:
				assert(false);
		}
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

		var click_target:DnaObject;
		if (this.target_name != "")
		{
			click_target = this.getParent().getParent().getObjectByName(this.target_name);
			assert(click_target != null);
		}
		else
		{
			click_target = cast(this.getParent());
		}
		// var button:FlxSprite = click_target.button;

		this.m_click_area.width = click_target.getWidth();
		this.m_click_area.height = click_target.getHeight();
		// trace("userbutton: button height:", click_target.getHeight());
		// this.m_click_area.setPosition(button.getPosition().x, button.getPosition().y);
		this.m_click_area.setPosition(click_target.getOrigin().x, click_target.getOrigin().y);
		this.m_click_area.update(elapsed);

		this.setStatus(m_click_area.status);
	}
}
