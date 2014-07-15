#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

#import "FlashRuntimeExtensions.h"
#import "IFAANE.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fnVisibleName, data, fnActualName) { (const uint8_t*)(#fnVisibleName), (data), &(fnActualName) }

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#pragma mark - MobileAppTrackerDelegate Methods

static FREContext ifaFREContext;

#pragma mark - AIR iPhone Native Extension Methods

DEFINE_ANE_FUNCTION(GetAppleAdvertisingIdentifier)
{
    // return value for AS3
    FREObject retIFA = nil;
    
    if ([ASIdentifierManager class])
    {
        NSString *ifa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        // Convert Obj-C string to C UTF8String
        const char *strIFA = [ifa UTF8String];
        
        if (strIFA)
        {
            FRENewObjectFromUTF8((uint32_t) strlen(strIFA) + 1, (const uint8_t*)strIFA, &retIFA);
        }
    }
    
    // Return data back to ActionScript
    return retIFA;
}

DEFINE_ANE_FUNCTION(IsAdvertisingTrackingEnabled)
{
    BOOL enabled = NO;
    
    if ([ASIdentifierManager class])
    {
        enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
    
    // return value for AS3
    FREObject retEnabled = nil;
    FRENewObjectFromBool(enabled, &retEnabled);
    
    // Return data back to ActionScript
    return retEnabled;
}

#pragma mark - Extension Context Setup Methods

void IFAExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    DLog(@"IFAANE.IFAExtContextInitializer");
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(getAppleAdvertisingIdentifier,            NULL, GetAppleAdvertisingIdentifier),
        MAP_FUNCTION(isAdvertisingTrackingEnabled,             NULL, IsAdvertisingTrackingEnabled)
    };
    
    *numFunctionsToSet = sizeof( functions ) / sizeof( FRENamedFunction );
	*functionsToSet = functions;
    
    ifaFREContext = ctx;
}

void IFAExtContextFinalizer(FREContext ctx)
{
    DLog(@"IFAANE.IFAExtContextFinalizer");
    return;
}

void IFAExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    DLog(@"IFAANE.IFAExtInitializer");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IFAExtContextInitializer;
    *ctxFinalizerToSet = &IFAExtContextFinalizer;
}

void IFAExtFinalizer(void * extData)
{
    DLog(@"IFAANE.IFAExtFinalizer");
    return;
}
