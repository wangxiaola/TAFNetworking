//
//  HHService.m
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/6/2.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import "HHService.h"

@interface HHService ()

@property (assign, nonatomic) HHServiceType type;
@property (assign, nonatomic) HHServiceEnvironment environment;

@end

@interface HHServiceX : HHService
@end

@interface HHServiceY : HHService
@end

@interface HHServiceZ : HHService
@end

@implementation HHService

#pragma mark - Interface

static HHService *currentService;
static dispatch_semaphore_t lock;
+ (HHService *)currentService {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lock = dispatch_semaphore_create(1);
        currentService = [HHService serviceWithType:HHService0];
    });
    
    return currentService;
}

+ (void)switchService {
    [self switchToService:self.currentService.type + 1];
}

+ (void)switchToService:(HHServiceType)serviceType {
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    currentService = [HHService serviceWithType:(serviceType % HHServiceCount)];
    dispatch_semaphore_signal(lock);
}

+ (HHService *)serviceWithType:(HHServiceType)type {
    
    HHService *service;
    switch (type) {
        case HHService0: service = [HHServiceX new];  break;
        case HHService1: service = [HHServiceY new];  break;
        case HHService2: service = [HHServiceZ new];  break;
    }
    service.type = type;
    service.environment = HHBulidServiceEnvironment;
    return service;
}

- (NSString *)baseUrl {
    
    switch (self.environment) {
        case HHServiceEnvironmentTest: return [self testEnvironmentBaseUrl];
        case HHServiceEnvironmentDevelop: return [self developEnvironmentBaseUrl];
        case HHServiceEnvironmentRelease: return [self releaseEnvironmentBaseUrl];
    }
}

@end

#pragma mark - HHServiceX

@implementation HHServiceX

- (NSString *)testEnvironmentBaseUrl {
    return @"http://api.1shuo.com/";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"http://api.1shuo.com/";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"http://api.1shuo.com/";
}

@end

#pragma mark - HHServiceY

@implementation HHServiceY

- (NSString *)testEnvironmentBaseUrl {
    return @"testEnvironmentBaseUrl_Y";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"developEnvironmentBaseUrl_Y";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"releaseEnvironmentBaseUrl_Y";
}

@end

#pragma mark - HHServiceZ

@implementation HHServiceZ

- (NSString *)testEnvironmentBaseUrl {
    return @"testEnvironmentBaseUrl_Z";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"developEnvironmentBaseUrl_Z";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"releaseEnvironmentBaseUrl_Z";
}

@end
