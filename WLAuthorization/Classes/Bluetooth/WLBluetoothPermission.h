//
//  WLBluetoothPermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2021/1/20.
//  Copyright © 2021 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"





@interface WLBluetoothConfig : WLAuthConfig

@property (nonatomic,assign) WLBluetoothManagerType managerType;

@end





@interface WLBluetoothPermission : WLBasePermission

/**
 *  发起权限请求
 *
 *  @param completion   - 结果回调
 *  @param config       - 配置信息
 */
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLBluetoothConfig *config))config;

@end
