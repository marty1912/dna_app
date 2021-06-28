package dnaobject.objects;

import dnaobject.interfaces.Scrollable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.debug.Window;
import flixel.util.FlxColor;

/**
 * class SpriteObject -
 * this class will be used for example to create the "Finger" in our tutorials.
 *
 */
class SpriteObject implements DnaObject implements Scrollable extends DnaObjectBase
{
	private var m_asset_path:String;
	private var m_scale_x:Float = 1;
	private var m_scale_y:Float = 1;
	private var animated = false;
	private var asset_height = 0;
	private var asset_width = 0;

	public var sprite:FlxSprite;

	/**
	 * properties to make tweens easy to use.
	 */
	public var width(get, set):Float;

	/**
	 * properties to make tweens easy to use.
	 */
	public var height(get, set):Float;

	public function set_width(value:Float):Float
	{
		var have_width:Float = this.getWidth();
		if (have_width == 0)
		{
			have_width = 1;
			// kind of a hack but it will probably do the trick.
			sprite.scale.x = 0.001;
		}
		this.sprite.scale.x = (value / have_width) * this.sprite.scale.x;
		return value;
	}

	public function get_width():Float
	{
		return this.getWidth();
	}

	public function set_height(value:Float):Float
	{
		var have_height = this.getHeight();
		this.sprite.scale.y = (value / have_height) * this.sprite.scale.y;
		return value;
	}

	public function get_height():Float
	{
		return this.getHeight();
	}

	/**
	 * getter for asset path.
	 */
	public function setAssetPath(value:String)
	{
		m_asset_path = value;
		this.loadAsset();
	}

	public function setPosition(value:FlxPoint)
	{
		this.sprite.setPosition(value.x, value.y);
	}

	public function getPosition():FlxPoint
	{
		return this.sprite.getPosition();
	}

	public override function onReady()
	{
		super.onReady();
		this.removeChild(sprite);
		this.addChild(sprite);
	}

	/**
	 * getter for asset path.
	 */
	public function getAssetPath()
	{
		return m_asset_path;
	}

	/**
	 * returns the width
	 */
	override public function getWidth():Int
	{
		if (this.m_asset_path == "INVISIBLE_BOX")
		{
			return Std.int(this.m_scale_x);
		}

		this.sprite.updateHitbox();
		return Std.int(this.sprite.width);
	}

	/**
	 * returns the width
	 */
	override public function getHeight():Int
	{
		if (this.m_asset_path == "INVISIBLE_BOX")
		{
			return Std.int(this.m_scale_y);
		}

		this.sprite.updateHitbox();
		return Std.int(this.sprite.height);
	}

	public function setScale(x:Float, y:Float)
	{
		if (this.m_scale_from_screen_height || this.m_scale_from_screen_width)
		{
			var want_scale = FlxPoint.get();
			want_scale.x = (x / sprite.width);
			want_scale.y = (y / sprite.height);
			if (want_scale.x != want_scale.y)
			{
				want_scale.x = want_scale.y;
			}
			sprite.scale.x = want_scale.x;
			sprite.scale.y = want_scale.y;
		}
		else
		{
			sprite.scale.x = x;
			sprite.scale.y = y;
		}

		this.sprite.updateHitbox();
	}

	/**
	 * ctor.
	 */
	public function new()
	{
		super("SpriteObject");
		sprite = new FlxSprite();
		this.addChild(sprite);
	}

	/**
	 * sets up the origin on the specified position (specified with where)
	 * @param where - where to put the origin
	 *  - "mid" - in the  middle of the sprite
	 *  - "mid_top" - top in the middle
	 */
	public function setupOrigin(where:String)
	{
		if (where == "mid")
		{
			this.setOrigin(sprite.getMidpoint().x, sprite.getMidpoint().y);
		}
		else if (where == "center")
		{
			this.setOrigin(sprite.getMidpoint().x, sprite.getMidpoint().y);
		}
		else if (where == "mid_top")
		{
			this.setOrigin(sprite.getMidpoint().x, sprite.getMidpoint().y - ((sprite.height / 2) * m_scale_y));
		}
	}

	/**
	 * loadAsset
	 */
	public function loadAsset()
	{
		if (m_asset_path == "")
		{
			return;
		}
		if (m_asset_path == "INVISIBLE_BOX")
		{
			sprite.makeGraphic(Std.int(m_scale_x), Std.int(m_scale_y), FlxColor.WHITE);

			sprite.alpha = 0.0;
		}
		else
		{
			sprite.loadGraphic(m_asset_path, animated, asset_width, asset_height);
			setScale(m_scale_x, m_scale_y);
		}
		// this.addChild(sprite);
	}

	private var m_scale_from_screen_width:Bool = false;
	private var m_scale_from_screen_height:Bool = false;

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "scale_from_screen_width"))
		{
			this.m_scale_from_screen_width = jsonFile.scale_from_screen_width;
		}
		if (Reflect.hasField(jsonFile, "scale_x"))
		{
			if (m_scale_from_screen_width)
			{
				this.m_scale_x = FlxG.width * jsonFile.scale_x;
			}
			else
			{
				this.m_scale_x = jsonFile.scale_x;
			}
		}
		if (Reflect.hasField(jsonFile, "scale_from_screen_height"))
		{
			this.m_scale_from_screen_height = jsonFile.scale_from_screen_height;
		}
		if (Reflect.hasField(jsonFile, "scale_y"))
		{
			if (m_scale_from_screen_height)
			{
				this.m_scale_y = FlxG.height * jsonFile.scale_y;
			}
			else
			{
				this.m_scale_y = jsonFile.scale_y;
			}
		}

		if (Reflect.hasField(jsonFile, "animated"))
		{
			this.animated = jsonFile.animated;
		}

		if (Reflect.hasField(jsonFile, "asset_height"))
		{
			this.asset_height = jsonFile.asset_height;
		}
		if (Reflect.hasField(jsonFile, "asset_width"))
		{
			this.asset_width = jsonFile.asset_width;
		}

		if (Reflect.hasField(jsonFile, "asset_path"))
		{
			this.m_asset_path = jsonFile.asset_path;
			this.loadAsset();
		}
		if (Reflect.hasField(jsonFile, "origin_where"))
		{
			var origin_where = jsonFile.origin_where;
			this.setupOrigin(origin_where);
		}
		super.fromFile(jsonFile);
	}
}
