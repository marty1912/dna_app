package dnaobject.components;

import Assertion.assert;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.DnaButtonObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import openfl.display.Preloader.DefaultPreloader;

/**
 * this class is used to make our buttons interactice.
 */
class UserMontiComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * the area in which we register clicks or touches.
	 */
	private var m_click_area:FlxButton;

	/**
	 * ctor
	 */
	public function new()
	{
		super('UserMontiComponent');
		m_click_area = new FlxButton();
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
	override public function fromFile(jsonFile:Dynamic) {}

	private var current_status:Int = FlxButton.NORMAL;

	/**
	 * this function sets our status member variable.
	 * @param status
	 */
	public function setStatus(status:Int)
	{
		if (current_status != status)
		{
			current_status = status;
			onStatusChanged(current_status);
		}
	}

	/**
	 * this function will be called whenever the status of our click area changed.
	 */
	public function onStatusChanged(new_status:Int)
	{
		var parent:IStateMachine = cast(this.getParent());
		switch (new_status)
		{
			case FlxButton.NORMAL:
				parent.setNextState(new ButtonStateNormal());
			case FlxButton.HIGHLIGHT:
				parent.setNextState(new ButtonStateHighlight());
			case FlxButton.PRESSED:
				parent.setNextState(new ButtonStatePressed());
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
		var parent:DnaObject = cast(this.getParent());

		this.m_click_area.width = parent.getWidth();
		this.m_click_area.height = parent.getHeight();
		this.m_click_area.setPosition(parent.getOrigin().x, parent.getOrigin().y);
		this.m_click_area.update(elapsed);

		this.setStatus(m_click_area.status);
	}
}
