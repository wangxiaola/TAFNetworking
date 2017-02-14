//
//  HHAPIManager.h
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/6/3.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "HHUploadFile.h"
#import "HHNetworkConfig.h"
#import "HHNetworkTaskError.h"
#import "HHNetworkAPIRecorder.h"

#pragma mark - HHAPIConfiguration

typedef void(^HHNetworkTaskProgressHandler)(CGFloat progress);
typedef void(^HHNetworkTaskCompletionHander)(NSError *error, id result);

@interface HHAPIConfiguration : NSObject

@property (copy, nonatomic) NSString *urlPath;
@property (strong, nonatomic) NSDictionary *requestParameters;

@property (assign, nonatomic) BOOL useHttps;
@property (strong, nonatomic) NSDictionary *requestHeader;
@property (assign, nonatomic) HHNetworkRequestType requestType;
@end

@interface HHDataAPIConfiguration : HHAPIConfiguration

@property (assign, nonatomic) NSTimeInterval cacheValidTimeInterval;

@end

@interface HHUploadAPIConfiguration : HHAPIConfiguration

@property (strong, nonatomic) NSArray<HHUploadFile *> * uploadContents;

@end

#pragma mark - HHAPIManager

@interface HHAPIManager : NSObject

- (void)cancelAllTask;
- (void)cancelTaskWithtaskIdentifier:(NSNumber *)taskIdentifier;
+ (void)cancelTaskWithtaskIdentifier:(NSNumber *)taskIdentifier;
+ (void)cancelTasksWithtaskIdentifiers:(NSArray *)taskIdentifiers;

- (NSURLSessionDataTask *)dataTaskWithConfiguration:(HHDataAPIConfiguration *)config completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
- (NSNumber *)dispatchDataTaskWithConfiguration:(HHDataAPIConfiguration *)config completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
- (NSNumber *)dispatchUploadTaskWithConfiguration:(HHUploadAPIConfiguration *)config progressHandler:(HHNetworkTaskProgressHandler)progressHandler completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
