//
//  FRETypeConversionHelper.m
//  MobileAppTrackerANE
//
//  Copyright (c) 2012 Sebastien Flory. All rights reserved.
//

#import "FRETypeConversionHelper.h"
#import "TuneANE.m"

FREResult Tune_FREGetObjectAsString( FREObject object, NSString** value )
{
    FREResult result;
    const uint8_t *tempValue = NULL;
    uint32_t length = 0;
    
    result = FREGetObjectAsUTF8(object, &length, &tempValue);
    if( FRE_OK == result )
    {
        NSString *strValue = [NSString stringWithUTF8String:(char*)tempValue];
        if (![strValue isEqualToString:@"undefined"]) {
            *value = [NSString stringWithUTF8String:(char*)tempValue];
        } else {
            NSLog(@"Conversion got string undefined");
        }
    } else {
        NSLog(@"FREGetObjectAsUTF8 conversion failed in Tune_FREGetObjectAsString");
    }
    
    return result;
}

FREResult Tune_FREGetObjectAsArray( FREObject object, NSArray** array )
{
    uint32_t arrayLength;
    FREGetArrayLength(object, &arrayLength);
    
    uint32_t stringLength;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:arrayLength];
    for (uint32_t i = 0; i < arrayLength; i++)
    {
        FREObject asItem;
        FREGetArrayElementAt(object, i, &asItem);
        
        // Convert item to string. Skip with warning if not possible.
        const uint8_t *itemString;
        if (FREGetObjectAsUTF8(asItem, &stringLength, &itemString) != FRE_OK)
        {
            NSLog(@"Couldn't convert FREObject to NSString at index %u", i);
            continue;
        }
        
        NSString *item = [NSString stringWithUTF8String:(char*)itemString];
        [mutableArray addObject:item];
    }
    
    *array = [NSArray arrayWithArray:mutableArray];
    return FRE_OK;
}

FREResult Tune_FREGetObjectAsDictionary( FREObject object, NSDictionary** dictionary )
{
    uint32_t numCustomTargets;
    FREGetArrayLength(object, &numCustomTargets);
    NSMutableDictionary *customTargets = [NSMutableDictionary dictionaryWithCapacity:numCustomTargets/2];
    
    // Iterate through keys and add key-value pairs to dictionary
    for (uint32_t i = 0; i < numCustomTargets; i+=2)
    {
        FREObject asKey, asValue;
        FREGetArrayElementAt(object, i, &asKey);
        FREGetArrayElementAt(object, i+1, &asValue);
        
        // Convert key and value to strings. Skip with warning if not possible.
        uint32_t stringLength;
        const uint8_t *keyString, *valueString;
        if (FREGetObjectAsUTF8(asKey, &stringLength, &keyString) != FRE_OK || FREGetObjectAsUTF8(asValue, &stringLength, &valueString) != FRE_OK)
        {
            NSLog(@"Couldn't convert FREObject to NSString at index %u", i);
            continue;
        }
        
        NSString *key = [NSString stringWithUTF8String:(char*)keyString];
        NSString *value = [NSString stringWithUTF8String:(char*)valueString];
        [customTargets setObject:value forKey:key];
    }
    
    *dictionary = [NSDictionary dictionaryWithDictionary:customTargets];
    
    return FRE_OK;
}


@implementation FRETypeConversionHelper

@end
