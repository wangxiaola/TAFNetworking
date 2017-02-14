//
//  HHNetworkTaskGroup.m
//  TGCDSocket
//
//  Created by HeiHuaBaiHua on 2016/6/10.
//  Copyright © 2016年 黑花白花. All rights reserved.
//

#import "HHNetworkTaskGroup.h"

@interface HHNetworkTaskGroup ()

@property (copy, nonatomic) void(^notifHandler)(void);
@property (assign, nonatomic) NSInteger signal;
@property (strong, nonatomic) NSMutableSet *tasks;
@property (strong, nonatomic) dispatch_semaphore_t lock;

@property (strong, nonatomic) id keeper;

@end

@implementation HHNetworkTaskGroup

//- (void)addTaskWithMessgeType:(HHSocketMessageType)type message:(PBGeneratedMessage *)message completionHandler:(HHNetworkCompletionHandler)completionHandler {
//    
//    HHSocketTask *task = [[HHSocketManager sharedManager] taskWithMessgeType:type message:message completionHandler:completionHandler];
//    [self addTask:task];
//}

- (void)addTask:(id<HHNetworkTask>)task {
    
    if ([task respondsToSelector:@selector(cancel)] &&
        [task respondsToSelector:@selector(resume)] &&
        ![self.tasks containsObject:task]) {
        
        [self.tasks addObject:task];
        [(id)task addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)dispatchWithNotifHandler:(void (^)(void))notifHandler {
    
    if (self.tasks.count == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            notifHandler ? notifHandler() : nil;
        });
        return;
    }
    
    self.lock = dispatch_semaphore_create(1);
    self.keeper = self;
    self.signal = self.tasks.count;
    self.notifHandler = notifHandler;
    for (id<HHNetworkTask> task in self.tasks.allObjects) {
        [task resume];
    }
}

- (void)cancel {
    
    for (id<HHNetworkTask> task in self.tasks.allObjects) {
        
        if ([(id)task state] < NSURLSessionTaskStateCanceling) {
            
            [(id)task removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
            [task cancel];
        }
    }
    [self.tasks removeAllObjects];
    self.keeper = nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
        
        NSURLSessionTaskState oldState = [change[NSKeyValueChangeOldKey] integerValue];
        NSURLSessionTaskState newState = [change[NSKeyValueChangeNewKey] integerValue];
        if (oldState != newState && newState >= NSURLSessionTaskStateCanceling) {
            [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
            
            dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
            self.signal--;
            dispatch_semaphore_signal(self.lock);

            if (self.signal == 0) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    self.notifHandler ? self.notifHandler() : nil;
                    [self.tasks removeAllObjects];
                    self.keeper = nil;
                });
            }
        }
    }
}

#pragma mark - Getter

- (NSMutableSet *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableSet set];
    }
    return _tasks;
}

@end
