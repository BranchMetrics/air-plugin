package com.hasoffers.nativeExtensions
{
    internal class NativeMethods
    {
        // Main MAT initialization methods
        internal static const initNativeCode                : String = "initNativeCode";
        internal static const startAppToAppTracking         : String = "startAppToAppTracking";
        
        // Measuring methods: install/update 
        internal static const measureSession                : String = "measureSession";
        
        // Measuring methods: events and eventItems
        internal static const measureAction                 : String = "measureAction";
        internal static const measureActionWithEventItems   : String = "measureActionWithEventItems";
        
        // Methods to help debugging and testing
        internal static const setDebugMode                  : String = "setDebugMode";
        internal static const setAllowDuplicates            : String = "setAllowDuplicates";
        
        // Set MAT delegate to receive success/failure callbacks
        internal static const setDelegate                   : String = "setDelegate";
        
        // Setter methods to override default values
        internal static const setAge                        : String = "setAge";
        internal static const setAppAdTracking              : String = "setAppAdTracking";
        internal static const setCurrencyCode               : String = "setCurrencyCode";
        internal static const setEventAttribute             : String = "setEventAttribute";
        internal static const setExistingUser               : String = "setExistingUser";
        internal static const setFacebookUserId             : String = "setFacebookUserId";
        internal static const setGender                     : String = "setGender";
        internal static const setGoogleAdvertisingId        : String = "setGoogleAdvertisingId";
        internal static const setGoogleUserId               : String = "setGoogleUserId";
        internal static const setJailbroken                 : String = "setJailbroken";
        internal static const setLocation                   : String = "setLocation";
        internal static const setPackageName                : String = "setPackageName";
        internal static const setRedirectUrl                : String = "setRedirectUrl";
        internal static const setShouldAutoDetectJailbroken : String = "setShouldAutoDetectJailbroken";
        internal static const setSiteId                     : String = "setSiteId";
        internal static const setTRUSTeId                   : String = "setTRUSTeId";
        internal static const setTwitterUserId              : String = "setTwitterUserId";
        internal static const setUseCookieTracking          : String = "setUseCookieTracking";
        internal static const setUserEmail                  : String = "setUserEmail";
        internal static const setUserId                     : String = "setUserId";
        internal static const setUserName                   : String = "setUserName";
        internal static const setPayingUser                 : String = "setPayingUser";
        
        // Getter Methods
        internal static const getMatId                      : String = "getMatId";
        internal static const getOpenLogId                  : String = "getOpenLogId";
        internal static const getIsPayingUser               : String = "getIsPayingUser";
        
        // Apple related setters
        internal static const setAppleAdvertisingIdentifier : String = "setAppleAdvertisingIdentifier";
        internal static const setAppleVendorIdentifier      : String = "setAppleVendorIdentifier";
        
        internal static const setShouldAutoGenerateAppleVendorIdentifier : String = "setShouldAutoGenerateAppleVendorIdentifier";
        
        // Android getter
        internal static const getReferrer                   : String = "getReferrer";
    }
}