//
//  WLLocationPermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"





@interface WLLocationConfig : WLAuthBaseConfig

/** 请求类型，详见枚举：WLAuthRequestType */
@property (nonatomic,assign) WLAuthRequestType requestType;

@end





@interface WLLocationPermission : WLBasePermission

/**
 *  发起权限请求
 *
 *  @param completion   - 结果回调
 *  @param config       - 配置信息
 */
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLLocationConfig *config))config;

@end
