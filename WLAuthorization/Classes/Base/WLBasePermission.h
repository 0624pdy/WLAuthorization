//
//  WLBasePermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WLAuthorizationProtocol.h"
#import "WLAuthorizationResult.h"





@interface WLAuthConfig : NSObject

/** 权限名称，如：相机、定位、相册 ...... */
@property (nonatomic,copy) NSString *authName;
/** 权限被关闭时，是否弹窗询问用户打开设置界面，默认：NO */
@property (nonatomic,assign) BOOL openSettings_ifNeeded;

/**
 *  初始化
 *  @param name - 权限名称，如：定位、相机、相册 ......
 */
- (instancetype)initWithName:(NSString *)name;

@end





@interface WLBasePermission : NSObject < WLAuthorizationProtocol >

/**
 *  发起权限请求
 *
 *  @param completion - 结果回调
 */
- (void)requestAuthorization:(WLAuthResultBlock)completion;

/**
 *  结果回调代码块
 */
@property (nonatomic,copy) WLAuthResultBlock resultBlock;

/**
 *  结果
 */
@property (nonatomic,strong) WLAuthorizationResult *result;





#pragma mark -

/**
 *  打开系统设置
 */
+ (void)openSettings;

@end
