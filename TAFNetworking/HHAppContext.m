//
//  HHAppContext.m
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/5/31.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import "HHAppContext.h"

#import "AFNetworkReachabilityManager.h"
@implementation HHAppContext

+ (instancetype)sharedInstance {
    
    static HHAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

@end
