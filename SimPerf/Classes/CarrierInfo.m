//
//  CarrierInfo.m
//  SimPerf
//
//  Created by Siddharth Gupta on 27/5/19.
//

#import "CarrierInfo.h"

@implementation CarrierInfo

+ (NSDictionary *) getCarrierInformation {
  CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
  CTCarrier *carrier = info.subscriberCellularProvider;
  NSString *radioType = info.currentRadioAccessTechnology;
  if (carrier && carrier.carrierName) {
    if(radioType) {
      radioType = [radioType stringByReplacingOccurrencesOfString:@"CTRadioAccessTechnology" withString:@""];
      return @{
               @"carrierName": carrier.carrierName,
               @"generation": radioType
               };
    }
    return @{ @"carrierName": carrier.carrierName };
  }
  return @{};
}

@end
