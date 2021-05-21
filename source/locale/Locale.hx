package locale;

/**
 * this is the interface that each locale must implement.
 */
interface Locale
{
	public final translation_map:Map<String, String>;

	/**
	 * this function is used to get an text string in our specific language.
	 * @param string_id  - the unique id of the string.
	 * @return String  - the string that we want to display in the game.
	 */
	public function getString(string_id:String):String;

	/**
	 * getAudioPath - this function returns the path of the wanted audio asset in the specific locale.
	 * so it might be that "test" is once "assets/sounds/de/test.mp3" and another time "assets/sounds/en/test.mp3" or something like that.
	 * @param string_id 
	 * @return String
	 */
	public function getAudioPath(string_id:String):String;
}
