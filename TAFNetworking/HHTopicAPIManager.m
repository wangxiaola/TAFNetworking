//
//  HHTopicAPIManager.m
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/12.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHTopicAPIManager.h"

@interface HHTopicAPIManager ()

@property (strong, nonatomic) HHNetworkAPIRecorder *topicListAPIRecorder;

@end

@implementation HHTopicAPIManager

//TODO: 普通请求
- (NSNumber *)fetchUserInfoWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.urlPath = @"fetchUserInfoWithUserIdPath";
    
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    //    [requestParameters setValue:@"xxxxx" forKey:@"loginUser"];
    //    [requestParameters setValue:@"iphone" forKey:@"platform"];
    //    [requestParameters setValue:@"idfa" forKey:@"idfa"];
    //    [requestParameters setValue:@(userId) forKey:@"userId"];
    //    NSMutableString *md5Sign = [NSMutableString stringWithFormat:@"api_user=%@&from=%@&idfa=%@&user_id=%@", @"loginUser", @"platform", @"idfa", @"userId"];
    //    NSString *md5String = [HHTool md5WithString:[NSString stringWithFormat:@"%@%@%@", HHPrivateKey, md5Sign, HHPrivateKey]];
    //    [requestParameters setValue:md5String forKey:@"sign"];
    config.requestParameters = requestParameters;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
            switch ([result[@"code"] integerValue]) {
                case 200: {
                    //                    请求数据无误做相应解析
                    //                    result = [HHUser objectWithKeyValues:result[@"data"]];
                }   break;
                    
                case 301: {
                    error = HHError(@"用户不存在", HHUserInfoTaskErrorNotExistUserId);
                }   break;
                    
                case 302: {
                    error = HHError(@"xxx错误", HHUserInfoTaskError1);
                }   break;
                    
                case 303: {
                    error = HHError(@"yyy错误", HHUserInfoTaskError2);
                }   break;
                default:break;
            }
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

//TODO: 给Group用的Task
- (NSURLSessionDataTask *)topicListDataTaskWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypeGet;
    config.urlPath = @"https://api.weibo.com/2/statuses/home_timeline.json";
    config.requestParameters = @{@"access_token" : @"2.00mlsQHD08Vxev84c8927433iLwvpC",
                                 @"page" : @(page),
                                 @"pageSize" : @(pageSize)};
    return [super dataTaskWithConfiguration:config completionHandler:completionHandler];
}

//TODO: 分页请求
- (NSNumber *)refreshTopicListWithCompletionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    [self.topicListAPIRecorder reset];
    return [self fetchTopicListCompletionHandler:completionHandler];
}

- (NSNumber *)loadmoreTopicListWithCompletionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    self.topicListAPIRecorder.currentPage++;
    return [self fetchTopicListCompletionHandler:completionHandler];
}

- (NSNumber *)fetchTopicListCompletionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypeGet;
    config.urlPath = @"https://api.weibo.com/2/statuses/home_timeline.json";
    config.requestParameters = @{@"access_token" : @"2.00mlsQHD08Vxev84c8927433iLwvpC",
                                 @"page" : @(self.topicListAPIRecorder.currentPage),
                                 @"pageSize" : @(self.topicListAPIRecorder.pageSize)};
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
            if ([result[@"statuses"] count] == 0) {
                
                if (self.topicListAPIRecorder.currentPage == 1) {
                    error = HHError(HHNoDataErrorNotice, HHNetworkTaskErrorNoData);
                } else {
                    error = HHError(HHNoMoreDataErrorNotice, HHNetworkTaskErrorNoMoreData);
                }
            } else {
                
                NSMutableArray *names = [NSMutableArray array];
                for (NSDictionary *dic in result[@"statuses"]) {
                    [names addObject:dic[@"user"][@"name"]];
                }
                result = names;
            }
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

#pragma mark - Getter

- (HHNetworkAPIRecorder *)topicListAPIRecorder {
    if (!_topicListAPIRecorder) {
        
        _topicListAPIRecorder = [HHNetworkAPIRecorder new];
        _topicListAPIRecorder.pageSize = 20;
    }
    return _topicListAPIRecorder;
}

@end
