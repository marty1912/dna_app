package dnaobject.objects;

import dnadata.DnaDataManager;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import locale.LocaleManager;

/**
 * class TextBoxObject -
 * this class will be used to show text to the user in a nice box.
 *
 */
class TextBoxObject implements DnaObject extends DnaObjectBase
{
	public final CODE_NEXT_TRIAL_DESC = "NEXT_TRIAL_DESC";

	private var m_asset_path:String;
	private var m_scale_x:Float = 1;
	private var m_scale_y:Float = 1;
	var sprite:FlxSprite;

	var text_head:FlxText;
	var text_body:FlxText;
	var head_color:FlxColor;
	var body_color:FlxColor;

	var head_b_color:FlxColor;
	var body_b_color:FlxColor;

	var head_b_size:Float;
	var body_b_size:Float;

	var head_size:Int;
	var body_size:Int;
	var head_x:Float;
	var body_x:Float;
	var head_y:Float;
	var body_y:Float;
	var head_h:Float;
	var body_h:Float;
	var head_w:Float;
	var body_w:Float;

	/**
	 * this function returns the position on which the header should be.
	 * @return FlxPoint
	 */
	public function getHeadPos():FlxPoint
	{
		return this.getOrigin();
	}

	/**
	 * this function returns the position on which the body should be.
	 * @return FlxPoint
	 */
	public function getBodyPos():FlxPoint
	{
		return this.getOrigin();
	}

	/**
	 * setter for body text
	 * @param text
	 */
	public function setBody(text:String):Void
	{
		this.text_body.text = LocaleManager.getInstance().getString(text);
	}

	/**
	 * setter for head text
	 * @param text
	 */
	public function setHead(text:String):Void
	{
		this.text_head.text = LocaleManager.getInstance().getString(text);
	}

	/**
	 * in here we setup the positions for our text..
	 */
	public function setupPositions():Void
	{
		this.text_body.x = this.getBodyPos().x + body_x;
		this.text_body.y = this.getBodyPos().y + body_y;

		this.text_head.x = this.getHeadPos().x + head_x;
		this.text_head.y = this.getHeadPos().y + head_y;
	}

	/**
	 *  in here we setup all our text.
	 */
	public function setupText():Void
	{
		this.addChild(text_head);
		this.addChild(text_body);
		setupPositions();
		this.text_body.color = this.body_color;
		this.text_head.color = this.head_color;
		this.text_body.width = this.body_w;
		this.text_body.height = this.body_h;

		this.text_head.width = this.head_w;
		this.text_head.height = this.head_h;

		this.text_head.alignment = "center";
		this.text_body.alignment = "left";
		this.text_head.size = this.head_size;
		this.text_body.size = this.body_size;

		this.text_body.borderColor = this.body_b_color;
		this.text_body.borderSize = this.body_b_size;
		this.text_body.borderStyle = FlxTextBorderStyle.SHADOW;

		this.text_head.borderColor = this.head_b_color;
		this.text_head.borderSize = this.head_b_size;
		this.text_head.borderStyle = FlxTextBorderStyle.SHADOW;
	}

	/**
	 * ctor.
	 */
	public function new()
	{
		super("TextBoxObject");
		this.text_head = new FlxText();
		this.text_body = new FlxText();
	}

	/**
	 * loadAsset
	 */
	public function loadAsset()
	{
		sprite = new FlxSprite();
		sprite.loadGraphic(m_asset_path);
		this.sprite.setPosition(this.getOrigin().x, this.getOrigin().y);
		this.addChild(sprite);
	}

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "asset_path"))
		{
			this.m_asset_path = jsonFile.asset_path;
			this.loadAsset();
		}
		if (Reflect.hasField(jsonFile, "head"))
		{
			if (jsonFile.head == CODE_NEXT_TRIAL_DESC)
			{
				jsonFile.head = DnaDataManager.instance.getNextTrials().desc_head;
				jsonFile.body = DnaDataManager.instance.getNextTrials().desc_body;
			}
			this.setHead(jsonFile.head);
		}
		if (Reflect.hasField(jsonFile, "head_x"))
		{
			this.head_x = jsonFile.head_x;
		}
		if (Reflect.hasField(jsonFile, "head_y"))
		{
			this.head_y = jsonFile.head_y;
		}
		if (Reflect.hasField(jsonFile, "head_h"))
		{
			this.head_h = jsonFile.head_h;
		}
		if (Reflect.hasField(jsonFile, "head_w"))
		{
			this.head_w = jsonFile.head_w;
		}
		if (Reflect.hasField(jsonFile, "head_color"))
		{
			this.head_color = FlxColor.fromString(jsonFile.head_color);
		}
		if (Reflect.hasField(jsonFile, "head_b_color"))
		{
			this.head_b_color = FlxColor.fromString(jsonFile.head_b_color);
		}
		if (Reflect.hasField(jsonFile, "head_size"))
		{
			this.head_size = jsonFile.head_size;
		}
		if (Reflect.hasField(jsonFile, "head_b_size"))
		{
			this.head_b_size = jsonFile.head_b_size;
		}

		if (Reflect.hasField(jsonFile, "body"))
		{
			this.setBody(jsonFile.body);
		}
		if (Reflect.hasField(jsonFile, "body_x"))
		{
			this.body_x = jsonFile.body_x;
		}
		if (Reflect.hasField(jsonFile, "body_y"))
		{
			this.body_y = jsonFile.body_y;
		}
		if (Reflect.hasField(jsonFile, "body_h"))
		{
			this.body_h = jsonFile.body_h;
		}
		if (Reflect.hasField(jsonFile, "body_w"))
		{
			this.body_w = jsonFile.body_w;
		}
		if (Reflect.hasField(jsonFile, "body_color"))
		{
			this.body_color = FlxColor.fromString(jsonFile.body_color);
		}
		if (Reflect.hasField(jsonFile, "body_b_color"))
		{
			this.body_b_color = FlxColor.fromString(jsonFile.body_b_color);
		}
		if (Reflect.hasField(jsonFile, "body_b_size"))
		{
			this.body_b_size = jsonFile.body_b_size;
		}
		if (Reflect.hasField(jsonFile, "body_size"))
		{
			this.body_size = jsonFile.body_size;
			this.setupText();
		}

		super.fromFile(jsonFile);
	}
}
