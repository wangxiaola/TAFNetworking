//
//  HHUserAPIManager.m
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/12.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHUserAPIManager.h"

@interface HHUserAPIManager ()

@property (strong, nonatomic) HHNetworkAPIRecorder *friendListAPIRcored;

@end

@implementation HHUserAPIManager

//TODO: 普通请求
//- (NSNumber *)fetchUserInfoWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
//    
//    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
//    config.urlPath = @"fetchUserInfoWithUserIdPath";
//    
//    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
////    [requestParameters setValue:@"xxxxx" forKey:@"loginUser"];
////    [requestParameters setValue:@"iphone" forKey:@"platform"];
////    [requestParameters setValue:@"idfa" forKey:@"idfa"];
////    [requestParameters setValue:@(userId) forKey:@"userId"];
////    NSMutableString *md5Sign = [NSMutableString stringWithFormat:@"api_user=%@&from=%@&idfa=%@&user_id=%@", @"loginUser", @"platform", @"idfa", @"userId"];
////    NSString *md5String = [HHTool md5WithString:[NSString stringWithFormat:@"%@%@%@", HHPrivateKey, md5Sign, HHPrivateKey]];
////    [requestParameters setValue:md5String forKey:@"sign"];
//    config.requestParameters = requestParameters;
//    
//    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
//        
//        if (!error) {
//            
//            switch ([result[@"code"] integerValue]) {
//                case 200: {
////                    请求数据无误做相应解析
////                    result = [HHUser objectWithKeyValues:result[@"data"]];
//                }   break;
//                    
//                case 301: {
//                    error = HHError(@"用户不存在", HHUserInfoTaskErrorNotExistUserId);
//                }break;
//                    
//                case 302: {
//                    error = HHError(@"xxx错误", HHUserInfoTaskError1);
//                }   break;
//                    
//                case 303: {
//                    error = HHError(@"yyy错误", HHUserInfoTaskError2);
//                }   break;
//                default:break;
//            }
//        }
//        
//        completionHandler ? completionHandler(error, result) : nil;
//    }];
//}
//
////TODO: 给Group用的Task
//- (NSURLSessionDataTask *)userInfoTaskWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
//    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
//    config.urlPath = @"fetchUserInfoWithUserIdPath";
//    
//    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
//    //    [requestParameters setValue:@"xxxxx" forKey:@"loginUser"];
//    //    [requestParameters setValue:@"iphone" forKey:@"platform"];
//    //    [requestParameters setValue:@"idfa" forKey:@"idfa"];
//    //    [requestParameters setValue:@(userId) forKey:@"userId"];
//    //    NSMutableString *md5Sign = [NSMutableString stringWithFormat:@"api_user=%@&from=%@&idfa=%@&user_id=%@", @"loginUser", @"platform", @"idfa", @"userId"];
//    //    NSString *md5String = [HHTool md5WithString:[NSString stringWithFormat:@"%@%@%@", HHPrivateKey, md5Sign, HHPrivateKey]];
//    //    [requestParameters setValue:md5String forKey:@"sign"];
//    config.requestParameters = requestParameters;
//    
//    return [super dataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
//        
//        if (!error) {
//            
//            switch ([result[@"code"] integerValue]) {
//                case 200: {
//                    //                    请求数据无误做相应解析
//                    //                    result = [HHUser objectWithKeyValues:result[@"data"]];
//                }   break;
//                    
//                case 301: {
//                    error = HHError(@"用户不存在", HHUserInfoTaskErrorNotExistUserId);
//                }break;
//                    
//                case 302: {
//                    error = HHError(@"xxx错误", HHUserInfoTaskError1);
//                }   break;
//                    
//                case 303: {
//                    error = HHError(@"yyy错误", HHUserInfoTaskError2);
//                }   break;
//                default:break;
//            }
//        }
//        
//        completionHandler ? completionHandler(error, result) : nil;
//    }];
//}
//
////TODO: 分页请求
//- (NSNumber *)refreshUserFriendListWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
//    
//    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
//    config.urlPath = @"fetchUserFriendListPath";
//    
//    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
//    //    [requestParameters setValue:@"xxxxx" forKey:@"loginUser"];
//    //    [requestParameters setValue:@"iphone" forKey:@"platform"];
//    //    [requestParameters setValue:@"idfa" forKey:@"idfa"];
//    //    [requestParameters setValue:@(userId) forKey:@"userId"];
//    //    NSMutableString *md5Sign = [NSMutableString stringWithFormat:@"api_user=%@&from=%@&idfa=%@&user_id=%@", @"loginUser", @"platform", @"idfa", @"userId"];
//    //    NSString *md5String = [HHTool md5WithString:[NSString stringWithFormat:@"%@%@%@", HHPrivateKey, md5Sign, HHPrivateKey]];
//    //    [requestParameters setValue:md5String forKey:@"sign"];
//    [requestParameters setObject:@(self.friendListAPIRcored.currentPage) forKey:@"page"];
//    [requestParameters setObject:@(self.friendListAPIRcored.pageSize) forKey:@"pageSize"];
//    config.requestParameters = requestParameters;
//    
//    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
//        
//        if (!error) {
//            
//            switch ([result[@"code"] integerValue]) {
//                case 200: {
//                    //                    请求数据无误做相应解析
////                    NSArray *friends = result = [HHFriend objectArrayWithKeyValues:result[@"data"]];
////                    if (friends.count == 0) {
////                        error = HHError(HHNoDataErrorNotice, HHNetworkTaskErrorNoData);
////                    } else {
////                        result = friends;
////                    }
//                }   break;
//                    
//                case 301: {
//                    error = HHError(@"用户不存在", HHUserInfoTaskErrorNotExistUserId);
//                }   break;
//                    
//                case 302: {
//                    error = HHError(@"xxx错误", HHUserFriendListTaskError0);
//                }   break;
//                    
//                case 303: {
//                    error = HHError(@"yyy错误", HHUserFriendListTaskError1);
//                }   break;
//                default:break;
//            }
//        }
//        
//        completionHandler ? completionHandler(error, result) : nil;
//    }];
//}
//
////TODO: 分页请求
//- (NSNumber *)loadmoreUserFriendListWithUserId:(NSUInteger)userId completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
//    
//    if (!self.friendListAPIRcored.hasMoreData) {
//        
//        NSError *error = HHError(HHNoMoreDataErrorNotice, HHNetworkTaskErrorNoMoreData);
//        completionHandler ? completionHandler(error, nil) : nil;
//        return @-1;
//    } else {
//     
//        HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
//        config.urlPath = @"fetchUserFriendListPath";
//        
//        NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
//        //    [requestParameters setValue:@"xxxxx" forKey:@"loginUser"];
//        //    [requestParameters setValue:@"iphone" forKey:@"platform"];
//        //    [requestParameters setValue:@"idfa" forKey:@"idfa"];
//        //    [requestParameters setValue:@(userId) forKey:@"userId"];
//        //    NSMutableString *md5Sign = [NSMutableString stringWithFormat:@"api_user=%@&from=%@&idfa=%@&user_id=%@", @"loginUser", @"platform", @"idfa", @"userId"];
//        //    NSString *md5String = [HHTool md5WithString:[NSString stringWithFormat:@"%@%@%@", HHPrivateKey, md5Sign, HHPrivateKey]];
//        //    [requestParameters setValue:md5String forKey:@"sign"];
//        self.friendListAPIRcored.currentPage++;
//        [requestParameters setObject:@(self.friendListAPIRcored.currentPage) forKey:@"page"];
//        [requestParameters setObject:@(self.friendListAPIRcored.pageSize) forKey:@"pageSize"];
//        config.requestParameters = requestParameters;
//        
//        return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
//            
////            同上
//            completionHandler ? completionHandler(error, result) : nil;
//        }];
//    }
//}

#pragma mark - Getter

- (HHNetworkAPIRecorder *)friendListAPIRcored {
    if (!_friendListAPIRcored) {
        _friendListAPIRcored = [HHNetworkAPIRecorder new];
    }
    return _friendListAPIRcored;
}

@end
