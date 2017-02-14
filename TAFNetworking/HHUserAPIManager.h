//
//  HHUserAPIManager.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/12.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHAPIManager.h"

//typedef enum : NSUInteger {
//    HHUserInfoTaskErrorNotExistUserId = 1001,
//    HHUserInfoTaskError1,
//    HHUserInfoTaskError2
//} HHUserInfoTaskError;
//
//typedef enum : NSUInteger {
//    HHUserFriendListTaskError0,
//    HHUserFriendListTaskError1,
//    HHUserFriendListTaskError2,
//} HHUserFriendListTaskError;

@interface HHUserAPIManager : HHAPIManager

//普通请求
- (NSNumber *)fetchUserInfoWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

//提供给TaskGroup的Task
- (NSURLSessionDataTask *)userInfoTaskWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

//分页请求
- (NSNumber *)refreshUserFriendListWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
- (NSNumber *)loadmoreUserFriendListWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
