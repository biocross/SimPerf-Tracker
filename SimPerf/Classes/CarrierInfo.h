//
//  CarrierInfo.h
//  SimPerf
//
//  Created by Siddharth Gupta on 27/5/19.
//

@import CoreTelephony;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarrierInfo : NSObject

+ (NSDictionary *) getCarrierInformation;

@end

NS_ASSUME_NONNULL_END
