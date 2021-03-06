//
//  WLAuthorizationProtocol.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WLAuthorizationTypes.h"

@protocol WLAuthorizationProtocol <NSObject>

@required

/**
 *  单例
 */
+ (instancetype)sharedPermission;

/**
 *  权限类型，详见枚举：WLAuthorizationType
 */
@property (nonatomic,class,readonly) WLAuthorizationType authorizationType;

/**
 *  info.plist文件中对应的key
 */
@property (nonatomic,class,readonly) NSString *infoPlistKey;

/**
 *  info.plist文件中是否有添加权限相关的key
 */
@property (nonatomic,class,readonly) BOOL hasSpecificPermissionKeyFromInfoPlist;

/**
 *  当权限被禁用时，可以调用该方法展示弹窗询问是否跳转到设置界面
 */
- (void)alertWithMessage:(NSString *)message cancel:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

@end
