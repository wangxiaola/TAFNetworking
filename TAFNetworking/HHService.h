//
//  HHService.h
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/6/2.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HHNetworkConfig.h"
@protocol HHService <NSObject>

@optional
- (NSString *)testEnvironmentBaseUrl;
- (NSString *)developEnvironmentBaseUrl;
- (NSString *)releaseEnvironmentBaseUrl;

@end

@interface HHService : NSObject<HHService>

+ (HHService *)currentService;

+ (void)switchService;
+ (void)switchToService:(HHServiceType)serviceType;

- (NSString *)baseUrl;
- (HHServiceEnvironment)environment;
@end
