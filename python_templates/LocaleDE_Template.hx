package locale;

import textparsemacro.ConfigFile;

/**
 * this is the interface that each locale must implement.
 */
class LocaleDE implements Locale
{
	public final ERROR_NOT_FOUND:String = "STRING NOT FOUND IN LOCALE!!";
	public final ERROR_INV_INPUT:String = "STRING KEY INVALID IN LOCALE!!";
	public final translation_map:Map<String, String> = INSERT_TEXT_MAP_HERE
	public final audio_path_map:Map<String, String> = INSERT_AUDIO_MAP_HERE

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

	/**
	 * this function is used to get the asset path for the audiofiles for the respective language
	 * @param string_id  - the unique id of the audio asset.
	 * @return String  - the path of the asset for the current locale.
	 */
	 public function getAudioPath(string_id:String):String
		{
			if (string_id == null)
			{
	
				trace("[WARNING]: Audiopath null!:",string_id);
				return null;
			}
			var string = audio_path_map.get(string_id);
	
			if (string == null)
			{
				trace("[WARNING]: Audio not found:",string_id);
				return null;
			}
	
			return string;
		}

}
