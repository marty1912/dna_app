package dnaobject.objects;

import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.math.FlxPoint;
import flixel.system.debug.Window;
import flixel.util.FlxColor;
import lime.math.Rectangle;

/**
 * class NineSliceSprite -
 * this class will be used for example to create the "Finger" in our tutorials.
 *
 */
class NineSliceSprite implements DnaObject extends DnaObjectBase
{
	private var m_asset_path:String;
	private var m_scale_x:Float = 1;
	private var m_scale_y:Float = 1;
	var nineSliceSprite:FlxUI9SliceSprite;

	public var grid:Array<Int>;

	/**
	 * getter for asset path.
	 */
	public function setAssetPath(value:String)
	{
		m_asset_path = value;
		setupSprite();
	}

	/**
	 * getter for asset path.
	 */
	public function getAssetPath()
	{
		return m_asset_path;
	}

	public function setScale(x, y)
	{
		m_scale_x = x;
		m_scale_y = y;
	}

	/**
	 * ctor.
	 */
	public function new()
	{
		super("NineSliceSprite");
		// nineSliceSprite = new FlxSprite();
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
		}

		if (Reflect.hasField(jsonFile, "grid"))
		{
			this.grid = jsonFile.grid;
		}

		setupSprite();

		super.fromFile(jsonFile);
	}

	/**
	 * setupSprite()
	 */
	public function setupSprite()
	{
		if (nineSliceSprite != null)
		{
			this.removeChild(nineSliceSprite);
			nineSliceSprite.destroy();
			nineSliceSprite = null;
		}
		width = Std.int(m_scale_x);
		height = Std.int(m_scale_y);
		nineSliceSprite = new FlxUI9SliceSprite(0, 0, m_asset_path, new flash.geom.Rectangle(0, 0, m_scale_x, m_scale_y), this.grid);

		this.addChild(nineSliceSprite);
	}

	public var width(get, set):Int;
	public var height(get, set):Int;

	public function get_width():Int
	{
		return Std.int(m_scale_x);
	}

	public function set_width(value:Int):Int
	{
		if (this.nineSliceSprite == null)
		{
			return value;
		}
		this.m_scale_x = Std.int(value);
		this.nineSliceSprite.resize(width, height);
		return value;
	}

	public function get_height():Int
	{
		return Std.int(m_scale_y);
	}

	public function set_height(value:Int):Int
	{
		if (this.nineSliceSprite == null)
		{
			return value;
		}
		this.m_scale_x = Std.int(value);
		this.nineSliceSprite.resize(width, height);
		return value;
	}

	/**
	 * onHaveParent - this function is called when we have a parent
	 * in here we will create our sprite
	 */
	override public function onHaveParent()
	{
		// var grid:Array<Int> = [100, 100, 400, 200];
	}
}
