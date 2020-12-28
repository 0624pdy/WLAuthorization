//
//  WLMicrophonePermission.h
//  WLAuthorization_Example
//
//  Created by zhaowl on 2020/12/28.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"





@interface WLMicrophoneConfig : WLAuthBaseConfig

@end





@interface WLMicrophonePermission : WLBasePermission

/**
 *  发起权限请求
 *
 *  @param completion   - 结果回调
 *  @param config            - 配置信息
 */
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLMicrophoneConfig *config))config;

@end
