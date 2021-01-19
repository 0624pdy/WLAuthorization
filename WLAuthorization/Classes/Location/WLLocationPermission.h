//
//  WLLocationPermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"





@interface WLLocationConfig : WLAuthConfig

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
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLLocationConfig *config))config;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
/**
 *  请求精确位置的权限
 *
 *  @warning 使用该方法的前提条件是：定位权限不能是 kCLAuthorizationStatusNotDetermined
 *  @note 当 completion 回调中的 error == nil时，说明请求成功，此时可以通过 CLLocationManager 的属性 accuracyAuthorization 来判断是否获得精确位置权限
 *
 *  @param purposeKey - 目的，如果未在 info.plist 中设置相应的key，则请求时不会出现询问弹窗
 *  @param completion - 请求结果
 */
- (void)requestTemporaryFullAccuracyAuthorizationWithPurposeKey:(NSString *)purposeKey completion:(void(^)(NSError *error))completion;
#endif

@end
