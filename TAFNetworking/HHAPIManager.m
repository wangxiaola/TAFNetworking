//
//  HHAPIManager.m
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/6/3.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "HHAPIManager.h"
#import "HHNetworkClient.h"
#import "HHNetworkCacheManager.h"

#pragma mark - HHAPIConfiguration

@implementation HHAPIConfiguration

- (instancetype)init {
    if (self = [super init]) {
        
        self.useHttps = YES;
        self.requestType = HHNetworkRequestTypePost;
    }
    return self;
}

@end

@implementation HHDataAPIConfiguration
@end

@implementation HHUploadAPIConfiguration
@end

#pragma mark - HHAPIManager

@interface HHAPIManager ()

@property (strong, nonatomic) NSMutableArray<NSNumber *> *loadingTaskIdentifies;

@end

@implementation HHAPIManager
- (instancetype)init {
    if (self = [super init]) {
        
        self.loadingTaskIdentifies = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self cancelAllTask];
}

#pragma mark - Interface

- (void)cancelAllTask {
    
    for (NSNumber *taskIdentifier in self.loadingTaskIdentifies) {
        [[HHNetworkClient sharedInstance] cancelTaskWithTaskIdentifier:taskIdentifier];
    }
    [self.loadingTaskIdentifies removeAllObjects];
}

- (void)cancelTaskWithtaskIdentifier:(NSNumber *)taskIdentifier {
    
    [[HHNetworkClient sharedInstance] cancelTaskWithTaskIdentifier:taskIdentifier];
    [self.loadingTaskIdentifies removeObject:taskIdentifier];
}

+ (void)cancelTaskWithtaskIdentifier:(NSNumber *)taskIdentifier {
    [[HHNetworkClient sharedInstance] cancelTaskWithTaskIdentifier:taskIdentifier];
}

+ (void)cancelTasksWithtaskIdentifiers:(NSArray *)taskIdentifiers {
    for (NSNumber *taskIdentifier in taskIdentifiers) {
        [[HHNetworkClient sharedInstance] cancelTaskWithTaskIdentifier:taskIdentifier];
    }
}

- (NSURLSessionDataTask *)dataTaskWithConfiguration:(HHDataAPIConfiguration *)config completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    return [[HHNetworkClient sharedInstance] dataTaskWithUrlPath:config.urlPath useHttps:config.useHttps requestType:config.requestType params:config.requestParameters header:config.requestHeader completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        completionHandler ? completionHandler([self formatError:error], responseObject) : nil;
    }];
}

- (NSNumber *)dispatchDataTaskWithConfiguration:(HHDataAPIConfiguration *)config completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
        
    NSString *cacheKey;
    if (config.cacheValidTimeInterval > 0) {
        
        NSMutableString *mString = [NSMutableString stringWithString:config.urlPath];
        [config.requestParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [mString appendFormat:@"&%@=%@",key, obj];
        }];
        cacheKey = [self md5WithString:[mString copy]];
        HHNetworkCache *cache = [HHCacheManager objcetForKey:cacheKey];
        if (!cache.isValid) {
            [HHCacheManager removeObejectForKey:cacheKey];
        } else {
            
            completionHandler ? completionHandler(nil, cache.data) : nil;
            return @-1;
        }
    }
    
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@-1];
    taskIdentifier[0] = [[HHNetworkClient sharedInstance] dispatchTaskWithUrlPath:config.urlPath useHttps:config.useHttps requestType:config.requestType params:config.requestParameters header:config.requestHeader completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error && config.cacheValidTimeInterval > 0) {
            
            HHNetworkCache *cache = [HHNetworkCache cacheWithData:responseObject validTimeInterval:config.cacheValidTimeInterval];
            [HHCacheManager setObjcet:cache forKey:cacheKey];
        }
        
        [self.loadingTaskIdentifies removeObject:taskIdentifier.firstObject];
        completionHandler ? completionHandler([self formatError:error], responseObject) : nil;
    }];
    [self.loadingTaskIdentifies addObject:taskIdentifier.firstObject];
    return taskIdentifier.firstObject;
}

- (NSNumber *)dispatchUploadTaskWithConfiguration:(HHUploadAPIConfiguration *)config progressHandler:(HHNetworkTaskProgressHandler)progressHandler completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@-1];
    taskIdentifier[0] = [[HHNetworkClient sharedInstance] uploadDataWithUrlPath:config.urlPath useHttps:config.useHttps params:config.requestParameters contents:config.uploadContents header:config.requestHeader progressHandler:^(NSProgress *progress) {
        
        progressHandler ? progressHandler(progress.completedUnitCount * 1.0 / progress.totalUnitCount) : nil;
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        [self.loadingTaskIdentifies removeObject:taskIdentifier.firstObject];
        completionHandler ? completionHandler([self formatError:error], responseObject) : nil;
    }];
    [self.loadingTaskIdentifies addObject:taskIdentifier.firstObject];
    return taskIdentifier.firstObject;
}

#pragma mark - Utils

- (NSError *)formatError:(NSError *)error {
    
    if (error != nil) {
        switch (error.code) {
            case NSURLErrorCancelled: {
                error = HHError(HHDefaultErrorNotice, HHNetworkTaskErrorCanceled);
            }   break;
                
            case NSURLErrorTimedOut: {
                error = HHError(HHTimeoutErrorNotice, HHNetworkTaskErrorTimeOut);
            }
                
            case NSURLErrorCannotFindHost:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNotConnectedToInternet:{
                error = HHError(HHNetworkErrorNotice, HHNetworkTaskErrorCannotConnectedToInternet);
            }
            default: {
                error = HHError(HHNoDataErrorNotice, HHNetworkTaskErrorDefault);
            }   break;
        }
    }
    return error;
}

- (NSString *)md5WithString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //    CC_MD5( cStr, strlen(cStr), result );
    return [[[NSString alloc] initWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
