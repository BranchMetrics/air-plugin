package com.hasoffers.nativeExtensions
{

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;

	[RemoteClass(alias="com.hasoffers.nativeExtensions.MobileAppTracker")]
	public class MobileAppTracker extends EventDispatcher
	{
		// If the AIR application creates multiple MobileAppTracker objects,
		// all the objects share one instance of the ExtensionContext class.

		private static var extId:String = "com.hasoffers.MobileAppTracker";

		public var matAdvertiserId:String;
		public var matConversionKey:String;

		private static var _instance:MobileAppTracker = null;

		public static function get instance():MobileAppTracker
		{
			trace("MATAS.instance");
			if (_instance == null)
			{
				_instance = new MobileAppTracker(new SingletonEnforcer());
			}
			return _instance;
		}

		public function MobileAppTracker(enforcer:SingletonEnforcer)
		{
			trace("MATAS.Constructor");
			if (enforcer == null) throw new Error("Invalid singleton access. Please use MobileAppTracker.instance() instead.");
		}

		public function init(matAdvertiserId:String, matConversionKey:String):void
		{
			trace("MATAS init() start");
			trace("MATAS.init(" + matAdvertiserId + ", " + matConversionKey + ")");
		}

		// Initialize the extension by calling our "initNativeCode" ANE function
		private static function initExtension(matAdvertiserId:String, matConversionKey:String):void
		{
			trace("MATAS.initExtension(" + matAdvertiserId + ", " + matConversionKey + "): Create an extension context");
		}

		public function trackInstall(refId:String=null):void
		{
			trace("MATAS.trackInstall()");
		}

		public function trackAction(event:String, revenue:Number=0, currency:String="USD", refId:String=null, isEventId:Boolean=false):void
		{
			trace("MATAS.trackAction(" + event + ", " + revenue.toString() + ", " + currency + ", " + refId + ", " + isEventId + ")");
		}

		public function trackActionWithEventItem(event:String, eventItems:Array, revenue:Number=0, currency:String="USD", refId:String=null, isEventId:Boolean=false, transactionState:int=0, receipt:String=null, receiptSignature:String=null):void
		{
			trace("MATAS.trackActionWithEventItem(" + event + ")");
		}

		public function trackUpdate(refId:String=null):void
		{
			trace("MATAS.trackUpdate(refId:String=null)");
		}

		public function startAppToAppTracking(targetAppId:String, advertiserId:String, offerId:String, publisherId:String, shouldRedirect:Boolean):void
		{
			trace("MATAS.startAppToAppTracking()");
		}

		public function setAllowDuplicates(allowDuplicates:Boolean):void
		{
			trace("MATAS.setAllowDuplicates(" + allowDuplicates + ")");
		}

		public function setAppleAdvertisingIdentifier(appleAdvertisingIdentifier:String):void
		{
			trace("MATAS.setAppleAdvertisingIdentifier(" + appleAdvertisingIdentifier + ")");
		}

		public function setCurrencyCode(currencyCode:String):void
		{
			trace("MATAS.setCurrencyCode(" + currencyCode + ")");
		}

		public function setDebugMode(enable:Boolean):void
		{
			trace("MATAS.setDebugMode(" + enable + ")");
		}
		
		public function setAppAdTracking(enable:Boolean):void
		{
			trace("MATAS.setAppAdTracking(" + enable + ")");
		}

		public function setJailbroken(isJailbroken:Boolean):void
		{
			trace("MATAS.setJailbroken(" + isJailbroken + ")");
		}

		public function setPackageName(packageName:String):void
		{
			trace("MATAS.setPackageName(" + packageName + ")");
		}

		public function setRedirectUrl(redirectUrl:String):void
		{
			trace("MATAS.setRedirectUrl(" + redirectUrl + ")");
		}

		public function setUseCookieTracking(useCookieTracking:Boolean):void
		{
			trace("MATAS.setUseCookieTracking(" + useCookieTracking + ")");
		}

		public function setUseHTTPS(useHTTPS:Boolean):void
		{
			trace("MATAS.setUseHTTPS(" + useHTTPS + ")");
		}

		public function setSiteId(siteId:String):void
		{
			trace("MATAS.setSiteId(" + siteId + ")");
		}

		public function setTRUSTeId(tpid:String):void
		{
			trace("MATAS.setTRUSTeId(" + tpid + ")");
		}

		public function setAppleVendorIdentifier(appleVendorId:String):void
		{
			trace("MATAS.setAppleVendorIdentifier(" + appleVendorId + ")");
		}

		public function setUIID(uiid:String):void
		{
			trace("MATAS.setUIID(" + uiid + ")");
		}

		public function setUserId(userId:String):void
		{
			trace("MATAS.setUserId(" + userId + ")");
		}

		public function setFacebookUserId(facebookUserId:String):void
		{
			trace("MATAS.setFacebookUserId(" + facebookUserId + ")");
		}

		public function setTwitterUserId(twitterUserId:String):void
		{
			trace("MATAS.setTwitterUserId(" + twitterUserId + ")");
		}

		public function setGoogleUserId(googleUserId:String):void
		{
			trace("MATAS.setGoogleUserId(" + googleUserId + ")");
		}

		public function setODIN1(odin1:String):void
		{
			trace("MATAS.setODIN1(" + odin1 + ")");
		}
		
		public function setOpenUDID(openUDID:String):void
		{
			trace("MATAS.setOpenUDID(" + openUDID + ")");
		}
		
		public function setMACAddress(mac:String):void
		{
			trace("MATAS.setMACAddress(" + mac + ")");
		}

		public function setShouldAutoDetectJailbroken(shouldAutoDetect:Boolean):void
		{
			trace("MATAS.setShouldAutoDetectJailbroken(" + shouldAutoDetect + ")");
		}

		public function setShouldAutoGenerateAppleAdvertisingIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateAppleAdvertisingIdentifier(" + shouldAutoGenerate + ")");
		}
		
		public function setShouldAutoGenerateAppleVendorIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateAppleVendorIdentifier(" + shouldAutoGenerate + ")");
		}

		public function setDelegate(enable:Boolean):void
		{
			trace("MATAS.setDelegate(" + enable + ")");
		}

		public function getSDKDataParameters():String
		{
			trace("MATAS.getSDKDataParameters()");
			return "Only supported on iOS";
		}
		
		public function setAge(age:int):void
		{
			trace("MATAS.setAge(" + age + ")");
		}
		
		public function setGender(gender:int):void
		{
			trace("MATAS.setGender(" + gender + ")");
		}
		
		public function setLocation(latitude:Number,longitude:Number,altitude:Number):void
		{
			trace("MATAS.setLocation(" + latitude + ", " + longitude + ", " + altitude + ")");
		}
		
		public function getReferrer():String
		{
			return "Only supported on Android";
		}

		public static function onStatusEvent(event:StatusEvent):void
		{
			trace("MATAS.statusHandler(): " + event);
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
			trace("MATAS.trackerDidSucceed()");
			trace("MATAS.data = " + data);
		}

		public static function trackerDidFail(error:String):void
		{
			trace("MATAS.trackerDidFail()");
			trace("MATAS.error = " + error);
		}
	}
}