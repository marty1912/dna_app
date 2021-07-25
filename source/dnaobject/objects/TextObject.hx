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
 * class TextObject -
 * this class will be used to show text to the user that runs from left to right
 *
 */
class TextObject implements DnaObject implements ITextBox extends DnaObjectBase
{
	public static final CODE_NEXT_TRIAL_DESC = "NEXT_TRIAL_DESC";
	public static final CODE_NEXT_TRIAL_HEAD = "NEXT_TRIAL_HEAD";

	public var text_box:Textbox;
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

	/**
	 * start() - starts displaying the text.
	 */
	public function start():Void
	{
		this.text_box.bring();
	}

	public static final default_fontsize:Int = 32;
	public static final default_width:Int = 320;
	public static final default_char_per_sec:Int = 124;
	public static final default_n_lines:Int = 3;
	public static final default_color:String = "0xFFFFFF";

	public static final default_border_color:String = "0x000000";
	public static final default_border_style:String = "NONE";

	public var border_style:String = "NONE";
	public var border_color:String = "0x000000";

	public var append_before:String = "";
	public var append_after:String = "";

	/**
	 * ctor.
	 */
	public function new()
	{
		super("TextObject");
		this.settings = new Settings(FlxAssets.FONT_DEFAULT, default_fontsize, default_width, FlxColor.WHITE);
		text_box = new Textbox(0, 0, settings);
		this.addChild(text_box);
	}

	public var text:String = "";

	public function getText():String
	{
		return this.text;
	}

	/**
	 * setter for text
	 * @param value
	 */
	public function setText(value:String, ?use_literal_text:Bool = false)
	{
		this.getChildren().remove(text_box);

		this.text_box.dismiss();

		this.text_box = new Textbox(0, 0, this.settings);
		var real_string:String;
		if (use_literal_text)
		{
			real_string = value;
		}
		else
		{
			real_string = LocaleManager.getInstance().getString(value);
		}

		// another exception from the rule...
		if (real_string == DnaConstants.CODE_ID)
		{
			real_string = DnaDataManager.instance.retrieveData(DnaDataManager.instance.PART_UUID);
		}

		this.text = append_before + real_string + append_after;
		this.text_box.setText(this.text);
		this.addChild(text_box);
		if (this.autostart)
		{
			text_box.bring();
		}
		text_box.statusChangeCallbacks.push(function(newStatus:textbox.Status):Void
		{
			if (newStatus == textbox.Status.FULL)
			{
				text_box.continueWriting();
			}
			if (newStatus == textbox.Status.DONE)
			{
				this.getParent().eventManager.broadcastEvent(this.getEventFinName());
			}
		});
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
			char_per_sec = 124;
			var fontsize = Reflect.hasField(jsonFile.settings, "fontsize") ? jsonFile.settings.fontsize : default_fontsize;
			// autoscale fontsize.
			fontsize = cast Math.floor(fontsize * (FlxG.height / DnaConstants.DEFAULT_SCREEN_SIZE.y));
			var width = Reflect.hasField(jsonFile.settings, "width") ? jsonFile.settings.width : default_width;
			width = cast Math.floor(width * (FlxG.width / DnaConstants.DEFAULT_SCREEN_SIZE.x));
			width = Math.floor(FlxG.width * 0.8);

			var n_lines = Reflect.hasField(jsonFile.settings, "n_lines") ? jsonFile.settings.n_lines : default_n_lines;
			var color = Reflect.hasField(jsonFile.settings, "color") ? jsonFile.settings.color : default_color;
			border_color = Reflect.hasField(jsonFile.settings, "border_color") ? jsonFile.settings.border_color : default_border_color;
			append_before = Reflect.hasField(jsonFile.settings, "append_before") ? jsonFile.settings.append_before : append_before;
			append_after = Reflect.hasField(jsonFile.settings, "append_after") ? jsonFile.settings.append_after : append_after;

			this.settings = new Settings(FlxAssets.FONT_DEFAULT, fontsize, width, FlxColor.fromString(color), n_lines, char_per_sec);
		}
		if (Reflect.hasField(jsonFile, "text"))
		{
			if (jsonFile.text == CODE_NEXT_TRIAL_DESC)
			{
				jsonFile.text = DnaDataManager.instance.getNextTrials().desc_body;
			}
			if (jsonFile.text == CODE_NEXT_TRIAL_HEAD)
			{
				jsonFile.text = DnaDataManager.instance.getNextTrials().desc_head;
			}
			this.setText(jsonFile.text, this.use_literal_text);
		}

		super.fromFile(jsonFile);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
