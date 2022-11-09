package com.tune.ane
{
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.utils.Dictionary;

    [RemoteClass(alias="com.tune.ane.Tune")]
    public class Tune extends EventDispatcher
    {
        static public const TUNE_DEEPLINK:String = "TUNE_DEEPLINK";
        static public const TUNE_DEEPLINK_FAILED:String = "TUNE_DEEPLINK_FAILED";
        // If the AIR application creates multiple Tune objects,
        // all the objects share one instance of the ExtensionContext class.

        private static var extId:String = "com.tune.Tune";
        private static var extContext:ExtensionContext = null;

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
            trace("TUNEAS.init(" + tuneAdvertiserId + ", " + tuneConversionKey + ")");

            // If the one instance of the ExtensionContext class has not
            // yet been created, create it now.

            if (!extContext)
            {
                if(null == tuneAdvertiserId || null == tuneConversionKey || 0 == tuneAdvertiserId.length || 0 == tuneConversionKey.length)
                {
                    throw new Error("advertiser id and conversion key cannot be null or empty");
                }

                initExtension(tuneAdvertiserId, tuneConversionKey);
            }
        }

        // Initialize the extension by calling our "initNativeCode" ANE function
        private function initExtension(tuneAdvertiserId:String, tuneConversionKey:String):void
        {
            trace("TUNEAS.initExtension(" + tuneAdvertiserId + ", " + tuneConversionKey + "): Create an extension context");

            // The extension context's context type is NULL, because this extension
            // has only one context type.
            extContext = ExtensionContext.createExtensionContext(extId, null);

            if ( extContext )
            {
                extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
                trace("TUNEAS.initExtension: calling init");
                extContext.call(NativeMethods.init, tuneAdvertiserId, tuneConversionKey);
            }
            else
            {
                trace("TUNEAS.initExtension: extContext = null");
                throw new Error("Error when instantiating TUNE native extension." );
            }
        }

        public function checkForDeferredDeeplink():void
        {
            trace("TUNEAS.checkForDeferredDeeplink()");
            extContext.call(NativeMethods.checkForDeferredDeeplink);
        }

        public function measureSession():void
        {
            trace("TUNEAS.measureSession()");
            extContext.call(NativeMethods.measureSession);
        }

        public function measureEventName(event:String):void
        {
            trace("TUNEAS.measureEventName(" + event + ")");
            extContext.call(NativeMethods.measureEventName, event);
        }

        public function measureEvent(event:Dictionary):void
        {
            trace("TUNEAS.measureEvent(" + event + ")");

            // Create array to hold the event item param values
            var arrItems:Array = new Array();

            for each (var dictItem:Dictionary in event["eventItems"])
            {
                arrItems.push(new String(dictItem.item));
                arrItems.push(dictItem.unit_price != null ? dictItem.unit_price : 0);
                arrItems.push(dictItem.quantity != null ? dictItem.quantity : 0);
                arrItems.push(dictItem.revenue != null ? dictItem.revenue : 0);
                arrItems.push(new String(dictItem.attribute1));
                arrItems.push(new String(dictItem.attribute2));
                arrItems.push(new String(dictItem.attribute3));
                arrItems.push(new String(dictItem.attribute4));
                arrItems.push(new String(dictItem.attribute5));
            }

            trace("TUNEAS.measureEvent: arrItems = " + arrItems);

            extContext.call(NativeMethods.measureEvent,
                        new String(event.name),
                        arrItems,
                        event.revenue != null ? event.revenue : 0,
                        new String(event.currency),
                        new String(event.advertiserRefId),
                        new String(event.receipt),
                        new String(event.receiptSignature),
                        new String(event.attribute1),
                        new String(event.attribute2),
                        new String(event.attribute3),
                        new String(event.attribute4),
                        new String(event.attribute5),
                        new String(event.contentId),
                        new String(event.contentType),
                        new String(event.date1),
                        new String(event.date2),
                        event.level != null ? event.level : 0,
                        event.quantity != null ? event.quantity : 0,
                        event.rating != null ? event.rating : 0,
                        new String(event.searchString)
            );
        }

        public function startAppToAppTracking(targetAppId:String, advertiserId:String, offerId:String, publisherId:String, shouldRedirect:Boolean):void
        {
            trace("TUNEAS.startAppToAppTracking()");
            extContext.call(NativeMethods.startAppToAppTracking, targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
        }

        public function setAge(age:int):void
        {
            trace("TUNEAS.setAge(" + age + ")");
            extContext.call(NativeMethods.setAge, age);
        }

        public function setAndroidId(enable:Boolean):void
        {
            trace("TUNEAS.setAndroidId(" + enable + ")");
            extContext.call(NativeMethods.setAndroidId, enable);
        }

        public function setAppAdTracking(enable:Boolean):void
        {
            trace("TUNEAS.setAppAdTracking(" + enable + ")");
            extContext.call(NativeMethods.setAppAdTracking, enable);
        }

        public function setAppleAdvertisingIdentifier(appleAdvertisingIdentifier:String, advertisingTrackingEnabled:Boolean):void
        {
            trace("TUNEAS.setAppleAdvertisingIdentifier(" + appleAdvertisingIdentifier + ", " + advertisingTrackingEnabled + ")");
            extContext.call(NativeMethods.setAppleAdvertisingIdentifier, appleAdvertisingIdentifier, advertisingTrackingEnabled);
        }

        public function setAppleVendorIdentifier(appleVendorId:String):void
        {
            trace("TUNEAS.setAppleVendorIdentifier(" + appleVendorId + ")");
            extContext.call(NativeMethods.setAppleVendorIdentifier, appleVendorId);
        }

        public function setCurrencyCode(currencyCode:String):void
        {
            trace("TUNEAS.setCurrencyCode(" + currencyCode + ")");
            extContext.call(NativeMethods.setCurrencyCode, currencyCode);
        }

        public function setDeepLink(deepLinkUrl:String):void
        {
            trace("TUNEAS.setDeepLink(" + deepLinkUrl + ")");
            extContext.call(NativeMethods.setDeepLink, deepLinkUrl);
        }

        public function setDebugMode(enable:Boolean):void
        {
            trace("TUNEAS.setDebugMode(" + enable + ")");
            extContext.call(NativeMethods.setDebugMode, enable);
        }

        public function setDelegate(enable:Boolean):void
        {
            trace("TUNEAS.setDelegate(" + enable + ")");
            extContext.call(NativeMethods.setDelegate, enable);
        }

        public function setExistingUser(existingUser:Boolean):void
        {
            trace("TUNEAS.setExistingUser(" + existingUser + ")");
            extContext.call(NativeMethods.setExistingUser, existingUser);
        }

        public function setFacebookEventLogging(enable:Boolean, limitUsage:Boolean):void
        {
            trace("TUNEAS.setFacebookEventLogging(" + enable + ", " + limitUsage + ")");
            extContext.call(NativeMethods.setFacebookEventLogging, enable, limitUsage);
        }

        public function setFacebookUserId(facebookUserId:String):void
        {
            trace("TUNEAS.setFacebookUserId(" + facebookUserId + ")");
            extContext.call(NativeMethods.setFacebookUserId, facebookUserId);
        }

        public function setGender(gender:int):void
        {
            trace("TUNEAS.setGender(" + gender + ")");
            extContext.call(NativeMethods.setGender, gender);
        }

        public function setGoogleAdvertisingId(googleAid:String, limitAdTracking:Boolean):void
        {
            trace("TUNEAS.setGoogleAdvertisingId(" + googleAid + ", " + limitAdTracking + ")");
            extContext.call(NativeMethods.setGoogleAdvertisingId, googleAid, limitAdTracking);
        }

        public function setGoogleUserId(googleUserId:String):void
        {
            trace("TUNEAS.setGoogleUserId(" + googleUserId + ")");
            extContext.call(NativeMethods.setGoogleUserId, googleUserId);
        }

        public function setJailbroken(isJailbroken:Boolean):void
        {
            trace("TUNEAS.setJailbroken(" + isJailbroken + ")");
            extContext.call(NativeMethods.setJailbroken, isJailbroken);
        }

        public function setLocation(latitude:Number,longitude:Number,altitude:Number):void
        {
            trace("TUNEAS.setLocation(" + latitude + ", " + longitude + ", " + altitude + ")");
            extContext.call(NativeMethods.setLocation, latitude, longitude, altitude);
        }

        public function setPackageName(packageName:String):void
        {
            trace("TUNEAS.setPackageName(" + packageName + ")");
            extContext.call(NativeMethods.setPackageName, packageName);
        }

        public function setRedirectUrl(redirectUrl:String):void
        {
            trace("TUNEAS.setRedirectUrl(" + redirectUrl + ")");
            extContext.call(NativeMethods.setRedirectUrl, redirectUrl);
        }

        public function setShouldAutoDetectJailbroken(shouldAutoDetect:Boolean):void
        {
            trace("TUNEAS.setShouldAutoDetectJailbroken(" + shouldAutoDetect + ")");
            extContext.call(NativeMethods.setShouldAutoDetectJailbroken, shouldAutoDetect);
        }

        public function setShouldAutoGenerateAppleVendorIdentifier(shouldAutoGenerate:Boolean):void
        {
            trace("TUNEAS.setShouldAutoGenerateAppleVendorIdentifier(" + shouldAutoGenerate + ")");
            extContext.call(NativeMethods.setShouldAutoGenerateAppleVendorIdentifier, shouldAutoGenerate);
        }

        public function setTRUSTeId(tpid:String):void
        {
            trace("TUNEAS.setTRUSTeId(" + tpid + ")");
            extContext.call(NativeMethods.setTRUSTeId, tpid);
        }

        public function setTwitterUserId(twitterUserId:String):void
        {
            trace("TUNEAS.setTwitterUserId(" + twitterUserId + ")");
            extContext.call(NativeMethods.setTwitterUserId, twitterUserId);
        }

        public function setUseCookieTracking(useCookieTracking:Boolean):void
        {
            trace("TUNEAS.setUseCookieTracking(" + useCookieTracking + ")");
            extContext.call(NativeMethods.setUseCookieTracking, useCookieTracking);
        }

        public function setUserEmail(userEmail:String):void
        {
            trace("TUNEAS.setUserEmail(" + userEmail + ")");
            extContext.call(NativeMethods.setUserEmail, userEmail);
        }

        public function setUserId(userId:String):void
        {
            trace("TUNEAS.setUserId(" + userId + ")");
            extContext.call(NativeMethods.setUserId, userId);
        }

        public function setUserName(userName:String):void
        {
            trace("TUNEAS.setUserName(" + userName + ")");
            extContext.call(NativeMethods.setUserName, userName);
        }

        public function setPhoneNumber(phoneNumber:String):void
        {
            trace("TUNEAS.setPhoneNumber(" + phoneNumber + ")");
            extContext.call(NativeMethods.setPhoneNumber, phoneNumber);
        }

        public function setPayingUser(payingUser:Boolean):void
        {
            trace("TUNEAS.setPayingUser(" + payingUser + ")");
            extContext.call(NativeMethods.setPayingUser, payingUser);
        }

        public function getAdvertisingId():String
        {
            trace("TUNEAS.getAdvertisingId()");
            return extContext.call(NativeMethods.getAdvertisingId) as String;
        }

        public function getMatId():String
        {
            trace("TUNEAS.getMatId()");
            return extContext.call(NativeMethods.getMatId) as String;
        }

        public function getOpenLogId():String
        {
            trace("TUNEAS.getOpenLogId()");
            return extContext.call(NativeMethods.getOpenLogId) as String;
        }

        public function getIsPayingUser():Boolean
        {
            trace("TUNEAS.getIsPayingUser()");
            return extContext.call(NativeMethods.getIsPayingUser) as Boolean;
        }

        public function getReferrer():String
        {
            trace("TUNEAS.getReferrer()");
            return extContext.call(NativeMethods.getReferrer) as String;
        }

        public function onStatusEvent(event:StatusEvent):void
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
            else if("enqueued" == event.code)
            {
                trackerDidEnqueueRequest(event.level);
            }
            dispatchEvent(new StatusEvent(event.code, false, false, event.code, event.level));
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

        public static function trackerDidEnqueueRequest(referenceId:String):void
        {
            trace("TUNEAS.trackerDidEnqueueRequest()");
            trace("TUNEAS.referenceId = " + referenceId);
        }
    }
}
