//
//  HHNetworkClient.m
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/5/31.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import "HHAppContext.h"
#import "HHNetworkClient.h"
#import "HHURLRequestGenerator.h"

#import "AFNetworking.h"

@interface HHNetworkClient ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSURLSessionTask *> *dispathTable;

@property (assign, nonatomic) CGFloat totalTaskCount;
@property (assign, nonatomic) CGFloat errorTaskCount;
@end

@implementation HHNetworkClient

static dispatch_semaphore_t lock;
+ (instancetype)sharedInstance {
    
    static HHNetworkClient *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lock = dispatch_semaphore_create(1);
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.dispathTable = [NSMutableDictionary dictionary];
        self.totalTaskCount = self.errorTaskCount = 0;
        
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.securityPolicy.validatesDomainName = NO;
        self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:self.sessionManager.responseSerializer.acceptableContentTypes];
        [acceptableContentTypes addObject:@"text/html"];
        [acceptableContentTypes addObject:@"text/plain"];
        self.sessionManager.responseSerializer.acceptableContentTypes = [acceptableContentTypes copy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedSwitchSeriveNotification:) name:HHSwitchServiceNotification object:nil];
    }
    return self;
}

#pragma mark - Interface

- (NSURLSessionDataTask *)dataTaskWithUrlPath:(NSString *)urlPath useHttps:(BOOL)useHttps requestType:(HHNetworkRequestType)requestType params:(NSDictionary *)params header:(NSDictionary *)header completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler {
    
    NSString *method = (requestType == HHNetworkRequestTypeGet ? @"GET" : @"POST");
    NSMutableURLRequest *request = [[HHURLRequestGenerator sharedInstance] generateRequestWithUrlPath:urlPath useHttps:useHttps method:method params:params header:header];
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@-1];
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [self checkSeriveWithTaskError:error];
        [self.dispathTable removeObjectForKey:taskIdentifier.firstObject];
        dispatch_semaphore_signal(lock);
        
        completionHandler ? completionHandler(response, responseObject, error) : nil;
    }];
    taskIdentifier[0] = @(task.taskIdentifier);
    return task;
}

- (NSNumber *)dispatchTaskWithUrlPath:(NSString *)urlPath useHttps:(BOOL)useHttps requestType:(HHNetworkRequestType)requestType params:(NSDictionary *)params header:(NSDictionary *)header completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler {
    
    return [self dispatchTask:[self dataTaskWithUrlPath:urlPath useHttps:useHttps requestType:requestType params:params header:header completionHandler:completionHandler]];
}

- (NSNumber *)dispatchTask:(NSURLSessionDataTask *)task {
    
    if (task == nil) { return @-1; }
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    self.totalTaskCount += 1;
    [self.dispathTable setObject:task forKey:@(task.taskIdentifier)];
    dispatch_semaphore_signal(lock);
    [task resume];
    return @(task.taskIdentifier);
}

- (NSNumber *)uploadDataWithUrlPath:(NSString *)urlPath useHttps:(BOOL)useHttps params:(NSDictionary *)params contents:(NSArray<HHUploadFile *> *)contents header:(NSDictionary *)header progressHandler:(void (^)(NSProgress *))progressHandler completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler {
    
    NSMutableURLRequest *request = [[HHURLRequestGenerator sharedInstance] generateUploadRequestUrlPath:urlPath useHttps:useHttps params:params contents:contents header:header];
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@-1];
    NSURLSessionDataTask *task = [self.sessionManager uploadTaskWithStreamedRequest:request progress:progressHandler completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [self.dispathTable removeObjectForKey:taskIdentifier.firstObject];
        dispatch_semaphore_signal(lock);
        
        completionHandler ? completionHandler(response, responseObject, error) : nil;
    }];
    taskIdentifier[0] = @(task.taskIdentifier);
    return [self dispatchTask:task];
}

- (void)cancelAllTask {
    
    for (NSURLSessionTask *task in self.dispathTable.allValues) {
        [task cancel];
    }
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.dispathTable removeAllObjects];
    dispatch_semaphore_signal(lock);
}

- (void)cancelTaskWithTaskIdentifier:(NSNumber *)taskIdentifier {
    
    [self.dispathTable[taskIdentifier] cancel];
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.dispathTable removeObjectForKey:taskIdentifier];
    dispatch_semaphore_signal(lock);
}

#pragma mark - Notification

- (void)didReceivedSwitchSeriveNotification:(NSNotification *)notif {
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    self.totalTaskCount = self.errorTaskCount = 0;
    dispatch_semaphore_signal(lock);
    [[HHURLRequestGenerator sharedInstance] switchToService:[notif.userInfo[@"service"] integerValue]];
}

#pragma mark - Utils

- (void)checkSeriveWithTaskError:(NSError *)error {
    
    if ([HHAppContext sharedInstance].isReachable) {
        switch (error.code) {
                
            case NSURLErrorUnknown:
            case NSURLErrorTimedOut:
            case NSURLErrorCannotConnectToHost: {
                self.errorTaskCount += 1;
            }
            default:break;
        }
        
        if (self.totalTaskCount >= 40 && (self.errorTaskCount / self.totalTaskCount) == 0.1) {
            
            self.totalTaskCount = self.errorTaskCount = 0;
            [[HHURLRequestGenerator sharedInstance] switchService];
        }
    }
}

@end
