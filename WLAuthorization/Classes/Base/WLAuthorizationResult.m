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

- (BOOL)shouldCallback {
    //不可用：✅ 不支持或受限制 --> 直接回调
    //可用；✅ 直接回调
    //未设置key：✅ 直接返回
    //已关闭：❌ 询问是否打开设置
    //未询问：❌ 请求权限
    return (
        self.currentStatus == WLAuthorizationStatus_Disabled ||
        self.currentStatus == WLAuthorizationStatus_Authorized ||
        self.currentStatus == WLAuthorizationStatus_NoKey
    );
}

@end
