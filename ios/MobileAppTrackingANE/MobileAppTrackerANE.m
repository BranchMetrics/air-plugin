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
    
    NSString *strError = [NSString stringWithFormat:@"{\"code\":\"%d\",\"localizedDescription\":\"%@\",\"failedURL\":\"%@\"}", errorCode, errorDescr, errorURLString];
    
    const char *level = [strError UTF8String];
    
    FREDispatchStatusEventAsync(matFREContext, (const uint8_t *)code, (const uint8_t *)level);
}

@end

#pragma mark - AIR iPhone Native Extension Methods

DEFINE_ANE_FUNCTION(initNativeCode)
{
    DLog(@"initNativeCode start");
    
    NSString *advId = nil;
    MAT_FREGetObjectAsString(argv[0], &advId);
    
    NSString *conversionKey = nil;
    MAT_FREGetObjectAsString(argv[1], &conversionKey);
    
    [MobileAppTracker startTrackerWithMATAdvertiserId:advId
                                     MATConversionKey:conversionKey];
    [MobileAppTracker setPluginName:@"air"];
    
    DLog(@"initNativeCode end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackSessionFunction)
{
    DLog(@"TrackSessionFunction start");
    
    NSString *refId = nil;
    FREResult result =
    MAT_FREGetObjectAsString(argv[0], &refId);
    
    DLog(@"result = %d, refId = %@", result, refId);
    
    [MobileAppTracker trackSessionWithReferenceId:refId];
    
    DLog(@"TrackSessionFunction end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackActionWithEventItemFunction)
{
    DLog(@"TrackActionWithEventItemFunction start");
    
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
    
    [MobileAppTracker trackActionForEventIdOrName:event
                                       eventItems:eventItems
                                      referenceId:refId
                                    revenueAmount:revenue
                                     currencyCode:currencyCode
                                 transactionState:transactionState
                                          receipt:receipt];
    
    DLog(@"TrackPurchaseActionFunction end");
    
    return NULL;
}

DEFINE_ANE_FUNCTION(TrackActionFunction)
{
    DLog(@"TrackActionFunction");
    
    NSString *event = nil;
    MAT_FREGetObjectAsString(argv[0], &event);
    
    double revenue;
    FREGetObjectAsDouble(argv[1], &revenue);
    
    NSString* currencyCode = nil;
    MAT_FREGetObjectAsString(argv[2], &currencyCode);
    
    NSString *refId = nil;
    MAT_FREGetObjectAsString(argv[3], &refId);
    
    [MobileAppTracker trackActionForEventIdOrName:event
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
    
    [MobileAppTracker setTracking:targetAppId advertiserId:advertiserId offerId:offerId publisherId:publisherId redirect:shouldRedirect];
    
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
    //FREResult result =
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
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &redirectUrl);
    
    [MobileAppTracker setRedirectUrl:redirectUrl];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetCurrencyCodeFunction)
{
    DLog(@"SetCurrencyCodeFunction");
    
    NSString *currencyCode = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &currencyCode);
    
    [MobileAppTracker setCurrencyCode:currencyCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserEmailFunction)
{
    DLog(@"SetUserEmailFunction");
    
    NSString *userEmail = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &userEmail);
    
    [MobileAppTracker setUserEmail:userEmail];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserIdFunction)
{
    DLog(@"SetUserIdFunction");
    
    NSString *userId = nil;
    //FREResult result =
    MAT_FREGetObjectAsString(argv[0], &userId);
    
    [MobileAppTracker setUserId:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetUserNameFunction)
{
    DLog(@"SetUserNameFunction");
    
    NSString *userName = nil;
    //FREResult result =
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
    //FREResult result =
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
    FREGetObjectAsDouble(argv[0], &lon);
    
    double_t alt;
    FREGetObjectAsDouble(argv[0], &alt);
    
    [MobileAppTracker setLatitude:lat longitude:lon altitude:alt];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(SetTRUSTeIdFunction)
{
    DLog(@"SetTRUSTeIdFunction");
    
    NSString *trusteId = nil;
    //FREResult result =
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

DEFINE_ANE_FUNCTION(SetAppleAdvertisingIdentifierFunction)
{
    DLog(@"SetAppleAdvertisingIdentifierFunction");
    
    NSString *aId = nil;
    //FREResult result =
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
    //FREResult result =
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
    //FREResult result =
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

#pragma mark - Extension Context Setup Methods

void MATExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    DLog(@"MATExtContextInitializer");
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(initNativeCode,                            NULL, initNativeCode),
        
        MAP_FUNCTION(startAppToAppTracking,                     NULL, StartAppToAppTrackingFunction),
        
        MAP_FUNCTION(trackSession,                              NULL, TrackSessionFunction),
        MAP_FUNCTION(trackAction,                               NULL, TrackActionFunction),
        MAP_FUNCTION(trackActionWithEventItem,                  NULL, TrackActionWithEventItemFunction),
        
        MAP_FUNCTION(setAllowDuplicates,                        NULL, SetAllowDuplicatesFunction),
        MAP_FUNCTION(setCurrencyCode,                           NULL, SetCurrencyCodeFunction),
        MAP_FUNCTION(setDebugMode,                              NULL, SetDebugModeFunction),
        MAP_FUNCTION(setDelegate,                               NULL, SetDelegateFunction),
        MAP_FUNCTION(setAppAdTracking,                          NULL, SetAppAdTrackingFunction),
        MAP_FUNCTION(setExistingUser,                           NULL, SetExistingUserFunction),
        MAP_FUNCTION(setJailbroken,                             NULL, SetJailbrokenFunction),
        MAP_FUNCTION(setPackageName,                            NULL, SetPackageNameFunction),
        MAP_FUNCTION(setRedirectUrl,                            NULL, SetRedirectUrlFunction),
        MAP_FUNCTION(setShouldAutoDetectJailbroken,             NULL, SetShouldAutoDetectJailbrokenFunction),
        MAP_FUNCTION(setSiteId,                                 NULL, SetSiteIdFunction),
        MAP_FUNCTION(setTRUSTeId,                               NULL, SetTRUSTeIdFunction),
        MAP_FUNCTION(setUseCookieTracking,                      NULL, SetUseCookieTrackingFunction),
        MAP_FUNCTION(setUserEmail,                              NULL, SetUserEmailFunction),
        MAP_FUNCTION(setUserId,                                 NULL, SetUserIdFunction),
        MAP_FUNCTION(setUserName,                               NULL, SetUserNameFunction),
        MAP_FUNCTION(setFacebookUserId,                         NULL, SetFacebookUserIdFunction),
        MAP_FUNCTION(setTwitterUserId,                          NULL, SetTwitterUserIdFunction),
        MAP_FUNCTION(setGoogleUserId,                           NULL, SetGoogleUserIdFunction),
        
        MAP_FUNCTION(setAge,                                    NULL, SetAgeFunction),
        MAP_FUNCTION(setGender,                                 NULL, SetGenderFunction),
        MAP_FUNCTION(setLocation,                               NULL, SetLocationFunction),
        
        MAP_FUNCTION(setEventAttribute,                             NULL, SetEventAttributeFunction),
        
        MAP_FUNCTION(setAppleAdvertisingIdentifier,                 NULL, SetAppleAdvertisingIdentifierFunction),
        MAP_FUNCTION(setAppleVendorIdentifier,                      NULL, SetAppleVendorIdentifierFunction),
        
        MAP_FUNCTION(setShouldAutoGenerateAppleVendorIdentifier,    NULL, SetShouldAutoGenerateAppleVendorIdentifierFunction),
        
        MAP_FUNCTION(getReferrer,                                   NULL, GetReferrerFunction),
        MAP_FUNCTION(setGoogleAdvertisingId,                        NULL, SetGoogleAdvertisingIdFunction)
    };
    
    *numFunctionsToSet = sizeof( functions ) / sizeof( FRENamedFunction );
	*functionsToSet = functions;
    
    matFREContext = ctx;
}

void MATExtContextFinalizer(FREContext ctx)
{
    DLog(@"MATExtContextFinalizer");
    return;
}

void ExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    DLog(@"MobileAppTrackingANE.ExtInitializer");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &MATExtContextInitializer;
    *ctxFinalizerToSet = &MATExtContextFinalizer;
}

void ExtFinalizer(void * extData)
{
    DLog(@"MobileAppTrackingANE.ExtFinalizer");
    return;
}
