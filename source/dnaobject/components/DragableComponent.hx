package dnaobject.components;

import Assertion.assert;
import dnaEvent.DnaEvent;
import dnaobject.components.SymbolSlotComponent.SymbolStateEmpty;
import dnaobject.components.SymbolSlotComponent.SymbolStateFilled;
import dnaobject.components.SymbolSlotComponent.SymbolStatePreview;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.SpriteObject;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class is used so we can read events from a file.
 */
class DragableComponent implements DnaComponent implements IStateMachine extends DnaActionBase
{
	public static var currently_dragged_sprite:SpriteObject = null;

	/**
	 * ctor
	 */
	public function new()
	{
		super("DragableComponent");
	}

	public function setNextState(next_state:IState):Void
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

	private var m_current_state:IState;

	public var setStateCallback:StateEnum->Void = null;

	public function setState(state:StateEnum):Void
	{
		if (setStateCallback != null)
		{
			setStateCallback(state);
			return;
		}
		switch (state)
		{
			case StateEnum.NORMAL:
				setNextState(new DragStateNormal());
			case StateEnum.HIGHLIGHT:
				setNextState(new DragStateHighlight());
			case StateEnum.PRESSED:
				setNextState(new DragStatePressed());
			default:
				assert(false);
		}
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "event_name")) {}
		super.fromFile(jsonFile);
	}

	public var user_button:UserButtonComponent;

	/**
	 * 
	 */
	override public function onHaveParent()
	{
		this.setNextState(new DragStateNormal());
		user_button = cast DnaComponentFactory.create("UserButtonComponent");
		user_button.m_click_area.allowSwiping = false;
		// user_button.target_name = this.getParent().obj_name;
		user_button.state_machine = this;
		user_button.setParent(this.getParent());
	}

	/**
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		this.m_current_state.update(elapsed);
		//	user_button.update(elapsed);
	}
}

/**
 * the normal state for a button. here the first
 */
class DragStateNormal implements IState
{
	public function new() {};

	public var parent:DragableComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		parent.user_button.update(elapsed);
	}

	public function enter():Void
	{
		// parent.button.alpha = 1;
		// on 0 we will have normal behavior
		// parent.animCtrl.frameIndex = 0;
	}

	public function exit():Void {}
}

/**
 * the normal state for a button. here the first
 */
class DragStateHighlight implements IState
{
	public function new() {};

	public var parent:DragableComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		parent.user_button.update(elapsed);
	}

	public function enter():Void
	{
		var sprite_obj:SpriteObject = (cast this.parent.getParent());
		sprite_obj.sprite.flipX = true;
	}

	public function exit():Void
	{
		var sprite_obj:SpriteObject = (cast this.parent.getParent());
		sprite_obj.sprite.flipX = false;
	}
}

/**
 * the normal state for a button. here the first
 */
class DragStatePressed implements IState
{
	public function new() {};

	public var parent:DragableComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	var sprite_obj:SpriteObject;

	public function onSetState(state:StateEnum)
	{
		switch (state)
		{
			case StateEnum.NORMAL:
				parent.setNextState(new DragStateNormal());
			case StateEnum.HIGHLIGHT:
				parent.setNextState(new DragStateHighlight());
			case StateEnum.PRESSED:
			// do nothing here so we stay in the state and dont enter it 1000 times..
			default:
				assert(false);
		}
	}

	public function update(elapsed:Float):Void
	{
		#if FLX_MOUSE
		var mouse_pos = FlxG.mouse.getScreenPosition();
		#end
		#if FLX_TOUCH
		var mouse_pos = FlxG.touches.getFirst().getScreenPosition();
		#end
		var move_to_x = mouse_pos.x - (sprite_obj.width / 2);
		var move_to_y = mouse_pos.y - (sprite_obj.height / 2);
		sprite_obj.moveTo(move_to_x, move_to_y);

		parent.user_button.update(elapsed);
	}

	var initial_pos_x:Float;
	var initial_pos_y:Float;

	public function enter():Void
	{
		parent.setStateCallback = this.onSetState;
		sprite_obj = cast this.parent.getParent();
		DragableComponent.currently_dragged_sprite = sprite_obj;
		initial_pos_x = sprite_obj.getOrigin().x;
		initial_pos_y = sprite_obj.getOrigin().y;
		// we want our dragged object on top of everything else.
		sprite_obj.removeChild(sprite_obj.sprite);
		sprite_obj.addChild(sprite_obj.sprite);
	}

	public function exit():Void
	{
		// TODO: this is not how we want it to be.
		// each time we pick up a new thing all the other slots will go back to "NORMAL" state

		DragableComponent.currently_dragged_sprite = null;

		sprite_obj = cast this.parent.getParent();
		sprite_obj.moveTo(initial_pos_x, initial_pos_y);

		parent.setStateCallback = null;
	}
}
