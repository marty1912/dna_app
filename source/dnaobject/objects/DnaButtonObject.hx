package dnaobject.objects;

import Assertion.assert;
import dnaobject.components.ActionPlaySoundComponent;
import dnaobject.interfaces.Command;
import dnaobject.interfaces.CommandClient;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.Scrollable;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.animation.FlxAnimationController;
import flixel.ui.FlxButton;

/**
 * class DnaButtonObject
 * this class is used as our buttons
 *
 */
class DnaButtonObject implements DnaObject implements CommandClient implements IStateMachine extends DnaObjectBase
{
	public var animCtrl:FlxAnimationController;

	/**
	 * this is our actual button
	 */
	public var button:FlxSprite;

	/**
	 * this is the list of commands for this button
	 */
	public var command_list:Array<Command>;

	/**
	 * this is the path to our button image file.
	 */
	private var m_asset_path:String;

	/**
	 * parameter for button width
	 */
	private var m_btn_width:Int;

	/**
	 * parameter for button height
	 */
	private var m_btn_height:Int;

	/**
	 * wheter or not the button should be animated
	 */
	private var m_btn_animated:Bool;

	/**
	 * selects a target that can then be made clickable 
	 * by using this button.  then everything we want to do 
	 * with this thing can be done via the button (firing commands etc..)
	 */
	public var clickarea_target:String = "";

	/**
	 * we need to override this because we have buttons that are sprites and they loose the  scale otherwise
	 * @return Int
	 */
	override public function getHeight():Int
	{
		this.button.updateHitbox();
		return Std.int(Math.floor(this.button.height));
	}

	/**
	 * calculates the width of all the children in the curent configuration
	 * @return Float
	 */
	override public function getWidth():Int
	{
		this.button.updateHitbox();
		return Std.int(Math.floor(this.button.width));
	}

	/**
	 * we override this because it does not handle scaling otherwise
	 * @return array - An array with the values max_left max_right max up and max_down in this order.
	 */
	// override public function getMaxLeftRightUpDownFromOrigin():Array<Float>
	// {
	//	return [-0, this.getWidth(), 0, this.getHeight()];
	// }
	public var onSetStateCallback:StateEnum->Void;

	/**
	 * constructor.
	 */
	public function new()
	{
		super('DnaButtonObject');
		button = new FlxSprite(0, 0);
		addChild(button);
		command_list = new Array<Command>();
	}

	/**
	 * this is the callback we can use to do stuff on button press
	 */
	public var onPressCallback:Void->Void;

	/**
	 * this function is executed on button press.
	 * to be super clean we should put this functionality in a component but it will work from here as well
	 * and for buttons this is okay.
	 */
	public function onBtnPress()
	{
		if (onPressCallback != null)
		{
			onPressCallback();
		}

		for (command in this.command_list)
		{
			command.execute();
		}
	}

	/**
	 * override because we want the buttons to go half invisible when inactive.
	 * @param value
	 */
	override public function setActive(value:Bool)
	{
		super.setActive(value);
		if (this.active)
		{
			// this.button.alpha = 1;
			this.button.active = true;
		}
		else
		{
			// this.button.alpha = 0.5;
			this.button.active = false;
		}
	}

	/**
	 * sets the state.
	 * @param state - int - this is used as an enum code to select
	 */
	public function setState(state:StateEnum):Void
	{
		if (onSetStateCallback != null)
		{
			// we make it so we can override the default behaviour with our callback.
			onSetStateCallback(state);
			return;
		}
		switch (state)
		{
			case StateEnum.NORMAL:
				setNextState(new ButtonStateNormal());
			case StateEnum.HIGHLIGHT:
				setNextState(new ButtonStateHighlight());
			case StateEnum.PRESSED:
				setNextState(new ButtonStatePressed());
			default:
				assert(false);
		}
	}

	/**
	 * backdrop can read every constant it uses from a file..
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "width"))
		{
			m_btn_width = jsonFile.width;
		}
		if (Reflect.hasField(jsonFile, "height"))
		{
			m_btn_height = jsonFile.height;
		}
		if (Reflect.hasField(jsonFile, "animated"))
		{
			m_btn_animated = jsonFile.animated;
		}
		if (Reflect.hasField(jsonFile, "path"))
		{
			m_asset_path = jsonFile.path;
		}
		if (Reflect.hasField(jsonFile, "clickarea_target"))
		{
			clickarea_target = jsonFile.clickarea_target;
		}
		super.fromFile(jsonFile);
		this.initButton();
	}

	/**
	 * initButton() - in here we do the initial setup of the button members. like setting up the animation controller etc.
	 */
	public function initButton()
	{
		// trace("initbutton:", m_asset_path);
		button.loadGraphic(m_asset_path, m_btn_animated, m_btn_width, m_btn_height);
		animCtrl = new FlxAnimationController(button);
		this.setNextState(new ButtonStateNormal());
	}

	private var m_current_state:IState = null;

	/**
	 * part of the statemachine interface. in here we set our next state.
	 * @param next_state
	 */
	public function setNextState(next_state:IState)
	{
		if (m_current_state != null)
		{
			m_current_state.exit();
			m_current_state.setParent(null);
		}
		m_current_state = next_state;
		m_current_state.setParent(this);
		m_current_state.enter();
	}
}

/**
 * the normal state for a button. here the first
 */
class ButtonStateNormal implements IState
{
	public function new() {};

	public var parent:DnaButtonObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		// parent.button.alpha = 1;
		// on 0 we will have normal behavior
		parent.animCtrl.frameIndex = 0;
	}

	public function exit():Void {}
}

/**
 * the normal state for a button. here the first
 */
class ButtonStateInactive implements IState
{
	public function new() {};

	public var user_comp:DnaComponent = null;
	public var keyboard_comp:DnaComponent = null;
	public var parent:DnaButtonObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void {}

	public function onSetStateCallback(state:StateEnum)
	{
		// in the inactive state we do absolutely nothing.
		switch (state)
		{
			case StateEnum.NORMAL:
			case StateEnum.HIGHLIGHT:
			case StateEnum.PRESSED:
			default:
				assert(false);
		}
	}

	public function enter():Void
	{
		parent.onSetStateCallback = this.onSetStateCallback;
		// on 0 we will have normal behavior
		parent.animCtrl.frameIndex = 3;
	}

	public function exit():Void
	{
		// here we have to add the interactive part again (if not null)
		parent.onSetStateCallback = null;
	}
}

/**
 * the normal state for a button. here the first
 */
class ButtonStateHidden implements IState
{
	public var parent:DnaButtonObject = null;

	public function new() {};

	public function onSetStateCallback(state:StateEnum)
	{
		// in the inactive state we do absolutely nothing.
		switch (state)
		{
			case StateEnum.NORMAL:
			case StateEnum.HIGHLIGHT:
			case StateEnum.PRESSED:
			default:
				assert(false);
		}
	}

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		// on 0 we will have normal behavior
		parent.onSetStateCallback = this.onSetStateCallback;
		parent.animCtrl.frameIndex = 3;
		parent.button.alpha = 0;
	}

	public function exit():Void
	{
		parent.button.alpha = 1;
		parent.onSetStateCallback = null;
	}
}

/**
 * the normal state for a button. here the first
 */
class ButtonStateHighlight implements IState
{
	public function new() {};

	public var parent:DnaButtonObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		// parent.button.alpha = 1;
		// on 0 we will have normal behavior
		parent.animCtrl.frameIndex = 1;
	}

	public function exit():Void {}
}

/**
 * the normal state for a button. here the first
 */
class ButtonStatePressed implements IState
{
	public function new() {};

	public var parent:DnaButtonObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		// trace(this.parent.id, "button pressed", this.parent.obj_name); // parent.button.alpha = 1;
		// on 0 we will have normal behavior
		parent.animCtrl.frameIndex = 2;
		// play sound on press
		var sound:ActionPlaySoundComponent = new ActionPlaySoundComponent();
		sound.path = "assets/sounds/kenney_interfacesounds/Audio/select_001.ogg";
		sound.setupSound();
		parent.addComponent(sound);

		parent.onBtnPress();
	}

	public function exit():Void
	{
		// play sound on release
		// var sound:ActionPlaySoundComponent = new ActionPlaySoundComponent();
		// sound.path = "assets/sounds/kenney_interfacesounds/Audio/select_001.mp3";
		// sound.setupSound();
		// parent.addComponent(sound);
	}
}
