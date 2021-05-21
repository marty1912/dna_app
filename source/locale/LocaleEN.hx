package locale;

import textparsemacro.ConfigFile;

/**
 * this is the interface that each locale must implement.
 */
class LocaleEN implements Locale
{
	public final ERROR_NOT_FOUND:String = "STRING NOT FOUND IN LOCALE!!";
	public final ERROR_INV_INPUT:String = "STRING KEY INVALID IN LOCALE!!";
	public final translation_map:Map<String, String> = [
		"SettingsState_HEAD" => "@041911315Settings@040",
		"SettingsState_LANG" => "@041911315Language@040",
		"LOCALE_NAME" => "@041911315English@040",
		"TEXTBOX_TEST" => "Hello World!@011001500 How goes? @010@001FF0000Color test!@000 @02101FFFFThis@020 is a @03101FF0Fgood@030 old textbox test.",
		"SRTTEXTBOX_TEST" =>
		'[{"text":"Hello World! @011001500 How goes? @010","t_start":0,"t_end":7}, {"text":"Color test!","t_start":8,"t_end":10},{"text":"This is a good old textbox test.","t_start":12,"t_end":16}]'
	];

	/**
	 * empty ctor.
	 */
	public function new() {}

	/**
	 * this function is used to get an text string in our specific language.
	 * @param string_id  - the unique id of the string.
	 * @return String  - the string that we want to display in the game.
	 */
	public function getString(string_id:String):String
	{
		if (string_id == null)
		{
			return ERROR_NOT_FOUND + string_id;
		}
		var string = translation_map.get(string_id);

		if (string == null)
		{
			return ERROR_NOT_FOUND + string_id;
		}

		return string;
	}

	public function getAudioPath(string_id:String):String
	{
		return "assets/sounds/kenney_interfacesounds/Audio/click_003.mp3";
	};
}
