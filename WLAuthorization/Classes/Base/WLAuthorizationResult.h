//
//  WLAuthorizationResult.h
//  WLAuthorization
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WLAuthorizationTypes.h"

@interface WLAuthorizationResult : NSObject

@property (nonatomic,assign,readonly) BOOL granted;                         //是否已授权
@property (nonatomic,assign,readonly) WLAuthorizationStatus previousStatus; //之前的状态
@property (nonatomic,assign,readonly) WLAuthorizationStatus currentStatus;  //当前状态
@property (nonatomic,copy,readonly)   NSString *message;                    //信息

/**
 *  初始化
 *  @param status - 当前状态
 *  @param message - 信息
 */
+ (instancetype)withStatus:(WLAuthorizationStatus)status
                   message:(NSString *)message;

/**
 *  更新
 *  @param status - 当前状态
 *  @param message - 信息
 */
- (void)updateStatus:(WLAuthorizationStatus)status message:(NSString *)message;


/** 是否需要回调 */
@property (nonatomic,assign,readonly) BOOL shouldCallback;

@end
