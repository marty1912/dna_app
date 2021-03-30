package dnaobject.components;

import Assertion.assert;
import dnaobject.interfaces.IStateMachine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import openfl.display.Preloader.DefaultPreloader;

/**
 * this class is used to make our buttons interactice.
 */
class KeyboardInputComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * the list of keys for which we register clicks
	 */
	public var keys_list:Array<FlxKey> = new Array<FlxKey>();

	/**
	 * ctor
	 */
	public function new()
	{
		super('KeyboardInputComponent');
	}

	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "keys"))
		{
			var keys:Array<Dynamic> = jsonFile.keys;
			for (key in keys)
			{
				this.keys_list.push(FlxKey.fromString(key));
			}
		}
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
	}

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

		#if FLX_KEYBOARD
		if (FlxG.keys.anyPressed(this.keys_list))
		{
			this.setStatus(FlxButton.PRESSED);
		}
		else
		{
			this.setStatus(FlxButton.NORMAL);
		}
		#end
	}
}
