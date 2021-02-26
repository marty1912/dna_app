package dnanetwork;

import haxe.crypto.Hmac;
import haxe.io.Bytes;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestHeader;
import openfl.utils.Assets;
import osspec.OsManager;

class DnaNetworkManager
{
	public static final server_url:String = OsManager.get_instance().getServerUrl(); // "https://localhost:1212";

	/**
	 * this sends the data in the parameter to the server.
	 * @param data
	 */
	public static function postToServer(data:String)
	{
		var request:URLRequest = new URLRequest(server_url);
		request.method = "POST";
		request.data = data;
		var loader:URLLoader = new URLLoader();
		// loader.addEventListener(Event.COMPLETE);
		loader.load(request);
	}

	/**
	 * getSignedRequest -- signs the request with hmac + nonce and returns it.
	 * @param body - the message body to sign.
	 * @return URLRequest - the signed request
	 */
	public static function getSignedRequest(body:String):URLRequest
	{
		// for security we do some hmac with our data..
		// with hmac we can be sure on the server side that
		// the data was not tampered with (in order to obtain some information about our users etc.).
		// for an explaination look up hmac.
		// We will be modelling stuff after this
		// stackoverflow post: https://security.stackexchange.com/questions/170944/securing-an-api-with-django-rest-framewor
		var nonce:String = Std.string(Date.now().getTime() * 1000);
		var to_sig:String = nonce + body;

		// the keys will later be encrypted using the RSA algorithm where only the server will have the
		// secret key..
		var API_KEY:String = Assets.getText("assets/data/api_key.txt");
		var API_SECRET:Bytes = Bytes.ofString(Assets.getText("assets/data/secret_key.txt"));
		var hmac:Hmac = new Hmac(SHA256);
		var sig:Bytes = hmac.make(API_SECRET, Bytes.ofString(to_sig));

		var request:URLRequest = new URLRequest(DnaNetworkManager.server_url);

		request.requestHeaders.push(new URLRequestHeader("key", API_KEY));
		request.requestHeaders.push(new URLRequestHeader("sig", sig.toHex()));
		request.requestHeaders.push(new URLRequestHeader("nonce", nonce));
		return request;
	}

	/**
	 * this sends the data in the parameter to the server.
	 * @param data
	 */
	public static function getFromServer(data:String)
	{
		var request:URLRequest = new URLRequest(server_url);
		request.method = "GET";
		request.data = data;
		var loader:URLLoader = new URLLoader();
		loader.load(request);
	}

	private function new() {}
}
