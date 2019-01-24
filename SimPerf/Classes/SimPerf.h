//
//  Simperf.h
//  SimPerf
//
//  Created by Siddharth Gupta on 24/01/19.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>

@interface Simperf : NSObject

+ (instancetype)shared;

+ (void)beginLoggingWithServerURL: (nonnull NSString *)serverURL;
+ (void)start:(nonnull NSString *)name;
+ (void)stop:(nonnull NSString *)name;
+ (void)finishLogging;

@property NSMutableArray *output;

@end
