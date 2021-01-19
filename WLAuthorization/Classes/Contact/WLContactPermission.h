//
//  WLContactPermission.h
//  WLAuthorization
//
//  Created by jzjy on 2021/1/19.
//

#import "WLBasePermission.h"





@interface WLContactConfig : WLAuthConfig

@end





@interface WLContactPermission : WLBasePermission

/**
 *  发起权限请求
 *
 *  @param completion   - 结果回调
 *  @param config       - 配置信息
 */
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLContactConfig *config))config;

@end
