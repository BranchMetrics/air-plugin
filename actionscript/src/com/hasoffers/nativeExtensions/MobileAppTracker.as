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
        
        public function checkForDeferredDeeplink(timeout:Number):void
        {
            trace("MATAS.checkForDeferredDeeplink(" + timeout + ")");
            extContext.call(NativeMethods.checkForDeferredDeeplink, timeout);
        }
        
        public function measureSession():void
        {
            trace("MATAS.measureSession()");
            extContext.call(NativeMethods.measureSession);
        }

        public function measureAction(event:String, revenue:Number=0, currency:String="USD", refId:String=null):void
        {
            trace("MATAS.measureAction(" + event + ", " + revenue.toString() + ", " + currency + ", " + refId + ")");
            extContext.call(NativeMethods.measureAction, event, revenue, currency, refId);
        }

        public function measureActionWithEventItems(event:String, eventItems:Array, revenue:Number=0, currency:String="USD", refId:String=null, transactionState:int=-1, receipt:String=null, receiptSignature:String=null):void
        {
            trace("MATAS.measureActionWithEventItems(" + event + ")");
            
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
            
            trace("MATAS.measureActionWithEventItems: arrItems = " + arrItems);

            extContext.call(NativeMethods.measureActionWithEventItems, event, arrItems, revenue, currency, refId, transactionState, receipt, receiptSignature);
        }

        public function startAppToAppTracking(targetAppId:String, advertiserId:String, offerId:String, publisherId:String, shouldRedirect:Boolean):void
        {
            trace("MATAS.startAppToAppTracking()");
            extContext.call(NativeMethods.startAppToAppTracking, targetAppId, advertiserId, offerId, publisherId, shouldRedirect);
        }
        
        public function setAge(age:int):void
        {
            trace("MATAS.setAge(" + age + ")");
            extContext.call(NativeMethods.setAge, age);
        }

        public function setAllowDuplicates(allowDuplicates:Boolean):void
        {
            trace("MATAS.setAllowDuplicates(" + allowDuplicates + ")");
            extContext.call(NativeMethods.setAllowDuplicates, allowDuplicates);
        }

        public function setAndroidId(enable:Boolean):void
        {
            trace("MATAS.setAndroidId(" + enable + ")");
            extContext.call(NativeMethods.setAndroidId, enable);
        }

        public function setAppAdTracking(enable:Boolean):void
        {
            trace("MATAS.setAppAdTracking(" + enable + ")");
            extContext.call(NativeMethods.setAppAdTracking, enable);
        }
        
        public function setAppleAdvertisingIdentifier(appleAdvertisingIdentifier:String, advertisingTrackingEnabled:Boolean):void
        {
            trace("MATAS.setAppleAdvertisingIdentifier(" + appleAdvertisingIdentifier + ", " + advertisingTrackingEnabled + ")");
            extContext.call(NativeMethods.setAppleAdvertisingIdentifier, appleAdvertisingIdentifier, advertisingTrackingEnabled);
        }
        
        public function setAppleVendorIdentifier(appleVendorId:String):void
        {
            trace("MATAS.setAppleVendorIdentifier(" + appleVendorId + ")");
            extContext.call(NativeMethods.setAppleVendorIdentifier, appleVendorId);
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
        
        public function setDelegate(enable:Boolean):void
        {
            trace("MATAS.setDelegate(" + enable + ")");
            extContext.call(NativeMethods.setDelegate, enable);
        }
        
        public function setEventAttribute1(attribute1:String):void
        {
            trace("MATAS.setEventAttribute1(" + attribute1 + ")");
            extContext.call(NativeMethods.setEventAttribute, 1, attribute1);
        }
        
        public function setEventAttribute2(attribute2:String):void
        {
            trace("MATAS.setEventAttribute2(" + attribute2 + ")");
            extContext.call(NativeMethods.setEventAttribute, 2, attribute2);
        }
        
        public function setEventAttribute3(attribute3:String):void
        {
            trace("MATAS.setEventAttribute3(" + attribute3 + ")");
            extContext.call(NativeMethods.setEventAttribute, 3, attribute3);
        }
        
        public function setEventAttribute4(attribute4:String):void
        {
            trace("MATAS.setEventAttribute4(" + attribute4 + ")");
            extContext.call(NativeMethods.setEventAttribute, 4, attribute4);
        }
        
        public function setEventAttribute5(attribute5:String):void
        {
            trace("MATAS.setEventAttribute5(" + attribute5 + ")");
            extContext.call(NativeMethods.setEventAttribute, 5, attribute5);
        }
        
        public function setEventContentId(contentId:String):void
        {
            trace("MATAS.setEventContentId(" + contentId + ")");
            extContext.call(NativeMethods.setEventContentId, contentId);
        }
        
        public function setEventContentType(contentType:String):void
        {
            trace("MATAS.setEventContentType(" + contentType + ")");
            extContext.call(NativeMethods.setEventContentType, contentType);
        }
        
        public function setEventDate1(dateString:String):void
        {
            trace("MATAS.setEventDate1(" + dateString + ")");
            extContext.call(NativeMethods.setEventDate1, dateString);
        }
        
        public function setEventDate2(dateString:String):void
        {
            trace("MATAS.setEventDate2(" + dateString + ")");
            extContext.call(NativeMethods.setEventDate2, dateString);
        }
        
        public function setEventLevel(level:int):void
        {
            trace("MATAS.setEventLevel(" + level + ")");
            extContext.call(NativeMethods.setEventLevel, level);
        }
        
        public function setEventQuantity(quantity:int):void
        {
            trace("MATAS.setEventQuantity(" + quantity + ")");
            extContext.call(NativeMethods.setEventQuantity, quantity);
        }
        
        public function setEventRating(rating:Number):void
        {
            trace("MATAS.setEventRating(" + rating + ")");
            extContext.call(NativeMethods.setEventRating, rating);
        }
        
        public function setEventSearchString(searchString:String):void
        {
            trace("MATAS.setEventSearchString(" + searchString + ")");
            extContext.call(NativeMethods.setEventSearchString, searchString);
        }
        
        public function setExistingUser(existingUser:Boolean):void
        {
            trace("MATAS.setExistingUser(" + existingUser + ")");
            extContext.call(NativeMethods.setExistingUser, existingUser);
        }
        
        public function setFacebookEventLogging(enable:Boolean, limitUsage:Boolean):void
        {
            trace("MATAS.setFacebookEventLogging(" + enable + ", " + limitUsage + ")");
            extContext.call(NativeMethods.setFacebookEventLogging, enable, limitUsage);
        }
        
        public function setFacebookUserId(facebookUserId:String):void
        {
            trace("MATAS.setFacebookUserId(" + facebookUserId + ")");
            extContext.call(NativeMethods.setFacebookUserId, facebookUserId);
        }
        
        public function setGender(gender:int):void
        {
            trace("MATAS.setGender(" + gender + ")");
            extContext.call(NativeMethods.setGender, gender);
        }
        
        public function setGoogleAdvertisingId(googleAid:String, limitAdTracking:Boolean):void
        {
            trace("MATAS.setGoogleAdvertisingId(" + googleAid + ", " + limitAdTracking + ")");
            extContext.call(NativeMethods.setGoogleAdvertisingId, googleAid, limitAdTracking);
        }

        public function setGoogleUserId(googleUserId:String):void
        {
            trace("MATAS.setGoogleUserId(" + googleUserId + ")");
            extContext.call(NativeMethods.setGoogleUserId, googleUserId);
        }
        
        public function setJailbroken(isJailbroken:Boolean):void
        {
            trace("MATAS.setJailbroken(" + isJailbroken + ")");
            extContext.call(NativeMethods.setJailbroken, isJailbroken);
        }
        
        public function setLocation(latitude:Number,longitude:Number,altitude:Number):void
        {
            trace("MATAS.setLocation(" + latitude + ", " + longitude + ", " + altitude + ")");
            extContext.call(NativeMethods.setLocation, latitude, longitude, altitude);
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
        
        public function setShouldAutoDetectJailbroken(shouldAutoDetect:Boolean):void
        {
            trace("MATAS.setShouldAutoDetectJailbroken(" + shouldAutoDetect + ")");
            extContext.call(NativeMethods.setShouldAutoDetectJailbroken, shouldAutoDetect);
        }
        
        public function setShouldAutoGenerateAppleVendorIdentifier(shouldAutoGenerate:Boolean):void
        {
            trace("MATAS.setShouldAutoGenerateAppleVendorIdentifier(" + shouldAutoGenerate + ")");
            extContext.call(NativeMethods.setShouldAutoGenerateAppleVendorIdentifier, shouldAutoGenerate);
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
        
        public function setTwitterUserId(twitterUserId:String):void
        {
            trace("MATAS.setTwitterUserId(" + twitterUserId + ")");
            extContext.call(NativeMethods.setTwitterUserId, twitterUserId);
        }
        
        public function setUseCookieTracking(useCookieTracking:Boolean):void
        {
            trace("MATAS.setUseCookieTracking(" + useCookieTracking + ")");
            extContext.call(NativeMethods.setUseCookieTracking, useCookieTracking);
        }
        
        public function setUserEmail(userEmail:String):void
        {
            trace("MATAS.setUserEmail(" + userEmail + ")");
            extContext.call(NativeMethods.setUserEmail, userEmail);
        }

        public function setUserId(userId:String):void
        {
            trace("MATAS.setUserId(" + userId + ")");
            extContext.call(NativeMethods.setUserId, userId);
        }
        
        public function setUserName(userName:String):void
        {
            trace("MATAS.setUserName(" + userName + ")");
            extContext.call(NativeMethods.setUserName, userName);
        }
        
        public function setPayingUser(payingUser:Boolean):void
        {
            trace("MATAS.setPayingUser(" + payingUser + ")");
            extContext.call(NativeMethods.setPayingUser, payingUser);
        }
        
        public function getMatId():String
        {
            trace("MATAS.getMatId()");
            return extContext.call(NativeMethods.getMatId) as String;
        }
        
        public function getOpenLogId():String
        {
            trace("MATAS.getOpenLogId()");
            return extContext.call(NativeMethods.getOpenLogId) as String;
        }
        
        public function getIsPayingUser():Boolean
        {
            trace("MATAS.getIsPayingUser()");
            return extContext.call(NativeMethods.getIsPayingUser) as Boolean;
        }
        
        public function getReferrer():String
        {
            trace("MATAS.getReferrer()");
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
            else if("enqueued" == event.code)
            {
                trackerDidEnqueueRequest(event.level);
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
        
        public static function trackerDidEnqueueRequest(referenceId:String):void
        {
            trace("MATAS.trackerDidEnqueueRequest()");
            trace("MATAS.referenceId = " + referenceId);
        }
    }
}