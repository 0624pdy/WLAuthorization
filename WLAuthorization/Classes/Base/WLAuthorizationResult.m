//
//  WLAuthorizationResult.m
//  WLAuthorization
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLAuthorizationResult.h"

@interface WLAuthorizationResult ()

@property (nonatomic,assign) BOOL granted;
@property (nonatomic,assign) WLAuthorizationStatus previousStatus;  //之前的状态
@property (nonatomic,assign) WLAuthorizationStatus currentStatus;   //当前状态
@property (nonatomic,copy)   NSString *message;

@end

@implementation WLAuthorizationResult

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化：两个都设置为未知状态
        _previousStatus = WLAuthorizationStatus_Unknown;
        _currentStatus  = WLAuthorizationStatus_Unknown;
    }
    return self;
}
+ (instancetype)withStatus:(WLAuthorizationStatus)status message:(NSString *)message {
    WLAuthorizationResult *model = [[WLAuthorizationResult alloc] init];
     
    [model updateStatus:status message:message];
    
    return model;
}
- (void)updateStatus:(WLAuthorizationStatus)status message:(NSString *)message {
    _previousStatus = _currentStatus;
    _currentStatus  = status;
    _message        = message;
    _granted        = (_currentStatus == WLAuthorizationStatus_Authorized);
}

@end
