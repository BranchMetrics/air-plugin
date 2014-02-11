package com.hasoffers.nativeExtensions
{
	internal class NativeMethods
	{
		// Main MAT initialization methods
		internal static const initNativeCode 			: String = "initNativeCode";
		internal static const startAppToAppTracking		: String = "startAppToAppTracking";
		
		// List of params to be used for the MAT tracking requests
		internal static const getSDKDataParameters 		: String = "getSDKDataParameters";
		
		// Tracking methods: install/update 
		internal static const trackSession				: String = "trackSession";
		
		// Tracking methods: events and eventItems
		internal static const trackAction 				: String = "trackAction";
		internal static const trackActionWithEventItem 	: String = "trackActionWithEventItem";
		
		// Methods to help debugging and testing
		internal static const setDebugMode 				: String = "setDebugMode";
		internal static const setAllowDuplicates 		: String = "setAllowDuplicates";
		
		// Set MAT delegate to receive success/failure callbacks
		internal static const setDelegate				: String = "setDelegate";
		
		// Setter methods to override default values
		internal static const setAge	 						: String = "setAge";
		internal static const setAppAdTracking					: String = "setAppAdTracking";
		internal static const setCurrencyCode 					: String = "setCurrencyCode";
		internal static const setEventAttribute					: String = "setEventAttribute";
		internal static const setExistingUser					: String = "setExistingUser";
		internal static const setFacebookUserId 				: String = "setFacebookUserId";
		internal static const setGender 						: String = "setGender";
		internal static const setGoogleAdvertisingId			: String = "setGoogleAdvertisingId";
		internal static const setGoogleUserId 					: String = "setGoogleUserId";
		internal static const setJailbroken						: String = "setJailbroken";
		internal static const setLocation 						: String = "setLocation";
		internal static const setPackageName 					: String = "setPackageName";
		internal static const setRedirectUrl 					: String = "setRedirectUrl";
		internal static const setShouldAutoDetectJailbroken		: String = "setShouldAutoDetectJailbroken";
		internal static const setSiteId 						: String = "setSiteId";
		internal static const setTRUSTeId 						: String = "setTRUSTeId";
		internal static const setTwitterUserId 					: String = "setTwitterUserId";
		internal static const setUseCookieTracking				: String = "setUseCookieTracking";
		internal static const setUserEmail						: String = "setUserEmail";
		internal static const setUserId 						: String = "setUserId";
		internal static const setUserName						: String = "setUserName";
		
		// Apple related setters
		internal static const setAppleAdvertisingIdentifier 					: String = "setAppleAdvertisingIdentifier";
		internal static const setAppleVendorIdentifier							: String = "setAppleVendorIdentifier";
		
		internal static const setShouldAutoGenerateAppleVendorIdentifier 		: String = "setShouldAutoGenerateAppleVendorIdentifier";
		
		// Android getter
		internal static const getReferrer						: String = "getReferrer";
	}
}