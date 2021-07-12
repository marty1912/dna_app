package dnaobject.components;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEvent;
import dnaEvent.DnaEventManager;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.SpriteObject;
import flixel.FlxG;

/**
 * this class is used so we can read events from a file.
 */
class SymbolSlotComponent implements DnaComponent implements IStateMachine extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("SymbolSlotComponent");
	}

	public static var all_slots:Array<SymbolSlotComponent> = new Array<SymbolSlotComponent>();

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
		}
	}

	public var disabled(get, set):Bool;

	public function get_disabled():Bool
	{
		return !this.user_button.active;
	}

	public function set_disabled(value:Bool):Bool
	{
		this.user_button.active = !value;
		return value;
	}

	public var filled(get, null):Bool;

	public function get_filled()
	{
		if (Std.isOfType(m_current_state, SymbolStateFilled))
		{
			return true;
		}
		if (Std.isOfType(m_current_state, SymbolStateHiglight))
		{
			return true;
		}
		return false;
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
		this.setNextState(new SymbolStateEmpty());
		user_button = cast DnaComponentFactory.create("UserButtonComponent");
		user_button.m_click_area.allowSwiping = false;
		// user_button.target_name = this.getParent().obj_name;
		user_button.state_machine = this;
		user_button.setParent(this.getParent());

		all_slots.push(this);
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
class SymbolStateEmpty implements IState
{
	public function new() {};

	public var parent:SymbolSlotComponent = null;
	public var sprite_obj:SpriteObject;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		// parent.user_button.update(elapsed);
		var check_overlap = DragableComponent.currently_dragged_sprite;
		if (check_overlap == null)
		{
			return;
		}
		var overlap = FlxG.overlap(sprite_obj.sprite, check_overlap.sprite);
		if (overlap)
		{
			parent.setNextState(new SymbolStatePreview(check_overlap));
		}
	}

	var old_width:Float;
	var old_height:Float;
	var old_asset_path:String;

	// public final empty_symbol_asset:String = "assets/images/pattern_symbols/question_mark.PNG";

	public function enter():Void
	{
		sprite_obj = (cast this.parent.getParent());

		/*
			old_asset_path = sprite_obj.getAssetPath();
			old_width = sprite_obj.getWidth();
			old_height = sprite_obj.getHeight();
			sprite_obj.setAssetPath(empty_symbol_asset);
			sprite_obj.loadAsset();
			sprite_obj.setMaxDimensions(old_width, old_height);
		 */

		// parent.button.alpha = 1;
		// on 0 we will have normal behavior
		// parent.animCtrl.frameIndex = 0;
	}

	public function exit():Void {}
}

/**
 * the normal state for a button. here the first
 */
class SymbolStatePreview implements IState
{
	public function new(overlapping:SpriteObject)
	{
		this.overlapping = overlapping;
	};

	public var parent:SymbolSlotComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		var released = false;
		#if FLX_MOUSE
		released = FlxG.mouse.justReleased;
		#end

		#if FLX_TOUCH
		if (FlxG.touches.justReleased().length != 0)
		{
			released = true;
		}
		#end

		if (released)
		{
			parent.setNextState(new SymbolStateFilled(this.overlapping.getAssetPath()));
			return;
		}
		// parent.user_button.update(elapsed);
		var check_overlap = overlapping;
		if (check_overlap == null)
		{
			return;
		}
		if (check_overlap == null)
		{
			return;
		}
		var overlap = FlxG.overlap(sprite_obj.sprite, check_overlap.sprite);
		if (!overlap)
		{
			parent.setNextState(new SymbolStateEmpty());
			return;
		}
	}

	public var sprite_obj:SpriteObject;
	public var overlapping:SpriteObject;
	public var asset_path:String;

	public var old_asset_path:String;
	public var old_width:Int;
	public var old_height:Int;

	public function enter():Void
	{
		sprite_obj = (cast this.parent.getParent());
		old_asset_path = sprite_obj.getAssetPath();
		old_width = sprite_obj.getWidth();
		old_height = sprite_obj.getHeight();
		sprite_obj.setAssetPath(overlapping.getAssetPath());
		sprite_obj.loadAsset();
		sprite_obj.setMaxDimensions(old_width, old_height);
	}

	public function exit():Void
	{
		sprite_obj.setAssetPath(old_asset_path);
		sprite_obj.loadAsset();
		sprite_obj.setMaxDimensions(old_width, old_height);
	}
}

/**
 * the normal state for a button. here the first
 */
class SymbolStateFilled implements IState
{
	public function new(asset_path:String)
	{
		this.asset_path = asset_path;
	};

	public var parent:SymbolSlotComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		parent.user_button.update(elapsed);
	}

	public function onButtonStateChanged(state:StateEnum)
	{
		switch (state)
		{
			case StateEnum.NORMAL:
			case StateEnum.HIGHLIGHT:
				var check_overlap = DragableComponent.currently_dragged_sprite;
				if (check_overlap == null)
				{
					parent.setNextState(new SymbolStateHiglight(this.asset_path));
					return;
				}
				var overlap = FlxG.overlap(sprite_obj.sprite, check_overlap.sprite);
				if (!overlap)
				{
					parent.setNextState(new SymbolStateHiglight(this.asset_path));
				}

			case StateEnum.PRESSED:
				parent.setNextState(new SymbolStatePressed());
			default:
				assert(false);
		}
	}

	public var sprite_obj:SpriteObject;
	public var asset_path:String;
	public var old_asset_path:String;
	public var old_width:Int;
	public var old_height:Int;

	public function enter():Void
	{
		sprite_obj = (cast this.parent.getParent());
		parent.setStateCallback = this.onButtonStateChanged;

		old_width = sprite_obj.getWidth();
		old_height = sprite_obj.getHeight();
		old_asset_path = sprite_obj.getAssetPath();
		sprite_obj.setAssetPath(asset_path);
		sprite_obj.loadAsset();
		sprite_obj.setMaxDimensions(old_width, old_height);
		sprite_obj.getParent().eventManager.broadcastEvent(DnaConstants.PATTERN_CHANGE);
	}

	public function exit():Void
	{
		sprite_obj.setAssetPath(old_asset_path);
		sprite_obj.loadAsset();
		sprite_obj.setMaxDimensions(old_width, old_height);
		parent.setStateCallback = null;
	}
}

/**
 * the normal state for a button. here the first
 */
class SymbolStateHiglight implements IState
{
	public function new(asset_path:String)
	{
		this.asset_path = asset_path;
	};

	public var parent:SymbolSlotComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		parent.user_button.update(elapsed);
	}

	public function onButtonStateChanged(state:StateEnum)
	{
		switch (state)
		{
			case StateEnum.NORMAL:
				parent.setNextState(new SymbolStateFilled(asset_path));
			case StateEnum.HIGHLIGHT:
			case StateEnum.PRESSED:
				parent.setNextState(new SymbolStatePressed());
			default:
				assert(false);
		}
	}

	public var sprite_obj:SpriteObject;
	public var asset_path:String;
	public var old_asset_path:String;
	public var old_width:Int;
	public var old_height:Int;

	public final shrink_factor = 0.8;

	public final cross_asset:String = "assets/images/pattern_symbols/x.PNG";

	var cross_sprite:SpriteObject;

	public function enter():Void
	{
		sprite_obj = (cast this.parent.getParent());
		parent.setStateCallback = this.onButtonStateChanged;

		// show the asset
		old_width = sprite_obj.getWidth();
		old_height = sprite_obj.getHeight();
		old_asset_path = sprite_obj.getAssetPath();
		sprite_obj.setAssetPath(asset_path);
		sprite_obj.loadAsset();
		sprite_obj.setMaxDimensions(old_width, old_height);
		sprite_obj.sprite.alpha = 0.5;

		// add a cross on top of the thing
		cross_sprite = cast DnaObjectFactory.create("SpriteObject");
		cross_sprite.setAssetPath(cross_asset);
		cross_sprite.loadAsset();
		cross_sprite.setMaxDimensions(sprite_obj.width, sprite_obj.height);
		sprite_obj.getParent().addObject(cross_sprite);
		cross_sprite.moveTo(sprite_obj.getOrigin().x, sprite_obj.getOrigin().y);
		cross_sprite.removeChild(cross_sprite.sprite);
		cross_sprite.addChild(cross_sprite.sprite);
		cross_sprite.sprite.alpha = 0.0;
	}

	public function exit():Void
	{
		// reset the sprite

		sprite_obj.sprite.alpha = 1.0;
		sprite_obj.setAssetPath(old_asset_path);
		sprite_obj.loadAsset();
		sprite_obj.setMaxDimensions(old_width, old_height);

		// remove the cross.
		sprite_obj.getParent().removeObject(cross_sprite.id);
		parent.setStateCallback = null;
	}
}

/**
 * the normal state for a button. here the first
 */
class SymbolStatePressed implements IState
{
	public function new() {};

	public var parent:SymbolSlotComponent = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void
	{
		parent.user_button.update(elapsed);
	}

	public function onButtonStateChanged(state:StateEnum)
	{
		switch (state)
		{
			case StateEnum.NORMAL:
				parent.setNextState(new SymbolStateEmpty());
			case StateEnum.HIGHLIGHT:
				parent.setNextState(new SymbolStateEmpty());
			case StateEnum.PRESSED:
			default:
				assert(false);
		}
	}

	public var sprite_obj:SpriteObject;
	public var asset_path:String;
	public var old_asset_path:String;
	public var old_width:Int;
	public var old_height:Int;

	public final cross_asset:String = "assets/images/pattern_symbols/x.PNG";

	var cross_sprite:SpriteObject;

	public function enter():Void
	{
		sprite_obj = (cast this.parent.getParent());
		this.parent.setStateCallback = this.onButtonStateChanged;

		sprite_obj.sprite.alpha = 0.5;
		// add a cross on top of the thing
		cross_sprite = cast DnaObjectFactory.create("SpriteObject");
		cross_sprite.setAssetPath(cross_asset);
		cross_sprite.loadAsset();
		cross_sprite.setMaxDimensions(sprite_obj.width, sprite_obj.height);
		sprite_obj.getParent().addObject(cross_sprite);
		cross_sprite.moveTo(sprite_obj.getOrigin().x, sprite_obj.getOrigin().y);
		cross_sprite.removeChild(cross_sprite.sprite);
		cross_sprite.addChild(cross_sprite.sprite);

		// added to basically remove the crosssprite as it caused confusion.
		cross_sprite.sprite.alpha = 0.0;

		sprite_obj.getParent().eventManager.broadcastEvent(DnaConstants.PATTERN_CHANGE);
	}

	public function exit():Void
	{
		this.parent.setStateCallback = null;

		sprite_obj.sprite.alpha = 1.0;
		// remove the cross.
		sprite_obj.getParent().removeObject(cross_sprite.id);
	}
}
