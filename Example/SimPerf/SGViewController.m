//
//  SGViewController.m
//  SimPerf
//
//  Created by biocross on 01/24/2019.
//  Copyright (c) 2019 biocross. All rights reserved.
//

#import "SGViewController.h"

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [Simperf beginLoggingWithServerURL:@"http://localhost:3000/methods/addLaunchData"];
  [Simperf enableFileDump:YES];
  [Simperf start:@"AppStart"];
  [Simperf saveMetric:@{@"sample": @"metric"}];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [Simperf stop:@"AppStart"];
    [Simperf finishLogging];
  });
}

@end
