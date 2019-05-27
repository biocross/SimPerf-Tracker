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
@property BOOL fileDumpEnabled;
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
    _sharedInstance.fileDumpEnabled = NO;
  });

  return _sharedInstance;
}

+ (void)beginLoggingWithServerURL: (NSString *)serverURL {
  [[Simperf shared] setServerURL:serverURL];
  [[Simperf shared] beginLogging];
}

+ (void)enableFileDump: (BOOL)enabled {
  [[Simperf shared] setFileDumpEnabled:enabled];
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

  if(begin) {
    NSNumber *timeTaken = [NSNumber numberWithDouble:([endDate timeIntervalSinceDate:begin] * 1000)];
    NSNumber *start = [NSNumber numberWithDouble:([begin timeIntervalSince1970] * 1000)];

    [self.output addObject:@[name, start, timeTaken]];
    [self.watches removeObjectForKey:name];
  }
}

- (void)finishLogging {
  NSDictionary *launchData = @{@"startTime": [NSNumber numberWithDouble:([startTime timeIntervalSince1970] * 1000)],
                                      @"device": @{@"name": [SDVersion deviceNameString]},
                                      @"details": self.output,
                                      @"carrier": [CarrierInfo getCarrierInformation],
                                      @"finished": @YES
                                      };

  NSData *data = [NSJSONSerialization dataWithJSONObject:launchData options:NSJSONWritingPrettyPrinted error:nil];\

  if(_fileDumpEnabled) {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (paths.count > 0) {
      NSURL *documentsDirectory = paths[0];
      NSURL *fileName = [documentsDirectory URLByAppendingPathComponent: [NSString stringWithFormat:@"%f.json", [[NSDate date] timeIntervalSince1970]]];\
      [jsonString writeToURL:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
  }

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serverURL]];
  [request setHTTPMethod:@"POST"];
  request.HTTPBody = data;
  request.allHTTPHeaderFields = @{ @"Content-Type": @"application/json" };
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if(!error) {
      NSLog(@"Stats sent to SimPerf Dashboard!");
    }
  }];
  [task resume];
}

@end
