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

@property (nonatomic,assign,readonly) BOOL granted;
@property (nonatomic,assign,readonly) WLAuthorizationStatus previousStatus;  //之前的状态
@property (nonatomic,assign,readonly) WLAuthorizationStatus currentStatus;   //当前状态
@property (nonatomic,copy,readonly)   NSString *message;

+ (instancetype)withStatus:(WLAuthorizationStatus)status
                   message:(NSString *)message;

- (void)updateStatus:(WLAuthorizationStatus)status message:(NSString *)message;

@end
