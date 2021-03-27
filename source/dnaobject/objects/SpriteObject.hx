package dnaobject.objects;

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
class SpriteObject implements DnaObject extends DnaObjectBase
{
	private var m_asset_path:String;
	private var m_scale_x:Float = 1;
	private var m_scale_y:Float = 1;
	var sprite:FlxSprite;

	public function setScale(x, y)
	{
		sprite.scale.x = x;
		sprite.scale.y = y;
		m_scale_x = x;
		m_scale_y = y;
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
		trace("load asset..");
		if (m_asset_path == "")
		{
			return;
		}
		if (m_asset_path == "INVISIBLE_BOX")
		{
			sprite.makeGraphic(Std.int(m_scale_x), Std.int(m_scale_y), FlxColor.WHITE);

			sprite.alpha = 0;
		}
		else
		{
			sprite.loadGraphic(m_asset_path);
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
