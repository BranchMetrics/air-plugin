package com.tune.ane
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.utils.Dictionary;

	[RemoteClass(alias="com.tune.ane.Tune")]
	public class Tune extends EventDispatcher
	{
		// If the AIR application creates multiple Tune objects,
		// all the objects share one instance of the ExtensionContext class.

		private static var extId:String = "com.tune.Tune";

		public var tuneAdvertiserId:String;
		public var tuneConversionKey:String;

		private static var _instance:Tune = null;

		public static function get instance():Tune
		{
			trace("TUNEAS.instance");
			if (_instance == null)
			{
				_instance = new Tune(new SingletonEnforcer());
			}
			return _instance;
		}

		public function Tune(enforcer:SingletonEnforcer)
		{
			trace("TUNEAS.Constructor");
			if (enforcer == null) throw new Error("Invalid singleton access. Please use Tune.instance() instead.");
		}

		public function init(tuneAdvertiserId:String, tuneConversionKey:String):void
		{
			trace("TUNEAS init() start");
			trace("TUNEAS.init(" + tuneAdvertiserId + ", " + tuneConversionKey + ")");
		}

		// Initialize the extension by calling our "initNativeCode" ANE function
		private static function initExtension(tuneAdvertiserId:String, tuneConversionKey:String):void
		{
			trace("TUNEAS.initExtension(" + tuneAdvertiserId + ", " + tuneConversionKey + "): Create an extension context");
		}

		public function measureSession():void
		{
			trace("TUNEAS.measureSession()");
		}

		public function measureEventName(event:String):void
		{
            trace("TUNEAS.measureEventName(" + event + ")");
		}

		public function measureEvent(event:Dictionary):void
		{
            trace("TUNEAS.measureEvent(" + event + ")");
		}

		public function startAppToAppTracking(targetAppId:String, advertiserId:String, offerId:String, publisherId:String, shouldRedirect:Boolean):void
		{
			trace("TUNEAS.startAppToAppTracking()");
		}

		public function setAllowDuplicates(allowDuplicates:Boolean):void
		{
			trace("TUNEAS.setAllowDuplicates(" + allowDuplicates + ")");
		}

		public function setAppleAdvertisingIdentifier(appleAdvertisingIdentifier:String):void
		{
			trace("TUNEAS.setAppleAdvertisingIdentifier(" + appleAdvertisingIdentifier + ")");
		}

		public function setCurrencyCode(currencyCode:String):void
		{
			trace("TUNEAS.setCurrencyCode(" + currencyCode + ")");
		}

		public function setDebugMode(enable:Boolean):void
		{
			trace("TUNEAS.setDebugMode(" + enable + ")");
		}
		
		public function setAppAdTracking(enable:Boolean):void
		{
			trace("TUNEAS.setAppAdTracking(" + enable + ")");
		}

		public function setJailbroken(isJailbroken:Boolean):void
		{
			trace("TUNEAS.setJailbroken(" + isJailbroken + ")");
		}

		public function setPackageName(packageName:String):void
		{
			trace("TUNEAS.setPackageName(" + packageName + ")");
		}

		public function setRedirectUrl(redirectUrl:String):void
		{
			trace("TUNEAS.setRedirectUrl(" + redirectUrl + ")");
		}

		public function setUseCookieTracking(useCookieTracking:Boolean):void
		{
			trace("TUNEAS.setUseCookieTracking(" + useCookieTracking + ")");
		}

		public function setUseHTTPS(useHTTPS:Boolean):void
		{
			trace("TUNEAS.setUseHTTPS(" + useHTTPS + ")");
		}

		public function setSiteId(siteId:String):void
		{
			trace("TUNEAS.setSiteId(" + siteId + ")");
		}

		public function setTRUSTeId(tpid:String):void
		{
			trace("TUNEAS.setTRUSTeId(" + tpid + ")");
		}

		public function setAppleVendorIdentifier(appleVendorId:String):void
		{
			trace("TUNEAS.setAppleVendorIdentifier(" + appleVendorId + ")");
		}

		public function setUIID(uiid:String):void
		{
			trace("TUNEAS.setUIID(" + uiid + ")");
		}

		public function setUserId(userId:String):void
		{
			trace("TUNEAS.setUserId(" + userId + ")");
		}

		public function setFacebookUserId(facebookUserId:String):void
		{
			trace("TUNEAS.setFacebookUserId(" + facebookUserId + ")");
		}

		public function setTwitterUserId(twitterUserId:String):void
		{
			trace("TUNEAS.setTwitterUserId(" + twitterUserId + ")");
		}

		public function setGoogleUserId(googleUserId:String):void
		{
			trace("TUNEAS.setGoogleUserId(" + googleUserId + ")");
		}

		public function setODIN1(odin1:String):void
		{
			trace("TUNEAS.setODIN1(" + odin1 + ")");
		}
		
		public function setOpenUDID(openUDID:String):void
		{
			trace("TUNEAS.setOpenUDID(" + openUDID + ")");
		}
		
		public function setMACAddress(mac:String):void
		{
			trace("TUNEAS.setMACAddress(" + mac + ")");
		}

		public function setShouldAutoDetectJailbroken(shouldAutoDetect:Boolean):void
		{
			trace("TUNEAS.setShouldAutoDetectJailbroken(" + shouldAutoDetect + ")");
		}

		public function setShouldAutoGenerateAppleAdvertisingIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("TUNEAS.setShouldAutoGenerateAppleAdvertisingIdentifier(" + shouldAutoGenerate + ")");
		}
		
		public function setShouldAutoGenerateAppleVendorIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("TUNEAS.setShouldAutoGenerateAppleVendorIdentifier(" + shouldAutoGenerate + ")");
		}

		public function setDelegate(enable:Boolean):void
		{
			trace("TUNEAS.setDelegate(" + enable + ")");
		}

		public function getSDKDataParameters():String
		{
			trace("TUNEAS.getSDKDataParameters()");
			return "Only supported on iOS";
		}
		
		public function setAge(age:int):void
		{
			trace("TUNEAS.setAge(" + age + ")");
		}
		
		public function setGender(gender:int):void
		{
			trace("TUNEAS.setGender(" + gender + ")");
		}
		
		public function setLocation(latitude:Number,longitude:Number,altitude:Number):void
		{
			trace("TUNEAS.setLocation(" + latitude + ", " + longitude + ", " + altitude + ")");
		}
		
		public function getReferrer():String
		{
			return "Only supported on Android";
		}

		public static function onStatusEvent(event:StatusEvent):void
		{
			trace("TUNEAS.statusHandler(): " + event);
			if("success" == event.code)
			{
				trackerDidSucceed(event.level);
			}
			else if("failure" == event.code)
			{
				trackerDidFail(event.level);
			}
		}

		public static function trackerDidSucceed(data:String):void
		{
			trace("TUNEAS.trackerDidSucceed()");
			trace("TUNEAS.data = " + data);
		}

		public static function trackerDidFail(error:String):void
		{
			trace("TUNEAS.trackerDidFail()");
			trace("TUNEAS.error = " + error);
		}
	}
}