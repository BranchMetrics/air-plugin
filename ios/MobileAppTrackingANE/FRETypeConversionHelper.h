//
//  FRETypeConversionHelper.h
//  MobileAppTrackerANE
//
//  Copyright (c) 2012 Sebastien Flory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "TuneAdMetadata.h"

FREResult Tune_FREGetObjectAsString( FREObject object, NSString** value );

FREResult Tune_FREGetObjectAsArray( FREObject object, NSArray** array );

FREResult Tune_FREGetObjectAsDictionary( FREObject object, NSDictionary** dictionary );

FREResult Tune_FREGetObjectAsTuneAdMetadata( FREObject object, TuneAdMetadata** metadata );

@interface FRETypeConversionHelper : NSObject

@end
