#import "FlashRuntimeExtensions.h"
#import "FRETypeConversionHelper.h"
#import "MobileAppTracker.h"
#import <UIKit/UIKit.h>

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fnVisibleName, data, fnActualName) { (const uint8_t*)(#fnVisibleName), (data), &(fnActualName) }

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif

#pragma mark - MobileAppTrackerDelegate Methods

static FREContext matFREContext;

@interface MATSDKDelegate : NSObject<MobileAppTrackerDelegate>
// empty
@end

@implementation MATSDKDelegate

- (void)mobileAppTrackerDidSucceedWithData:(id)data
{
    DLog(@"MATSDKDelegate: mobileAppTracker:didSucceedWithData:");
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //DLog(@"MATSDKDelegate: success = %@", str);

    const char *code = "success";
    const char *level = [str UTF8String];
    
    FREDispatchStatusEventAsync(matFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

- (void)mobileAppTrackerDidFailWithError:(NSError *)error
{
    DLog(@"MATSDKDelegate: mobileAppTracker:didFailWithError:");
    //DLog(@"MATSDKDelegate: error = %@", error);
    
    const char * code = "failure";
    
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
    
    FREDispatchStatusEventAsync(matFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

- (void)mobileAppTrackerEnqueuedActionWithReferenceId:(NSString *)referenceId
{
    DLog(@"MATSDKDelegate: mobileAppTrackerEnqueuedActionWithReferenceId:");
    //DLog(@"MATSDKDelegate: referenceId = %@", referenceId);
    
    const char *code = "enqueued";
    const char *level = [referenceId UTF8String];
    
    FREDispatchStatusEventAsync(matFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

@end

#pragma mark - Date Helper Methods

// refer http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Date.html#toUTCString()
// example: Wed Apr 23 19:30:07 2014 UTC
static const char * MAT_DATE_TIME_FORMAT = "EEE MMM dd HH:mm:ss yyyy ZZZ";

NSDateFormatter* dateFormatter()
{
    static NSDateFormatter* sharedDateFormatter = nil;
    
    if(nil == sharedDateFormatter)
    {
        sharedDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sharedDateFormatter setLocale:enUSPOSIXLocale];
        [sharedDateFormatter setDateFormat:[NSString stringWithUTF8String:MAT_DATE_TIME_FORMAT]];
        [sharedDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return sharedDateFormatter;
}

#pragma mark - AIR iPhone Native Extension Methods

DEFINE_ANE_FUNCTION(InitNativeCode)
{
    DLog(@"InitNativeCode start");
    
    NSString *advId = nil;
    MAT_FREGetObjectAsString(argv[0], &advId);
    
    NSString *conversionKey = nil;
    MAT_FREGetObjectAsString(argv[1], &conversionKey);
    
    [MobileAppTracker initializeWithMATAdvertiserId:advId
                                   MATConversionKey:conversionKey];
    [MobileAppTracker setPluginName:@"air"];
    
    DLog(@"initNativeCode end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(CheckForDeferredDeeplink)
{
    DLog(@"CheckForDeferredDeeplink");
    
    double_t millis;
    FREGetObjectAsDouble(argv[0], &millis);
    
    [MobileAppTracker checkForDeferredDeeplinkWithTimeout:millis / 1000];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(MeasureSessionFunction)
{
    DLog(@"MeasureSessionFunction start");
    
    [MobileAppTracker measureSession];
    
    DLog(@"MeasureSessionFunction end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(MeasureActionWithEventItemsFunction)
{
    DLog(@"MeasureActionWithEventItemsFunction start");
    
    NSString *event = nil;
    FREResult result;
    result = MAT_FREGetObjectAsString(argv[0], &event);
    
    double revenue = 0;
    result = FREGetObjectAsDouble(argv[2], &revenue);
    
    NSString *currencyCode = nil;
    result = MAT_FREGetObjectAsString(argv[3], &currencyCode);
    
    NSString *refId = nil;
    result = MAT_FREGetObjectAsString(argv[4], &refId);
    
    int32_t transactionState = 0;
    result = FREGetObjectAsInt32(argv[5], &transactionState);
    
    NSString *strReceipt = nil;
    result = MAT_FREGetObjectAsString(argv[6], &strReceipt);
    NSData *receipt = [strReceipt dataUsingEncoding:NSUTF8StringEncoding];
    
    uint32_t arrayLength = 0;
    NSMutableArray *eventItems = [NSMutableArray array];
    
    FREObject arrEventItems = argv[1];
    if (arrEventItems)
    {
        if (FREGetArrayLength(arrEventItems, &arrayLength) != FRE_OK)
        {
            arrayLength = 0;
        }
        
        for (uint32_t i = 0; i < arrayLength; i += 8)
        {
            NSString *itemName;
            double_t itemUnitPrice;
            uint32_t itemQty;
            double_t itemRevenue;
            NSString *itemAttr1;
            NSString *itemAttr2;
            NSString *itemAttr3;
            NSString *itemAttr4;
            NSString *itemAttr5;
            
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
                if(FRE_OK == MAT_FREGetObjectAsString(freItemName, &itemName)
                   && FRE_OK == FREGetObjectAsDouble(freItemUnitPrice, &itemUnitPrice)
                   && FRE_OK == FREGetObjectAsUint32(freItemQty, &itemQty)
                   && FRE_OK == FREGetObjectAsDouble(freItemRevenue, &itemRevenue)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemAttr1, &itemAttr1)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemAttr2, &itemAttr2)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemAttr3, &itemAttr3)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemAttr4, &itemAttr4)
                   && FRE_OK == MAT_FREGetObjectAsString(freItemAttr5, &itemAttr5))
                {
                    MATEventItem *eventItem = [MATEventItem eventItemWithName:itemName unitPrice:itemUnitPrice quantity:itemQty revenue:itemRevenue attribute1:itemAttr1 attribute2:itemAttr2 attribute3:itemAttr3 attribute4:itemAttr4 attribute5:itemAttr5];
                    
                    // Add the eventItem to the array
                    [eventItems addObject:eventItem];
                }
            }
        }
    }
    
    [MobileAppTracker measureAction:event
                         eventItems:eventItems
                        referenceId:refId
                      revenueAmount:revenue
                       currencyCode:currencyCode
                   transactionState:transactionState
                            receipt:receipt];
    
    DLog(@"MeasurePurchaseActionFunction end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(MeasureActionFunction)
{
    DLog(@"MeasureActionFunction");
    
    NSString *event = nil;
    MAT_FREGetObjectAsString(argv[0], &event);
    
    double revenue;
    FREGetObjectAsDouble(argv[1], &revenue);
    
    NSString* currencyCode = nil;
    MAT_FREGetObjectAsString(argv[2], &currencyCode);
    
    NSString *refId = nil;
    MAT_FREGetObjectAsString(argv[3], &refId);
    
    [MobileAppTracker measureAction:event
                        referenceId:refId
                      revenueAmount:revenue
                       currencyCode:currencyCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(StartAppToAppTrackingFunction)
{
    DLog(@"StartAppToAppTrackingFunction");
    
    NSString *targetAppId = nil;
    MAT_FREGetObjectAsString(argv[0], &targetAppId);
    
    NSString *advertiserId = nil;
    MAT_FREGetObjectAsString(argv[1], &advertiserId);
    
    NSString *offerId = nil;
    MAT_FREGetObjectAsString(argv[2], &offerId);
    
    NSString *publisherId = nil;
    MAT_FREGetObjectAsString(argv[3], &publisherId);
    
    uint32_t bRedirect;
    FREGetObjectAsBool(argv[4], &bRedirect);
    BOOL shouldRedirect = 1 == bRedirect;
    
    [MobileAppTracker startAppToAppTracking:targetAppId advertiserId:advertiserId offerId:offerId publisherId:publisherId redirect:shouldRedirect];
    
    return NULL;
}

#pragma mark - Setter Methods

DEFINE_ANE_FUNCTION(SetDebugModeFunction)
{
    DLog(@"SetDebugModeFunction");
    
    uint32_t shouldDebug;
    FREGetObjectAsBool(argv[0], &shouldDebug);
    
    [MobileAppTracker setDebugMode:1 == shouldDebug];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAllowDuplicatesFunction)
{
    DLog(@"SetAllowDuplicatesFunction");
    
    uint32_t isAllowDuplicates;
    FREGetObjectAsBool(argv[0], &isAllowDuplicates);
    BOOL allowDuplicates = 1 == isAllowDuplicates;
    
    [MobileAppTracker setAllowDuplicateRequests:allowDuplicates];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetJailbrokenFunction)
{
    DLog(@"SetJailbrokenFunction");
    
    uint32_t isJailbroken;
    FREGetObjectAsBool(argv[0], &isJailbroken);
    BOOL jailbroken = 1 == isJailbroken;
    
    [MobileAppTracker setJailbroken:jailbroken];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoDetectJailbrokenFunction)
{
    DLog(@"Native: SetShouldAutoDetectJailbrokenFunction");
    
    uint32_t isAutoDetect;
    FREGetObjectAsBool(argv[0], &isAutoDetect);
    BOOL shouldAutoDetect = 1 == isAutoDetect;
    
    [MobileAppTracker setShouldAutoDetectJailbroken:shouldAutoDetect];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetShouldAutoGenerateAppleVendorIdentifierFunction)
{
    DLog(@"Native: setShouldAutoGenerateAppleVendorIdentifier");
    
    uint32_t isAutoGenerate;
    FREGetObjectAsBool(argv[0], &isAutoGenerate);
    BOOL shouldAutoGenerate = 1 == isAutoGenerate;
    
    [MobileAppTracker setShouldAutoGenerateAppleVendorIdentifier:shouldAutoGenerate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetSiteIdFunction)
{
    DLog(@"SetSiteIdFunction");
    
    NSString *siteId = nil;
    MAT_FREGetObjectAsString(argv[0], &siteId);
    
    [MobileAppTracker setSiteId:siteId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUseCookieTrackingFunction)
{
    DLog(@"SetUseCookieTrackingFunction");
    
    uint32_t isUseCookieTracking;
    FREGetObjectAsBool(argv[0], &isUseCookieTracking);
    BOOL useCookieTracking = 1 == isUseCookieTracking;
    
    [MobileAppTracker setUseCookieTracking:useCookieTracking];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetRedirectUrlFunction)
{
    DLog(@"SetRedirectUrlFunction");
    
    NSString *redirectUrl = nil;
    MAT_FREGetObjectAsString(argv[0], &redirectUrl);
    
    [MobileAppTracker setRedirectUrl:redirectUrl];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetCurrencyCodeFunction)
{
    DLog(@"SetCurrencyCodeFunction");
    
    NSString *currencyCode = nil;
    MAT_FREGetObjectAsString(argv[0], &currencyCode);
    
    [MobileAppTracker setCurrencyCode:currencyCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserEmailFunction)
{
    DLog(@"SetUserEmailFunction");
    
    NSString *userEmail = nil;
    MAT_FREGetObjectAsString(argv[0], &userEmail);
    
    [MobileAppTracker setUserEmail:userEmail];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserIdFunction)
{
    DLog(@"SetUserIdFunction");
    
    NSString *userId = nil;
    MAT_FREGetObjectAsString(argv[0], &userId);
    
    [MobileAppTracker setUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserNameFunction)
{
    DLog(@"SetUserNameFunction");
    
    NSString *userName = nil;
    MAT_FREGetObjectAsString(argv[0], &userName);
    
    [MobileAppTracker setUserName:userName];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetFacebookUserIdFunction)
{
    DLog(@"SetFacebookUserIdFunction");
    
    NSString *userId = nil;
    MAT_FREGetObjectAsString(argv[0], &userId);
    
    [MobileAppTracker setFacebookUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetTwitterUserIdFunction)
{
    DLog(@"SetTwitterUserIdFunction");
    
    NSString *userId = nil;
    MAT_FREGetObjectAsString(argv[0], &userId);
    
    [MobileAppTracker setTwitterUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetGoogleUserIdFunction)
{
    DLog(@"SetGoogleUserIdFunction");
    
    NSString *userId = nil;
    MAT_FREGetObjectAsString(argv[0], &userId);
    
    [MobileAppTracker setGoogleUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAppAdTrackingFunction)
{
    DLog(@"SetAppAdTrackingFunction");
    
    uint32_t isOptOut;
    FREGetObjectAsBool(argv[0], &isOptOut);
    BOOL optout = 1 == isOptOut;
    
    [MobileAppTracker setAppAdTracking:optout];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetPackageNameFunction)
{
    DLog(@"SetPackageNameFunction");
    
    NSString *pkgName = nil;
    MAT_FREGetObjectAsString(argv[0], &pkgName);
    
    [MobileAppTracker setPackageName:pkgName];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAgeFunction)
{
    DLog(@"SetAgeFunction");
    
    int32_t age;
    FREGetObjectAsInt32(argv[0], &age);
    
    [MobileAppTracker setAge:age];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetGenderFunction)
{
    DLog(@"SetGenderFunction");
    
    uint32_t gender;
    FREGetObjectAsUint32(argv[0], &gender);
    
    [MobileAppTracker setGender:gender];
    
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
    
    [MobileAppTracker setLatitude:lat longitude:lon altitude:alt];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetTRUSTeIdFunction)
{
    DLog(@"SetTRUSTeIdFunction");
    
    NSString *trusteId = nil;
    MAT_FREGetObjectAsString(argv[0], &trusteId);
    
    [MobileAppTracker setTRUSTeId:trusteId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetExistingUserFunction)
{
    DLog(@"SetExistingUserFunction");
    
    uint32_t isExisting;
    FREGetObjectAsBool(argv[0], &isExisting);
    BOOL existing = 1 == isExisting;
    
    [MobileAppTracker setExistingUser:existing];
    
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
    
    [MobileAppTracker setFacebookEventLogging:enable limitEventAndDataUsage:limit];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetPayingUserFunction)
{
    DLog(@"SetPayingUserFunction");
    
    uint32_t isPaying;
    FREGetObjectAsBool(argv[0], &isPaying);
    BOOL payingUser = 1 == isPaying;
    
    [MobileAppTracker setPayingUser:payingUser];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAppleAdvertisingIdentifierFunction)
{
    DLog(@"SetAppleAdvertisingIdentifierFunction");
    
    NSString *aId = nil;
    MAT_FREGetObjectAsString(argv[0], &aId);
    
    NSUUID *appleAdvId = [[NSUUID alloc] initWithUUIDString:aId];
    
    uint32_t isTrackingEnabled;
    FREGetObjectAsBool(argv[1], &isTrackingEnabled);
    BOOL trackingEnabled = 1 == isTrackingEnabled;
    
    [MobileAppTracker setAppleAdvertisingIdentifier:appleAdvId advertisingTrackingEnabled:trackingEnabled];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetAppleVendorIdentifierFunction)
{
    DLog(@"SetAppleVendorIdentifierFunction");
    
    NSString *vId = nil;
    MAT_FREGetObjectAsString(argv[0], &vId);
    
    NSUUID *appleVendorId = [[NSUUID alloc] initWithUUIDString:vId];
    
    [MobileAppTracker setAppleVendorIdentifier:appleVendorId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetDelegateFunction)
{
    DLog(@"SetDelegateFunction");
    
    uint32_t isUseDelegate;
    FREGetObjectAsBool(argv[0], &isUseDelegate);
    BOOL useDelegate = 1 == isUseDelegate;
    
    MATSDKDelegate *sdkDelegate = nil;
    
    if(useDelegate)
    {
        // when enabled set an object of MATSDKDelegate as the delegate for MobileAppTracker
        sdkDelegate = [[MATSDKDelegate alloc] init];
    }
    [MobileAppTracker setDelegate:sdkDelegate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventAttributeFunction)
{
    DLog(@"SetEventAttributeFunction");
    
    uint32_t attrNum;
    FREGetObjectAsUint32(argv[0], &attrNum);
    
    NSString *attrVal = nil;
    MAT_FREGetObjectAsString(argv[1], &attrVal);
    
    switch (attrNum) {
        case 1:
            [MobileAppTracker setEventAttribute1:attrVal];
            break;
        case 2:
            [MobileAppTracker setEventAttribute2:attrVal];
            break;
        case 3:
            [MobileAppTracker setEventAttribute3:attrVal];
            break;
        case 4:
            [MobileAppTracker setEventAttribute4:attrVal];
            break;
        case 5:
            [MobileAppTracker setEventAttribute5:attrVal];
            break;
        default:
            break;
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventContentTypeFunction)
{
    DLog(@"SetEventContentTypeFunction");
    
    NSString *contType = nil;
    MAT_FREGetObjectAsString(argv[0], &contType);
    
    [MobileAppTracker setEventContentType:contType];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventContentIdFunction)
{
    DLog(@"SetEventContentIdFunction");
    
    NSString *contId = nil;
    MAT_FREGetObjectAsString(argv[0], &contId);
    
    [MobileAppTracker setEventContentId:contId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventDate1Function)
{
    DLog(@"SetEventDate1Function");
    
    NSString *dateString = nil;
    MAT_FREGetObjectAsString(argv[0], &dateString);
    
    NSDate* date = [dateFormatter() dateFromString:dateString];
    
    [MobileAppTracker setEventDate1:date];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventDate2Function)
{
    DLog(@"SetEventDate1Function");
    
    NSString *dateString = nil;
    MAT_FREGetObjectAsString(argv[0], &dateString);
    
    NSDate* date = [dateFormatter() dateFromString:dateString];
    
    [MobileAppTracker setEventDate2:date];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventLevelFunction)
{
    DLog(@"SetEventLevelFunction");
    
    int32_t level;
    FREGetObjectAsInt32(argv[0], &level);
    
    [MobileAppTracker setEventLevel:level];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventQuantityFunction)
{
    DLog(@"SetEventQuantityFunction");
    
    int32_t quantity;
    FREGetObjectAsInt32(argv[0], &quantity);
    
    [MobileAppTracker setEventQuantity:quantity];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventRatingFunction)
{
    DLog(@"SetEventRatingFunction");
    
    double rating;
    FREGetObjectAsDouble(argv[0], &rating);
    
    [MobileAppTracker setEventRating:rating];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetEventSearchStringFunction)
{
    DLog(@"SetEventSearchStringFunction");
    
    NSString *searchString = nil;
    MAT_FREGetObjectAsString(argv[0], &searchString);
    
    [MobileAppTracker setEventSearchString:searchString];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(GetMatIdFunction)
{
    DLog(@"GetMatIdFunction");
    
    NSString *matId = [MobileAppTracker matId];
    
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
    
    NSString *openLogId = [MobileAppTracker openLogId];
    
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
    
    BOOL payingUser = [MobileAppTracker isPayingUser];
    
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

void MATExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    DLog(@"MobileAppTrackingANE.MATExtContextInitializer");
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(initNativeCode,                                NULL, InitNativeCode),
        
        MAP_FUNCTION(startAppToAppTracking,                         NULL, StartAppToAppTrackingFunction),
        
        MAP_FUNCTION(measureSession,                                NULL, MeasureSessionFunction),
        MAP_FUNCTION(measureAction,                                 NULL, MeasureActionFunction),
        MAP_FUNCTION(measureActionWithEventItems,                   NULL, MeasureActionWithEventItemsFunction),
        
        MAP_FUNCTION(setAllowDuplicates,                            NULL, SetAllowDuplicatesFunction),
        MAP_FUNCTION(setCurrencyCode,                               NULL, SetCurrencyCodeFunction),
        MAP_FUNCTION(setDebugMode,                                  NULL, SetDebugModeFunction),
        MAP_FUNCTION(setDelegate,                                   NULL, SetDelegateFunction),
        MAP_FUNCTION(setAppAdTracking,                              NULL, SetAppAdTrackingFunction),
        MAP_FUNCTION(setExistingUser,                               NULL, SetExistingUserFunction),
        MAP_FUNCTION(setFacebookEventLogging,                       NULL, SetFacebookEventLogging),
        MAP_FUNCTION(setJailbroken,                                 NULL, SetJailbrokenFunction),
        MAP_FUNCTION(setPackageName,                                NULL, SetPackageNameFunction),
        MAP_FUNCTION(setRedirectUrl,                                NULL, SetRedirectUrlFunction),
        MAP_FUNCTION(setShouldAutoDetectJailbroken,                 NULL, SetShouldAutoDetectJailbrokenFunction),
        MAP_FUNCTION(setSiteId,                                     NULL, SetSiteIdFunction),
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
        
        MAP_FUNCTION(setEventAttribute,                             NULL, SetEventAttributeFunction),
        
        MAP_FUNCTION(setEventContentType,                           NULL, SetEventContentTypeFunction),
        MAP_FUNCTION(setEventContentId,                             NULL, SetEventContentIdFunction),
        MAP_FUNCTION(setEventDate1,                                 NULL, SetEventDate1Function),
        MAP_FUNCTION(setEventDate2,                                 NULL, SetEventDate2Function),
        MAP_FUNCTION(setEventLevel,                                 NULL, SetEventLevelFunction),
        MAP_FUNCTION(setEventQuantity,                              NULL, SetEventQuantityFunction),
        MAP_FUNCTION(setEventRating,                                NULL, SetEventRatingFunction),
        MAP_FUNCTION(setEventSearchString,                          NULL, SetEventSearchStringFunction),
        
        MAP_FUNCTION(setAppleAdvertisingIdentifier,                 NULL, SetAppleAdvertisingIdentifierFunction),
        MAP_FUNCTION(setAppleVendorIdentifier,                      NULL, SetAppleVendorIdentifierFunction),
        
        MAP_FUNCTION(setShouldAutoGenerateAppleVendorIdentifier,    NULL, SetShouldAutoGenerateAppleVendorIdentifierFunction),
        
        MAP_FUNCTION(getMatId,                                      NULL, GetMatIdFunction),
        MAP_FUNCTION(getOpenLogId,                                  NULL, GetOpenLogIdFunction),
        MAP_FUNCTION(getIsPayingUser,                               NULL, GetIsPayingUserFunction),
        
        MAP_FUNCTION(getReferrer,                                   NULL, GetReferrerFunction),
        MAP_FUNCTION(setGoogleAdvertisingId,                        NULL, SetGoogleAdvertisingIdFunction),
        MAP_FUNCTION(setAndroidId,                                  NULL, SetAndroidIdFunction),
        
        MAP_FUNCTION(checkForDeferredDeeplink,                      NULL, CheckForDeferredDeeplink)
    };
    
    *numFunctionsToSet = sizeof( functions ) / sizeof( FRENamedFunction );
	*functionsToSet = functions;
    
    matFREContext = ctx;
}

void MATExtContextFinalizer(FREContext ctx)
{
    DLog(@"MobileAppTrackingANE.MATExtContextFinalizer");
    return;
}

void MATExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    DLog(@"MobileAppTrackingANE.MATExtInitializer");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &MATExtContextInitializer;
    *ctxFinalizerToSet = &MATExtContextFinalizer;
}

void MATExtFinalizer(void * extData)
{
    DLog(@"MobileAppTrackingANE.MATExtFinalizer");
    return;
}
