//
//  HHNetworkConfig.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/11.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#ifndef HHNetworkConfig_h
#define HHNetworkConfig_h

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHService0,
    HHService1,
    HHService2
} HHServiceType;
static NSUInteger const HHServiceCount = 3;
static NSString *const HHSwitchServiceNotification = @"HHSwitchServiceNotification";

typedef enum : NSUInteger {
    HHServiceEnvironmentTest,
    HHServiceEnvironmentDevelop,
    HHServiceEnvironmentRelease
} HHServiceEnvironment;
static NSUInteger const HHBulidServiceEnvironment = 0;

typedef enum : NSUInteger {
    HHNetworkRequestTypeGet,
    HHNetworkRequestTypePost
} HHNetworkRequestType;

static NSUInteger const HHRequestTimeoutInterval = 8;

#endif
