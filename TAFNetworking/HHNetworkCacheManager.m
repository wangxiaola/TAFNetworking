//
//  HHNetworkCacheManager.m
//  TGCDSocket
//
//  Created by HeiHuaBaiHua on 16/9/8.
//  Copyright © 2016年 黑花白花. All rights reserved.
//

#import "HHNetworkCacheManager.h"

#pragma mark - HHNetworkCache

@interface HHNetworkCache ()

@property (strong, nonatomic) id data;
@property (assign, nonatomic) NSUInteger cacheTime;
@property (assign, nonatomic) NSUInteger validTimeInterval;

@end

#define ValidTimeInterval 60

@implementation HHNetworkCache

+ (instancetype)cacheWithData:(id)data {
    return [self cacheWithData:data validTimeInterval:ValidTimeInterval];
}

+ (instancetype)cacheWithData:(id)data validTimeInterval:(NSUInteger)interterval {
    
    HHNetworkCache *cache = [HHNetworkCache new];
    cache.data = data;
    cache.cacheTime = [[NSDate date] timeIntervalSince1970];
    cache.validTimeInterval = interterval > 0 ? interterval : ValidTimeInterval;
    return cache;
}

- (BOOL)isValid {
    
    if (self.data) {
        return [[NSDate date] timeIntervalSince1970] - self.cacheTime < self.validTimeInterval;
    }
    return NO;
}

@end

#pragma mark - HHNetworkCacheManager

@interface HHNetworkCacheManager ()

@property (strong, nonatomic) NSCache *cache;

@end

@implementation HHNetworkCacheManager

+ (instancetype)sharedManager {
    static HHNetworkCacheManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[super allocWithZone:NULL] init];
        [sharedManager configuration];
    });
    return sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

- (void)configuration {
    
    self.cache = [NSCache new];
    self.cache.totalCostLimit = 1024 * 1024 * 20;
}

#pragma mark - Interface

- (void)setObjcet:(HHNetworkCache *)object forKey:(id)key {
    [self.cache setObject:object forKey:key];
}

- (void)removeObejectForKey:(id)key {
    [self.cache removeObjectForKey:key];
}

- (HHNetworkCache *)objcetForKey:(id)key {
    
    return [self.cache objectForKey:key];
}

@end
