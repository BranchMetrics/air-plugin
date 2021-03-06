#import "FlashRuntimeExtensions.h"
#import "FRETypeConversionHelper.h"
#import "Tune.h"

#import <AdSupport/AdSupport.h>
#import <iAd/iAd.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <StoreKit/StoreKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fnVisibleName, data, fnActualName) { (const uint8_t*)(#fnVisibleName), (data), &(fnActualName) }

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif

#pragma mark - TuneDelegate Methods

static FREContext tuneFREContext;

@interface TuneSDKDelegate : NSObject<TuneDelegate>

@end

#pragma mark - Tune Plugin Helper Category

@interface Tune (TuneAIRPlugin)

+ (void)setPluginName:(NSString *)pluginName;

@end

@implementation TuneSDKDelegate

-(void)tuneDidSucceedWithData:(NSData *)data
{
    DLog(@"TuneSDKDelegate: tuneDidSucceedWithData:");
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //DLog(@"TuneSDKDelegate: success = %@", str);
    
    const char *code = "success";
    const char *level = [str UTF8String];
    
    FREDispatchStatusEventAsync(tuneFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

-(void)tuneDidFailWithError:(NSError *)error
{
    DLog(@"TuneSDKDelegate: tuneDidFailWithError:");
    //DLog(@"TuneSDKDelegate: error = %@", error);
    
    const char *code = "failure";
    
    NSInteger errorCode = [error code];
    NSString *errorDescr = [error localizedDescription];
    
    NSString *errorURLString = nil;
    NSDictionary *dictError = [error userInfo];
    
    if(dictError)
    {
        errorURLString = [dictError objectForKey:NSURLErrorFailingURLStringErrorKey];
    }
    
    errorURLString = nil == error ? @"" : errorURLString;
    
    NSString *strError = [NSString stringWithFormat:@"{\"code\":\"%ld\",\"localizedDescription\":\"%@\",\"failedURL\":\"%@\"}", (long)errorCode, errorDescr, errorURLString];
    
    const char *level = [strError UTF8String];
    
    FREDispatchStatusEventAsync(tuneFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

-(void)tuneEnqueuedActionWithReferenceId:(NSString *)referenceId
{
    DLog(@"TuneSDKDelegate: tunrEnqueuedActionWithReferenceId: referenceId = %@", referenceId);
    
    const char *code = "enqueued";
    const char *level = [referenceId UTF8String];
    
    FREDispatchStatusEventAsync(tuneFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

-(void)tuneDidReceiveDeeplink:(NSString *)deeplink
{
    DLog(@"TuneSDKDelegate: tuneDidReceiveDeeplink: deferred deeplink = %@", deeplink);
    
    const char *code = "TUNE_DEEPLINK";
    const char *level = [deeplink UTF8String];
    
    FREDispatchStatusEventAsync(tuneFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

-(void)tuneDidFailDeeplinkWithError:(NSError *)error
{
    DLog(@"TuneSDKDelegate: deferred deeplink error = %@", error);
    
    const char *code = "TUNE_DEEPLINK_FAILED";
    
    NSInteger errorCode = [error code];
    NSString *errorDescr = [error localizedDescription];
    
    NSString *errorURLString = nil;
    NSDictionary *dictError = [error userInfo];
    
    if(dictError)
    {
        errorURLString = [dictError objectForKey:NSURLErrorFailingURLStringErrorKey];
    }
    
    errorURLString = nil == error ? @"" : errorURLString;
    
    NSString *strError = [NSString stringWithFormat:@"{\"code\":\"%ld\",\"localizedDescription\":\"%@\",\"failedURL\":\"%@\"}", (long)errorCode, errorDescr, errorURLString];
    
    const char *level = [strError UTF8String];
    
    FREDispatchStatusEventAsync(tuneFREContext, (const uint8_t *)code, (const uint8_t *)level);
}


@end

#pragma mark - Date Helper Methods

// refer http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Date.html#toUTCString()
// example: Wed Apr 23 19:30:07 2014 UTC
static const char *TUNE_DATE_TIME_FORMAT = "EEE MMM d HH:mm:ss yyyy zzz";

NSDateFormatter* dateFormatter()
{
    static NSDateFormatter* sharedDateFormatter = nil;
    
    if(nil == sharedDateFormatter)
    {
        sharedDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sharedDateFormatter setLocale:enUSPOSIXLocale];
        [sharedDateFormatter setDateFormat:[NSString stringWithUTF8String:TUNE_DATE_TIME_FORMAT]];
        [sharedDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return sharedDateFormatter;
}

#pragma mark - AIR iPhone Native Extension Methods

DEFINE_ANE_FUNCTION(Init)
{
    DLog(@"Init start");
    
    NSString *advId = nil;
    Tune_FREGetObjectAsString(argv[0], &advId);
    
    NSString *conversionKey = nil;
    Tune_FREGetObjectAsString(argv[1], &conversionKey);
    
    [Tune initializeWithTuneAdvertiserId:advId
                       tuneConversionKey:conversionKey];
    [Tune setPluginName:@"air"];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(CheckForDeferredDeeplinkFunction)
{
    DLog(@"CheckForDeferredDeeplinkFunction");
    
    [Tune checkForDeferredDeeplink:[TuneSDKDelegate new]];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(MeasureSessionFunction)
{
    DLog(@"MeasureSessionFunction start");
    
    [Tune measureSession];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(MeasureEventNameFunction)
{
    DLog("@MeasureEventNameFunction start");
    
    NSString *event = nil;
    Tune_FREGetObjectAsString(argv[0], &event);
    
    [Tune measureEventName:event];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(MeasureEventFunction)
{
    DLog("@MeasureEventFunction start");
    
    NSString *event = nil;
    Tune_FREGetObjectAsString(argv[0], &event);
    
    uint32_t arrayLength = 0;
    NSMutableArray *eventItems = [NSMutableArray array];
    FREObject arrEventItems = argv[1];
    if (arrEventItems)
    {
        if (FREGetArrayLength(arrEventItems, &arrayLength) != FRE_OK)
        {
            arrayLength = 0;
        }
        
        for (uint32_t i = 0; i < arrayLength; i += 9)
        {
            NSString *itemName = nil;
            double_t itemUnitPrice;
            uint32_t itemQty;
            double_t itemRevenue;
            NSString *itemAttr1 = nil;
            NSString *itemAttr2 = nil;
            NSString *itemAttr3 = nil;
            NSString *itemAttr4 = nil;
            NSString *itemAttr5 = nil;
            
            FREObject freItemName = NULL;
            FREObject freItemUnitPrice = NULL;
            FREObject freItemQty = NULL;
            FREObject freItemRevenue = NULL;
            FREObject freItemAttr1 = NULL;
            FREObject freItemAttr2 = NULL;
            FREObject freItemAttr3 = NULL;
            FREObject freItemAttr4 = NULL;
            FREObject freItemAttr5 = NULL;
            
            if(FRE_OK == FREGetArrayElementAt(arrEventItems, i, &freItemName)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 1, &freItemUnitPrice)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 2, &freItemQty)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 3, &freItemRevenue)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 4, &freItemAttr1)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 5, &freItemAttr2)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 6, &freItemAttr3)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 7, &freItemAttr4)
               && FRE_OK == FREGetArrayElementAt(arrEventItems, i + 8, &freItemAttr5))
            {
                if(FRE_OK == Tune_FREGetObjectAsString(freItemName, &itemName))
                {
                    FREGetObjectAsDouble(freItemUnitPrice, &itemUnitPrice);
                    FREGetObjectAsUint32(freItemQty, &itemQty);
                    FREGetObjectAsDouble(freItemRevenue, &itemRevenue);
                    Tune_FREGetObjectAsString(freItemAttr1, &itemAttr1);
                    Tune_FREGetObjectAsString(freItemAttr2, &itemAttr2);
                    Tune_FREGetObjectAsString(freItemAttr3, &itemAttr3);
                    Tune_FREGetObjectAsString(freItemAttr4, &itemAttr4);
                    Tune_FREGetObjectAsString(freItemAttr5, &itemAttr5);
                    
                    TuneEventItem *eventItem = [TuneEventItem eventItemWithName:itemName unitPrice:itemUnitPrice quantity:itemQty revenue:itemRevenue attribute1:itemAttr1 attribute2:itemAttr2 attribute3:itemAttr3 attribute4:itemAttr4 attribute5:itemAttr5];
                    
                    // Add the eventItem to the array
                    [eventItems addObject:eventItem];
                }
            }
        }
    }
    
    double revenue = 0;
    FREGetObjectAsDouble(argv[2], &revenue);
    
    NSString *currencyCode = nil;
    Tune_FREGetObjectAsString(argv[3], &currencyCode);
    
    NSString *refId = nil;
    Tune_FREGetObjectAsString(argv[4], &refId);
    
    NSString *strReceipt = nil;
    Tune_FREGetObjectAsString(argv[5], &strReceipt);
    NSData *receipt = [strReceipt dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *attr1 = nil;
    Tune_FREGetObjectAsString(argv[7], &attr1);
    
    NSString *attr2 = nil;
    Tune_FREGetObjectAsString(argv[8], &attr2);
    
    NSString *attr3 = nil;
    Tune_FREGetObjectAsString(argv[9], &attr3);
    
    NSString *attr4 = nil;
    Tune_FREGetObjectAsString(argv[10], &attr4);
    
    NSString *attr5 = nil;
    Tune_FREGetObjectAsString(argv[11], &attr5);
    
    NSString *contentId = nil;
    Tune_FREGetObjectAsString(argv[12], &contentId);
    
    NSString *contentType = nil;
    Tune_FREGetObjectAsString(argv[13], &contentType);
    
    NSString *dateString = nil;
    Tune_FREGetObjectAsString(argv[14], &dateString);
    NSDate* date1 = [dateFormatter() dateFromString:dateString];
    
    Tune_FREGetObjectAsString(argv[15], &dateString);
    NSDate* date2 = [dateFormatter() dateFromString:dateString];
    
    int32_t level;
    FREGetObjectAsInt32(argv[16], &level);
    
    int32_t quantity;
    FREGetObjectAsInt32(argv[17], &quantity);
    
    double rating;
    FREGetObjectAsDouble(argv[18], &rating);
    
    NSString *searchString = nil;
    Tune_FREGetObjectAsString(argv[19], &searchString);
    
    TuneEvent *tuneEvent = [TuneEvent eventWithName:event];
    tuneEvent.eventItems = eventItems;
    tuneEvent.revenue = revenue;
    tuneEvent.currencyCode = currencyCode;
    tuneEvent.refId = refId;
    tuneEvent.receipt = receipt;
    tuneEvent.attribute1 = attr1;
    tuneEvent.attribute2 = attr2;
    tuneEvent.attribute3 = attr3;
    tuneEvent.attribute4 = attr4;
    tuneEvent.attribute5 = attr5;
    tuneEvent.contentId = contentId;
    tuneEvent.contentType = contentType;
    tuneEvent.date1 = date1;
    tuneEvent.date2 = date2;
    tuneEvent.level = level;
    tuneEvent.quantity = quantity;
    tuneEvent.rating = rating;
    tuneEvent.searchString = searchString;
    
    [Tune measureEvent:tuneEvent];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(StartAppToAppTrackingFunction)
{
    DLog(@"StartAppToAppTrackingFunction");
    
    NSString *targetAppId = nil;
    Tune_FREGetObjectAsString(argv[0], &targetAppId);
    
    NSString *advertiserId = nil;
    Tune_FREGetObjectAsString(argv[1], &advertiserId);
    
    NSString *offerId = nil;
    Tune_FREGetObjectAsString(argv[2], &offerId);
    
    NSString *publisherId = nil;
    Tune_FREGetObjectAsString(argv[3], &publisherId);
    
    uint32_t bRedirect;
    FREGetObjectAsBool(argv[4], &bRedirect);
    BOOL shouldRedirect = 1 == bRedirect;
    
    [Tune startAppToAppMeasurement:targetAppId advertiserId:advertiserId offerId:offerId publisherId:publisherId redirect:shouldRedirect];
    
    return NULL;
}

#pragma mark - Setter Methods

DEFINE_ANE_FUNCTION(SetDebugModeFunction)
{
    DLog(@"SetDebugModeFunction");
    
    uint32_t shouldDebug;
    FREGetObjectAsBool(argv[0], &shouldDebug);
    
    [Tune setDebugMode:1 == shouldDebug];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetJailbrokenFunction)
{
    DLog(@"SetJailbrokenFunction");
    
    uint32_t isJailbroken;
    FREGetObjectAsBool(argv[0], &isJailbroken);
    BOOL jailbroken = 1 == isJailbroken;
    
    [Tune setJailbroken:jailbroken];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoDetectJailbrokenFunction)
{
    DLog(@"Native: SetShouldAutoDetectJailbrokenFunction");
    
    uint32_t isAutoDetect;
    FREGetObjectAsBool(argv[0], &isAutoDetect);
    BOOL shouldAutoDetect = 1 == isAutoDetect;
    
    [Tune setShouldAutoDetectJailbroken:shouldAutoDetect];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateAppleVendorIdentifierFunction)
{
    DLog(@"Native: setShouldAutoGenerateAppleVendorIdentifier");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [Tune setShouldAutoGenerateAppleVendorIdentifier:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUseCookieTrackingFunction)
{
    DLog(@"SetUseCookieTrackingFunction");
    
    uint32_t isUseCookieTracking;
    FREGetObjectAsBool(argv[0], &isUseCookieTracking);
    BOOL useCookieTracking = 1 == isUseCookieTracking;
    
    [Tune setUseCookieMeasurement:useCookieTracking];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetRedirectUrlFunction)
{
    DLog(@"SetRedirectUrlFunction");
    
    NSString *redirectUrl = nil;
    Tune_FREGetObjectAsString(argv[0], &redirectUrl);
    
    [Tune setRedirectUrl:redirectUrl];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetCurrencyCodeFunction)
{
    DLog(@"SetCurrencyCodeFunction");
    
    NSString *currencyCode = nil;
    Tune_FREGetObjectAsString(argv[0], &currencyCode);
    
    [Tune setCurrencyCode:currencyCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetPhoneNumberFunction)
{
    DLog(@"SetPhoneNumberFunction");
    
    NSString *phoneNumber = nil;
    Tune_FREGetObjectAsString(argv[0], &phoneNumber);
    
    [Tune setPhoneNumber:phoneNumber];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserEmailFunction)
{
    DLog(@"SetUserEmailFunction");
    
    NSString *userEmail = nil;
    Tune_FREGetObjectAsString(argv[0], &userEmail);
    
    [Tune setUserEmail:userEmail];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserIdFunction)
{
    DLog(@"SetUserIdFunction");
    
    NSString *userId = nil;
    Tune_FREGetObjectAsString(argv[0], &userId);
    
    [Tune setUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserNameFunction)
{
    DLog(@"SetUserNameFunction");
    
    NSString *userName = nil;
    Tune_FREGetObjectAsString(argv[0], &userName);
    
    [Tune setUserName:userName];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetFacebookUserIdFunction)
{
    DLog(@"SetFacebookUserIdFunction");
    
    NSString *userId = nil;
    Tune_FREGetObjectAsString(argv[0], &userId);
    
    [Tune setFacebookUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetTwitterUserIdFunction)
{
    DLog(@"SetTwitterUserIdFunction");
    
    NSString *userId = nil;
    Tune_FREGetObjectAsString(argv[0], &userId);
    
    [Tune setTwitterUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetGoogleUserIdFunction)
{
    DLog(@"SetGoogleUserIdFunction");
    
    NSString *userId = nil;
    Tune_FREGetObjectAsString(argv[0], &userId);
    
    [Tune setGoogleUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAppAdTrackingFunction)
{
    DLog(@"SetAppAdTrackingFunction");
    
    uint32_t isOptOut;
    FREGetObjectAsBool(argv[0], &isOptOut);
    BOOL optout = 1 == isOptOut;
    
    [Tune setAppAdMeasurement:optout];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetPackageNameFunction)
{
    DLog(@"SetPackageNameFunction");
    
    NSString *pkgName = nil;
    Tune_FREGetObjectAsString(argv[0], &pkgName);
    
    [Tune setPackageName:pkgName];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAgeFunction)
{
    DLog(@"SetAgeFunction");
    
    int32_t age;
    FREGetObjectAsInt32(argv[0], &age);
    
    [Tune setAge:age];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetGenderFunction)
{
    DLog(@"SetGenderFunction");
    
    uint32_t gender;
    FREGetObjectAsUint32(argv[0], &gender);
    
    [Tune setGender:gender];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetLocationFunction)
{
    DLog(@"SetLocationFunction");
    
    double_t lat;
    FREGetObjectAsDouble(argv[0], &lat);
    
    double_t lon;
    FREGetObjectAsDouble(argv[1], &lon);
    
    double_t alt;
    FREGetObjectAsDouble(argv[2], &alt);
    
    TuneLocation *loc = [TuneLocation new];
    loc.latitude = @(lat);
    loc.longitude = @(lon);
    loc.altitude = @(alt);
    
    [Tune setLocation:loc];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetTRUSTeIdFunction)
{
    DLog(@"SetTRUSTeIdFunction");
    
    NSString *trusteId = nil;
    Tune_FREGetObjectAsString(argv[0], &trusteId);
    
    [Tune setTRUSTeId:trusteId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetExistingUserFunction)
{
    DLog(@"SetExistingUserFunction");
    
    uint32_t isExisting;
    FREGetObjectAsBool(argv[0], &isExisting);
    BOOL existing = 1 == isExisting;
    
    [Tune setExistingUser:existing];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetFacebookEventLogging)
{
    DLog(@"SetFacebookEventLogging");
    
    uint32_t shouldEnable;
    FREGetObjectAsBool(argv[0], &shouldEnable);
    BOOL enable = 1 == shouldEnable;
    
    uint32_t shouldLimit;
    FREGetObjectAsBool(argv[1], &shouldLimit);
    BOOL limit = 1 == shouldLimit;
    
    [Tune setFacebookEventLogging:enable limitEventAndDataUsage:limit];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetPayingUserFunction)
{
    DLog(@"SetPayingUserFunction");
    
    uint32_t isPaying;
    FREGetObjectAsBool(argv[0], &isPaying);
    BOOL payingUser = 1 == isPaying;
    
    [Tune setPayingUser:payingUser];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAppleAdvertisingIdentifierFunction)
{
    DLog(@"SetAppleAdvertisingIdentifierFunction");
    
    NSString *aId = nil;
    Tune_FREGetObjectAsString(argv[0], &aId);
    
    NSUUID *appleAdvId = [[NSUUID alloc] initWithUUIDString:aId];
    
    uint32_t isTrackingEnabled;
    FREGetObjectAsBool(argv[1], &isTrackingEnabled);
    BOOL trackingEnabled = 1 == isTrackingEnabled;
    
    [Tune setAppleAdvertisingIdentifier:appleAdvId advertisingTrackingEnabled:trackingEnabled];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAppleVendorIdentifierFunction)
{
    DLog(@"SetAppleVendorIdentifierFunction");
    
    NSString *vId = nil;
    Tune_FREGetObjectAsString(argv[0], &vId);
    
    NSUUID *appleVendorId = [[NSUUID alloc] initWithUUIDString:vId];
    
    [Tune setAppleVendorIdentifier:appleVendorId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetDelegateFunction)
{
    DLog(@"SetDelegateFunction");
    
    uint32_t isUseDelegate;
    FREGetObjectAsBool(argv[0], &isUseDelegate);
    BOOL useDelegate = 1 == isUseDelegate;
    
    TuneSDKDelegate *sdkDelegate = nil;
    
    if(useDelegate)
    {
        // when enabled set an object of TuneSDKDelegate as the delegate for Tune
        sdkDelegate = [[TuneSDKDelegate alloc] init];
    }
    [Tune setDelegate:sdkDelegate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetDeepLinkFunction)
{
    DLog(@"SetDeepLinkFunction");
    
    NSString *deepLinkUrl = nil;
    Tune_FREGetObjectAsString(argv[0], &deepLinkUrl);
    
    [Tune applicationDidOpenURL:deepLinkUrl sourceApplication:nil];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(GetAdvertisingIdFunction)
{
    DLog(@"GetAdvertisingIdFunction");
    
    NSString *advertisingId = [Tune appleAdvertisingIdentifier];
    
    // Convert Obj-C string to C UTF8String
    const char *strIfa = [advertisingId UTF8String];
    
    // Prepare for AS3
    FREObject retIfa = nil;
    FRENewObjectFromUTF8((unsigned int)strlen(strIfa) + 1, (const uint8_t*)strIfa, &retIfa);
    
    // Return data back to ActionScript
    return retIfa;
}

DEFINE_ANE_FUNCTION(GetMatIdFunction)
{
    DLog(@"GetMatIdFunction");
    
    NSString *matId = [Tune tuneId];
    
    // Convert Obj-C string to C UTF8String
    const char *strMatId = [matId UTF8String];
    
    // Prepare for AS3
    FREObject retMatId = nil;
    FRENewObjectFromUTF8((unsigned int)strlen(strMatId) + 1, (const uint8_t*)strMatId, &retMatId);
    
    // Return data back to ActionScript
    return retMatId;
}

DEFINE_ANE_FUNCTION(GetOpenLogIdFunction)
{
    DLog(@"GetOpenLogIdFunction");
    
    NSString *openLogId = [Tune openLogId];
    
    // Convert Obj-C string to C UTF8String
    const char *strOpenLogId = [openLogId UTF8String];
    
    // Prepare for AS3
    FREObject retOpenLogId = nil;
    
    if(strOpenLogId)
    {
        FRENewObjectFromUTF8((unsigned int)strlen(strOpenLogId) + 1, (const uint8_t*)strOpenLogId, &retOpenLogId);
    }
    
    // Return data back to ActionScript
    return retOpenLogId;
}

DEFINE_ANE_FUNCTION(GetIsPayingUserFunction)
{
    DLog(@"GetIsPayingUserFunction");
    
    BOOL payingUser = [Tune isPayingUser];
    
    // Prepare for AS3
    FREObject retPayingUser = nil;
    FRENewObjectFromBool(payingUser, &retPayingUser);
    
    // Return data back to ActionScript
    return retPayingUser;
}

DEFINE_ANE_FUNCTION(GetReferrerFunction)
{
    // Dummy Function for Android -- not applicable in iOS
    return NULL;
}

DEFINE_ANE_FUNCTION(SetGoogleAdvertisingIdFunction)
{
    // Dummy Function for Android -- not applicable in iOS
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAndroidIdFunction)
{
    // Dummy Function for Android -- not applicable in iOS
    return NULL;
}

#pragma mark - Extension Context Setup Methods

void TuneExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    DLog(@"TuneANE.TuneExtContextInitializer");
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(init,                                          NULL, Init),
        
        MAP_FUNCTION(startAppToAppTracking,                         NULL, StartAppToAppTrackingFunction),
        
        MAP_FUNCTION(measureSession,                                NULL, MeasureSessionFunction),
        MAP_FUNCTION(measureEvent,                                  NULL, MeasureEventFunction),
        MAP_FUNCTION(measureEventName,                              NULL, MeasureEventNameFunction),
        
        MAP_FUNCTION(setCurrencyCode,                               NULL, SetCurrencyCodeFunction),
        MAP_FUNCTION(setDebugMode,                                  NULL, SetDebugModeFunction),
        MAP_FUNCTION(setDeepLink,                                   NULL, SetDeepLinkFunction),
        MAP_FUNCTION(setDelegate,                                   NULL, SetDelegateFunction),
        MAP_FUNCTION(setAppAdTracking,                              NULL, SetAppAdTrackingFunction),
        MAP_FUNCTION(setExistingUser,                               NULL, SetExistingUserFunction),
        MAP_FUNCTION(setFacebookEventLogging,                       NULL, SetFacebookEventLogging),
        MAP_FUNCTION(setJailbroken,                                 NULL, SetJailbrokenFunction),
        MAP_FUNCTION(setPackageName,                                NULL, SetPackageNameFunction),
        MAP_FUNCTION(setPhoneNumber,                                NULL, SetPhoneNumberFunction),
        MAP_FUNCTION(setRedirectUrl,                                NULL, SetRedirectUrlFunction),
        MAP_FUNCTION(setShouldAutoDetectJailbroken,                 NULL, SetShouldAutoDetectJailbrokenFunction),
        MAP_FUNCTION(setTRUSTeId,                                   NULL, SetTRUSTeIdFunction),
        MAP_FUNCTION(setUseCookieTracking,                          NULL, SetUseCookieTrackingFunction),
        MAP_FUNCTION(setUserEmail,                                  NULL, SetUserEmailFunction),
        MAP_FUNCTION(setUserId,                                     NULL, SetUserIdFunction),
        MAP_FUNCTION(setUserName,                                   NULL, SetUserNameFunction),
        MAP_FUNCTION(setFacebookUserId,                             NULL, SetFacebookUserIdFunction),
        MAP_FUNCTION(setTwitterUserId,                              NULL, SetTwitterUserIdFunction),
        MAP_FUNCTION(setGoogleUserId,                               NULL, SetGoogleUserIdFunction),
        MAP_FUNCTION(setPayingUser,                                 NULL, SetPayingUserFunction),
        
        MAP_FUNCTION(setAge,                                        NULL, SetAgeFunction),
        MAP_FUNCTION(setGender,                                     NULL, SetGenderFunction),
        MAP_FUNCTION(setLocation,                                   NULL, SetLocationFunction),
        
        MAP_FUNCTION(setAppleAdvertisingIdentifier,                 NULL, SetAppleAdvertisingIdentifierFunction),
        MAP_FUNCTION(setAppleVendorIdentifier,                      NULL, SetAppleVendorIdentifierFunction),
        
        MAP_FUNCTION(setShouldAutoGenerateAppleVendorIdentifier,    NULL, SetShouldAutoGenerateAppleVendorIdentifierFunction),
        
        MAP_FUNCTION(getAdvertisingId,                              NULL, GetAdvertisingIdFunction),
        MAP_FUNCTION(getMatId,                                      NULL, GetMatIdFunction),
        MAP_FUNCTION(getOpenLogId,                                  NULL, GetOpenLogIdFunction),
        MAP_FUNCTION(getIsPayingUser,                               NULL, GetIsPayingUserFunction),
        
        MAP_FUNCTION(getReferrer,                                   NULL, GetReferrerFunction),
        MAP_FUNCTION(setGoogleAdvertisingId,                        NULL, SetGoogleAdvertisingIdFunction),
        MAP_FUNCTION(setAndroidId,                                  NULL, SetAndroidIdFunction),
        
        MAP_FUNCTION(checkForDeferredDeeplink,                      NULL, CheckForDeferredDeeplinkFunction)
    };
    
    *numFunctionsToSet = sizeof( functions ) / sizeof( FRENamedFunction );
    *functionsToSet = functions;
    
    tuneFREContext = ctx;
}

void TuneExtContextFinalizer(FREContext ctx)
{
    DLog(@"TuneANE.TuneExtContextFinalizer");
    return;
}

void TuneExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    DLog(@"TuneANE.TuneExtInitializer");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &TuneExtContextInitializer;
    *ctxFinalizerToSet = &TuneExtContextFinalizer;
}

void TuneExtFinalizer(void * extData)
{
    DLog(@"TuneANE.TuneExtFinalizer");
    return;
}
