package com.tune.ane
{
    internal class NativeMethods
    {
        // Main MAT initialization methods
        internal static const init                          : String = "init";
        internal static const startAppToAppTracking         : String = "startAppToAppTracking";
        internal static const checkForDeferredDeeplink      : String = "checkForDeferredDeeplink";
        
        // Measuring methods: install/update 
        internal static const measureSession                : String = "measureSession";
        
        // Measuring methods: events and eventItems
        internal static const measureEvent                  : String = "measureEvent";
        internal static const measureEventName              : String = "measureEventName";
        
        // Methods to help debugging and testing
        internal static const setDebugMode                  : String = "setDebugMode";
        
        // Set MAT delegate to receive success/failure callbacks
        internal static const setDelegate                   : String = "setDelegate";
        
        // Setter methods to override default values
        internal static const setAge                        : String = "setAge";
        internal static const setAndroidId                  : String = "setAndroidId";
        internal static const setAppAdTracking              : String = "setAppAdTracking";
        internal static const setCurrencyCode               : String = "setCurrencyCode";
        internal static const setDeepLink                   : String = "setDeepLink";
        internal static const setExistingUser               : String = "setExistingUser";
        internal static const setFacebookEventLogging       : String = "setFacebookEventLogging";
        internal static const setFacebookUserId             : String = "setFacebookUserId";
        internal static const setGender                     : String = "setGender";
        internal static const setGoogleAdvertisingId        : String = "setGoogleAdvertisingId";
        internal static const setGoogleUserId               : String = "setGoogleUserId";
        internal static const setJailbroken                 : String = "setJailbroken";
        internal static const setLocation                   : String = "setLocation";
        internal static const setPackageName                : String = "setPackageName";
        internal static const setRedirectUrl                : String = "setRedirectUrl";
        internal static const setShouldAutoDetectJailbroken : String = "setShouldAutoDetectJailbroken";
        internal static const setTRUSTeId                   : String = "setTRUSTeId";
        internal static const setTwitterUserId              : String = "setTwitterUserId";
        internal static const setUseCookieTracking          : String = "setUseCookieTracking";
        internal static const setUserEmail                  : String = "setUserEmail";
        internal static const setUserId                     : String = "setUserId";
        internal static const setUserName                   : String = "setUserName";
        internal static const setPhoneNumber                : String = "setPhoneNumber";
        internal static const setPayingUser                 : String = "setPayingUser";
        
        // Getter Methods
        internal static const getAdvertisingId              : String = "getAdvertisingId";
        internal static const getMatId                      : String = "getMatId";
        internal static const getOpenLogId                  : String = "getOpenLogId";
        internal static const getIsPayingUser               : String = "getIsPayingUser";
        
        // Apple related setters
        internal static const setAppleAdvertisingIdentifier : String = "setAppleAdvertisingIdentifier";
        internal static const setAppleVendorIdentifier      : String = "setAppleVendorIdentifier";
        
        internal static const setShouldAutoGenerateAppleVendorIdentifier : String = "setShouldAutoGenerateAppleVendorIdentifier";
        
        // Android getter
        internal static const getReferrer                   : String = "getReferrer";
        
        // Cross-Promo Methods
        internal static const showBanner                    : String = "showBanner";
        internal static const hideBanner                    : String = "hideBanner";
        internal static const destroyBanner                 : String = "destroyBanner";
        internal static const cacheInterstitial             : String = "cacheInterstitial";
        internal static const showInterstitial              : String = "showInterstitial";
        internal static const destroyInterstitial           : String = "destroyInterstitial";
    }
}