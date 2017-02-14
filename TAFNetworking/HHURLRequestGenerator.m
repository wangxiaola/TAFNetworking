//
//  HHURLRequestGenerator.m
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/5/31.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//
#import "HHNetworkConfig.h"

#import "HHService.h"
#import "HHURLRequestGenerator.h"
#import "AFURLRequestSerialization.h"

@interface HHURLRequestGenerator ()

@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerialize;

@end

@implementation HHURLRequestGenerator

+ (instancetype)sharedInstance {
    
    static HHURLRequestGenerator *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - Interface

- (void)switchService {
    [HHService switchService];
}

- (void)switchToService:(HHServiceType)serviceType {
    [HHService switchToService:serviceType];
}

- (NSMutableURLRequest *)generateRequestWithUrlPath:(NSString *)urlPath useHttps:(BOOL)useHttps method:(NSString *)method params:(NSDictionary *)params header:(NSDictionary *)header {
    
    NSString *urlString = [self urlStringWithPath:urlPath useHttps:useHttps];
    NSMutableURLRequest *request = [self.requestSerialize requestWithMethod:method URLString:urlString parameters:params error:nil];
    request.timeoutInterval = HHRequestTimeoutInterval;
    [self setCommonRequestHeaderForRequest:request];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

- (NSMutableURLRequest *)generateUploadRequestUrlPath:(NSString *)urlPath useHttps:(BOOL)useHttps params:(NSDictionary *)params contents:(NSArray<HHUploadFile *> *)contents header:(NSDictionary *)header {
    
    NSString *urlString = [self urlStringWithPath:urlPath useHttps:useHttps];
    NSMutableURLRequest *request = [self.requestSerialize multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [contents enumerateObjectsUsingBlock:^(HHUploadFile * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:file.fileData name:file.uploadKey fileName:file.fileName mimeType:file.fileType];
        }];
        
    } error:nil];
    request.timeoutInterval = HHRequestTimeoutInterval * 2;
    [self setCommonRequestHeaderForRequest:request];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

#pragma mark - Utils

- (NSString *)urlStringWithPath:(NSString *)path useHttps:(BOOL)useHttps {
    
    if ([path hasPrefix:@"http"]) {
        return path;
    } else {
        
        NSString *baseUrlString = [HHService currentService].baseUrl;
        if (useHttps && baseUrlString.length > 4) {
            
            NSMutableString *mString = [NSMutableString stringWithString:baseUrlString];
            [mString insertString:@"s" atIndex:4];
            baseUrlString = [mString copy];
        }
        return [NSString stringWithFormat:@"%@%@", baseUrlString, path];
    }
}

- (NSMutableURLRequest *)setCommonRequestHeaderForRequest:(NSMutableURLRequest *)request {
    
//    在这里设置通用的请求头
//    [request setValue:@"xxx" forHTTPHeaderField:@"xxx"];
//    [request setValue:@"yyy" forHTTPHeaderField:@"yyy"];
    return  request;
}

#pragma mark - Getter

- (AFHTTPRequestSerializer *)requestSerialize {
    if (!_requestSerialize) {
        _requestSerialize = [AFHTTPRequestSerializer serializer];
    }
    return _requestSerialize;
}

@end
