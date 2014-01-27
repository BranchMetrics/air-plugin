//
//  FRETypeConversionHelper.m
//  MobileAppTrackerANE
//
//  Copyright (c) 2012 Sebastien Flory. All rights reserved.
//

#import "FRETypeConversionHelper.h"

FREResult MAT_FREGetObjectAsString( FREObject object, NSString** value )
{
    FREResult result;
    const uint8_t *tempValue = NULL;
    uint32_t length = 0;
    
    result = FREGetObjectAsUTF8(object, &length, &tempValue);
    if( FRE_OK == result )
    {
        *value = [NSString stringWithUTF8String:(char*)tempValue];
    }
    
    return result;
}

@implementation FRETypeConversionHelper

@end