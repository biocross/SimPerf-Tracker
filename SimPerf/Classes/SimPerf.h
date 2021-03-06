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

+ (_Nonnull instancetype)shared;

+ (void)beginLoggingWithServerURL: (nonnull NSString *)serverURL;
+ (void)enableFileDump: (BOOL)enabled;
+ (void)finishLogging;

+ (void)start:(nonnull NSString *)name;
+ (void)stop:(nonnull NSString *)name;
+ (void)saveMetric:(nonnull NSDictionary *)metric;


@property NSMutableArray * _Nonnull output;

@end
