//
//  Simperf.h
//  SimPerf
//
//  Created by Siddharth Gupta on 24/01/19.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>
#import "CarrierInfo.h"
@import SDVersion;

@interface Simperf : NSObject

+ (instancetype)shared;

+ (void)beginLoggingWithServerURL: (nonnull NSString *)serverURL;
+ (void)enableFileDump: (BOOL)enabled;
+ (void)start:(nonnull NSString *)name;
+ (void)stop:(nonnull NSString *)name;
+ (void)finishLogging;

@property NSMutableArray *output;

@end
