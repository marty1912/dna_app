package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnadata.DnaDataManager;
import dnaobject.interfaces.ITextBox;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import locale.LocaleManager;
import textbox.Settings;
import textbox.Textbox;

/**
 * class StaticTextObject -
 * this class will be used to show text to the user that runs from left to right
 *
 */
class StaticTextObject implements DnaObject implements ITextBox extends DnaObjectBase
{
	public static final CODE_NEXT_TRIAL_DESC = "NEXT_TRIAL_DESC";
	public static final CODE_NEXT_TRIAL_HEAD = "NEXT_TRIAL_HEAD";

	public var text_box:FlxText;
	public var settings:Settings;
	public var autostart:Bool = false;
	public var use_literal_text:Bool = false;

	/**
	 * returns the name of the event that is fired when the whole text has been displayed.
	 * @return String
	 */
	public function getEventFinName():String
	{
		return this.obj_type + "_" + this.obj_name + "_" + this.id + "_done";
	}

	public var onFinCallback:Void->Void;

	/**
	 * start() - starts displaying the text.
	 */
	public function start():Void
	{
		this.text_box.alpha = 1;
		this.getParent().eventManager.broadcastEvent(this.getEventFinName());
		if (this.onFinCallback != null)
		{
			onFinCallback();
		}
	}

	public static final default_fontsize:Int = 32;
	public static final default_width:Int = 320;
	public static final default_char_per_sec:Int = 24;
	public static final default_n_lines:Int = 3;
	public static final default_color:String = "0xFFFFFF";
	public static final default_border_color:String = "0xFFFFFF";
	public static final default_border:String = "NONE";

	public var border_color:String = "0xFFFFFF";
	public var border:String = "NONE";

	/**
	 * ctor.
	 */
	public function new()
	{
		super("StaticTextObject");
		text_box = new FlxText();
		text_box.alpha = 0;
		this.addChild(text_box);
	}

	/**
	 * setter for text
	 * @param value
	 */
	public function getText():String
	{
		return this.text_box.text;
	}

	/**
	 * setter for text
	 * @param value
	 */
	public function setText(value:String, ?use_literal_text:Bool = false):Void
	{
		// this.getChildren().remove(text_box);

		// trace("settext,", border_color);
		var real_string:String;
		if (use_literal_text)
		{
			real_string = value;
		}
		else
		{
			real_string = LocaleManager.getInstance().getString(value);
		}
		if (real_string == DnaConstants.CODE_ID)
		{
			real_string = DnaDataManager.instance.retrieveData(DnaDataManager.instance.PART_UUID);
		}

		this.text_box.text = real_string;
		this.text_box.size = this.settings.fontSize;
		this.text_box.color = this.settings.color;
		if (this.border == "OUTLINE")
		{
			this.text_box.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST);
		}

		this.text_box.borderColor = FlxColor.fromString(border_color);
		// this.addChild(text_box);
		if (this.autostart)
		{
			this.start();
		}
	}

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "use_literal_text"))
		{
			this.use_literal_text = jsonFile.use_literal_text;
		}
		if (Reflect.hasField(jsonFile, "autostart"))
		{
			this.autostart = jsonFile.autostart;
		}
		if (Reflect.hasField(jsonFile, "settings"))
		{
			var char_per_sec = Reflect.hasField(jsonFile.settings, "char_per_sec") ? jsonFile.settings.char_per_sec : default_char_per_sec;
			var fontsize = Reflect.hasField(jsonFile.settings, "fontsize") ? jsonFile.settings.fontsize : default_fontsize;
			fontsize = cast Math.floor(fontsize * (FlxG.height / DnaConstants.DEFAULT_SCREEN_SIZE.y));
			var width = Reflect.hasField(jsonFile.settings, "width") ? jsonFile.settings.width : default_width;
			var n_lines = Reflect.hasField(jsonFile.settings, "n_lines") ? jsonFile.settings.n_lines : default_n_lines;
			var color = Reflect.hasField(jsonFile.settings, "color") ? jsonFile.settings.color : default_color;
			border = Reflect.hasField(jsonFile.settings, "border") ? jsonFile.settings.border : border;
			border_color = Reflect.hasField(jsonFile.settings, "border_color") ? jsonFile.settings.border_color : border_color;

			this.text_box.width = width;
			this.settings = new Settings(FlxAssets.FONT_DEFAULT, fontsize, width, FlxColor.fromString(color), n_lines, char_per_sec);
		}
		if (Reflect.hasField(jsonFile, "text"))
		{
			// trace("text:", jsonFile.text);
			if (jsonFile.text == CODE_NEXT_TRIAL_DESC)
			{
				// trace("have next trial body");
				jsonFile.text = DnaDataManager.instance.getNextTrials().desc_body;
			}
			if (jsonFile.text == CODE_NEXT_TRIAL_HEAD)
			{
				// trace("have next trial head");
				jsonFile.text = DnaDataManager.instance.getNextTrials().desc_head;
			}
			// trace("text:", jsonFile.text);
			this.setText(jsonFile.text, use_literal_text);
		}

		super.fromFile(jsonFile);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
