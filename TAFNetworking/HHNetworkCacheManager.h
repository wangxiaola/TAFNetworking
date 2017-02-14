//
//  HHNetworkCacheManager.h
//  TGCDSocket
//
//  Created by HeiHuaBaiHua on 16/9/8.
//  Copyright © 2016年 黑花白花. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HHCacheManager [HHNetworkCacheManager sharedManager]

@interface HHNetworkCache : NSObject

+ (instancetype)cacheWithData:(id)data;
+ (instancetype)cacheWithData:(id)data validTimeInterval:(NSUInteger)interterval;

- (id)data;
- (BOOL)isValid;

@end

@interface HHNetworkCacheManager : NSObject

+ (instancetype)sharedManager;

- (void)removeObejectForKey:(id)key;
- (void)setObjcet:(HHNetworkCache *)object forKey:(id)key;
- (HHNetworkCache *)objcetForKey:(id)key;

@end
