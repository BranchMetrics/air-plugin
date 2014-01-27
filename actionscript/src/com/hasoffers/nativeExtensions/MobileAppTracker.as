package com.hasoffers.nativeExtensions
{

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.Dictionary;

	[RemoteClass(alias="com.hasoffers.nativeExtensions.MobileAppTracker")]
	public class MobileAppTracker extends EventDispatcher
	{
		// If the AIR application creates multiple MobileAppTracker objects,
		// all the objects share one instance of the ExtensionContext class.

		private static var extId:String = "com.hasoffers.MobileAppTracker";
		private static var extContext:ExtensionContext = null;

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

			// If the one instance of the ExtensionContext class has not
			// yet been created, create it now.

			if (!extContext)
			{
				if(null == matAdvertiserId || null == matConversionKey || 0 == matAdvertiserId.length || 0 == matConversionKey.length)
				{
					throw new Error("advertiser id and conversion key cannot be null or empty");
				}

				this.matAdvertiserId = matAdvertiserId;
				this.matConversionKey = matConversionKey;

				initExtension(matAdvertiserId, matConversionKey);
			}
		}

		// Initialize the extension by calling our "initNativeCode" ANE function
		private static function initExtension(matAdvertiserId:String, matConversionKey:String):void
		{
			trace("MATAS.initExtension(" + matAdvertiserId + ", " + matConversionKey + "): Create an extension context");

			// The extension context's context type is NULL, because this extension
			// has only one context type.
			extContext = ExtensionContext.createExtensionContext(extId, null);

			if ( extContext )
			{
				extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
				trace("MATAS.initExtension: calling initNativeCode");
				extContext.call(NativeMethods.initNativeCode, matAdvertiserId, matConversionKey);
			}
			else
			{
				trace("MATAS.initExtension: extContext = null");
				throw new Error("Error when instantiating MobileAppTracker native extension." );
			}
		}

		public function trackInstall(refId:String=null):void
		{
			trace("MATAS.trackInstall()");
			extContext.call(NativeMethods.trackInstall, refId);
		}

		public function trackAction(event:String, revenue:Number=0, currency:String="USD", refId:String=null, isEventId:Boolean=false):void
		{
			trace("MATAS.trackAction(" + event + ", " + revenue.toString() + ", " + currency + ", " + refId + ", " + isEventId + ")");
			extContext.call(NativeMethods.trackAction, event, revenue, currency, refId, isEventId);
		}

		public function trackActionWithEventItem(event:String, eventItems:Array, revenue:Number=0, currency:String="USD", refId:String=null, isEventId:Boolean=false, transactionState:int=0, receipt:String=null, receiptSignature:String=null):void
		{
			trace("MATAS.trackActionWithEventItem(" + event + ")");
			
			// an array to hold the event item param values
			var arrItems:Array = new Array();

			for each (var dictItem:Dictionary in eventItems)
			{
				arrItems.push(new String(dictItem.item));
				arrItems.push(dictItem.unit_price);
				arrItems.push(dictItem.quantity);
				arrItems.push(dictItem.revenue);
				arrItems.push(new String(dictItem.attribute1));
				arrItems.push(new String(dictItem.attribute2));
				arrItems.push(new String(dictItem.attribute3));
				arrItems.push(new String(dictItem.attribute4));
				arrItems.push(new String(dictItem.attribute5));
			}
			
			trace("MATAS.trackActionWithEventItem: arrItems = " + arrItems);

			extContext.call(NativeMethods.trackActionWithEventItem, event, arrItems, revenue, currency, refId, isEventId, transactionState, receipt, receiptSignature);
		}

		public function trackUpdate(refId:String=null):void
		{
			trace("MATAS.trackUpdate(refId:String=null)");
			extContext.call(NativeMethods.trackUpdate, refId);
		}

		public function startAppToAppTracking(targetAppId:String, advertiserId:String, offerId:String, publisherId:String, shouldRedirect:Boolean):void
		{
			trace("MATAS.startAppToAppTracking()");
			extContext.call(NativeMethods.startAppToAppTracking, targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
		}

		public function setAllowDuplicates(allowDuplicates:Boolean):void
		{
			trace("MATAS.setAllowDuplicates(" + allowDuplicates + ")");
			extContext.call(NativeMethods.setAllowDuplicates, allowDuplicates);
		}

		public function setAppleAdvertisingIdentifier(appleAdvertisingIdentifier:String):void
		{
			trace("MATAS.setAppleAdvertisingIdentifier(" + appleAdvertisingIdentifier + ")");
			extContext.call(NativeMethods.setAppleAdvertisingIdentifier, appleAdvertisingIdentifier);
		}

		public function setCurrencyCode(currencyCode:String):void
		{
			trace("MATAS.setCurrencyCode(" + currencyCode + ")");
			extContext.call(NativeMethods.setCurrencyCode, currencyCode);
		}

		public function setDebugMode(enable:Boolean):void
		{
			trace("MATAS.setDebugMode(" + enable + ")");
			extContext.call(NativeMethods.setDebugMode, enable);
		}
		
		public function setAppAdTracking(enable:Boolean):void
		{
			trace("MATAS.setAppAdTracking(" + enable + ")");
			extContext.call(NativeMethods.setAppAdTracking, enable);
		}

		public function setJailbroken(isJailbroken:Boolean):void
		{
			trace("MATAS.setJailbroken(" + isJailbroken + ")");
			extContext.call(NativeMethods.setJailbroken, isJailbroken);
		}

		public function setPackageName(packageName:String):void
		{
			trace("MATAS.setPackageName(" + packageName + ")");
			extContext.call(NativeMethods.setPackageName, packageName);
		}

		public function setRedirectUrl(redirectUrl:String):void
		{
			trace("MATAS.setRedirectUrl(" + redirectUrl + ")");
			extContext.call(NativeMethods.setRedirectUrl, redirectUrl);
		}

		public function setUseCookieTracking(useCookieTracking:Boolean):void
		{
			trace("MATAS.setUseCookieTracking(" + useCookieTracking + ")");
			extContext.call(NativeMethods.setUseCookieTracking, useCookieTracking);
		}

		public function setSiteId(siteId:String):void
		{
			trace("MATAS.setSiteId(" + siteId + ")");
			extContext.call(NativeMethods.setSiteId, siteId);
		}

		public function setTRUSTeId(tpid:String):void
		{
			trace("MATAS.setTRUSTeId(" + tpid + ")");
			extContext.call(NativeMethods.setTRUSTeId, tpid);
		}

		public function setAppleVendorIdentifier(appleVendorId:String):void
		{
			trace("MATAS.setAppleVendorIdentifier(" + appleVendorId + ")");
			extContext.call(NativeMethods.setAppleVendorIdentifier, appleVendorId);
		}

		public function setUIID(uiid:String):void
		{
			trace("MATAS.setUIID(" + uiid + ")");
			extContext.call(NativeMethods.setUIID, uiid);
		}

		public function setUserId(userId:String):void
		{
			trace("MATAS.setUserId(" + userId + ")");
			extContext.call(NativeMethods.setUserId, userId);
		}

		public function setFacebookUserId(facebookUserId:String):void
		{
			trace("MATAS.setFacebookUserId(" + facebookUserId + ")");
			extContext.call(NativeMethods.setFacebookUserId, facebookUserId);
		}

		public function setTwitterUserId(twitterUserId:String):void
		{
			trace("MATAS.setTwitterUserId(" + twitterUserId + ")");
			extContext.call(NativeMethods.setTwitterUserId, twitterUserId);
		}

		public function setGoogleUserId(googleUserId:String):void
		{
			trace("MATAS.setGoogleUserId(" + googleUserId + ")");
			extContext.call(NativeMethods.setGoogleUserId, googleUserId);
		}

		public function setODIN1(odin1:String):void
		{
			trace("MATAS.setODIN1(" + odin1 + ")");
			extContext.call(NativeMethods.setODIN1, odin1);
		}
		
		public function setOpenUDID(openUDID:String):void
		{
			trace("MATAS.setOpenUDID(" + openUDID + ")");
			extContext.call(NativeMethods.setOpenUDID, openUDID);
		}
		
		public function setMACAddress(mac:String):void
		{
			trace("MATAS.setMACAddress(" + mac + ")");
			extContext.call(NativeMethods.setMACAddress, mac);
		}

		public function setShouldAutoDetectJailbroken(shouldAutoDetect:Boolean):void
		{
			trace("MATAS.setShouldAutoDetectJailbroken(" + shouldAutoDetect + ")");
			extContext.call(NativeMethods.setShouldAutoDetectJailbroken, shouldAutoDetect);
		}

		public function setShouldAutoGenerateAppleAdvertisingIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateAppleAdvertisingIdentifier(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateAppleAdvertisingIdentifier, shouldAutoGenerate);
		}
		
		public function setShouldAutoGenerateAppleVendorIdentifier(shouldAutoGenerate:Boolean):void
		{
			trace("MATAS.setShouldAutoGenerateAppleVendorIdentifier(" + shouldAutoGenerate + ")");
			extContext.call(NativeMethods.setShouldAutoGenerateAppleVendorIdentifier, shouldAutoGenerate);
		}

		public function setDelegate(enable:Boolean):void
		{
			trace("MATAS.setDelegate(" + enable + ")");
			extContext.call(NativeMethods.setDelegate, enable);
		}

		public function getSDKDataParameters():String
		{
			trace("MATAS.getSDKDataParameters()");
			return extContext.call(NativeMethods.getSDKDataParameters) as String;
		}
		
		public function setAge(age:int):void
		{
			trace("MATAS.setAge(" + age + ")");
			extContext.call(NativeMethods.setAge, age);
		}
		
		public function setGender(gender:int):void
		{
			trace("MATAS.setGender(" + gender + ")");
			extContext.call(NativeMethods.setGender, gender);
		}
		
		public function setLocation(latitude:Number,longitude:Number,altitude:Number):void
		{
			trace("MATAS.setLocation(" + latitude + ", " + longitude + ", " + altitude + ")");
			extContext.call(NativeMethods.setLocation, latitude, longitude, altitude);
		}
		
		public function getReferrer():String
		{
			return extContext.call(NativeMethods.getReferrer) as String;
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