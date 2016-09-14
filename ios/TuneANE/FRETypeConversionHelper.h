//
//  FRETypeConversionHelper.h
//  MobileAppTrackerANE
//
//  Copyright (c) 2012 Sebastien Flory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

FREResult Tune_FREGetObjectAsString( FREObject object, NSString** value );

FREResult Tune_FREGetObjectAsArray( FREObject object, NSArray** array );

FREResult Tune_FREGetObjectAsDictionary( FREObject object, NSDictionary** dictionary );

@interface FRETypeConversionHelper : NSObject

@end
