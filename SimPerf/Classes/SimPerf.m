//
//  Simperf.m
//  SimPerf
//
//  Created by Siddharth Gupta on 24/01/19.
//

#import "SimPerf.h"

#define defaultHost @"http://localhost:3000"
#define defaultDataURL [defaultHost stringByAppendingString:@"/methods/addLaunchData"]

@interface Simperf()
@property NSString *serverURL;
@property NSMutableDictionary *watches;
@end

@implementation Simperf {
    NSDate *startTime;
}

+ (instancetype)shared {
    static Simperf *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [Simperf new];
        _sharedInstance.watches = [NSMutableDictionary new];
        _sharedInstance.output = [NSMutableArray new];
        _sharedInstance.serverURL = defaultDataURL;
    });
    
    return _sharedInstance;
}

+ (void)beginLoggingWithServerURL: (NSString *)serverURL {
    [[Simperf shared] setServerURL:serverURL];
    [[Simperf shared] beginLogging];
}

+ (void)start:(NSString *)name {
    [[Simperf shared] start:name];
}

+ (void)stop:(NSString *)name {
    [[Simperf shared] stop:name];
}

+ (void)finishLogging {
    [[Simperf shared] finishLogging];
}

#pragma mark Internal Simperf Instance

- (void)beginLogging {
    startTime = [NSDate date];
}

- (void)start:(NSString *)name {
    self.watches[name] = [NSDate date];
}

- (void)stop:(NSString *)name {
    NSDate *endDate = [NSDate date];
    NSDate *begin = self.watches[name];
    
    NSNumber *timeTaken = [NSNumber numberWithDouble:([endDate timeIntervalSinceDate:begin] * 1000)];
    NSNumber *start = [NSNumber numberWithDouble:([begin timeIntervalSince1970] * 1000)];
    
    [self.output addObject:@[name, start, timeTaken]];
    [self.watches removeObjectForKey:name];
}

- (void)finishLogging {
    NSDictionary *launchData = @{@"startTime": [NSNumber numberWithDouble:([startTime timeIntervalSince1970] * 1000)],
                                 @"device": @{@"name": @"iPhone"},
                                 @"details": self.output,
                                 @"finished": @YES
                                 };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:launchData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serverURL]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    request.allHTTPHeaderFields = @{ @"Content-Type": @"application/json" };
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            NSLog(@"Stats sent to SimPerf Dashboard!");
        }
    }] resume];
}

@end
