//
//  HHNetworkAPIRecorder.h
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/8/25.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultPageSize 10

@interface HHNetworkAPIRecorder : NSObject

@property (strong, nonatomic) id rawValue;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) NSInteger itemsCount;
@property (assign, nonatomic) NSInteger lastRequestTime;

- (void)reset;
- (BOOL)hasMoreData;
- (NSInteger)maxPage;


@end
