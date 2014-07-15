#import <UIKit/UIKit.h>

#import "FlashRuntimeExtensions.h"
#import "GAIDANE.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fnVisibleName, data, fnActualName) { (const uint8_t*)(#fnVisibleName), (data), &(fnActualName) }

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#pragma mark - AIR iPhone Native Extension Methods

// NOTE: iOS placeholder corresponding to Android GoogleAdvertisingIdentifier Wrapper

DEFINE_ANE_FUNCTION(GetGoogleAdvertisingId)
{
    const char *strGAID = "";
    
    // Prepare for AS3
    FREObject retGAID = nil;
    FRENewObjectFromUTF8((uint32_t) strlen(strGAID) + 1, (const uint8_t*)strGAID, &retGAID);
    
    // Return data back to ActionScript
    return retGAID;
}

#pragma mark - Extension Context Setup Methods

void GAIDExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    DLog(@"GAIDANE.GAIDExtContextInitializer");
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(getGoogleAdvertisingId,            NULL, GetGoogleAdvertisingId)
    };
    
    *numFunctionsToSet = sizeof( functions ) / sizeof( FRENamedFunction );
	*functionsToSet = functions;
}

void GAIDExtContextFinalizer(FREContext ctx)
{
    DLog(@"GAIDANE.GAIDExtContextFinalizer");
    return;
}

void GAIDExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    DLog(@"GAIDANE.GAIDExtInitializer");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &GAIDExtContextInitializer;
    *ctxFinalizerToSet = &GAIDExtContextFinalizer;
}

void GAIDExtFinalizer(void * extData)
{
    DLog(@"GAIDANE.GAIDExtFinalizer");
    return;
}
