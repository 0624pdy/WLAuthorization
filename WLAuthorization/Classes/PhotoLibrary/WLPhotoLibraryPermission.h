//
//  WLPhotoLibraryPermission.h
//  WLAuthorization
//
//  Created by jzjy on 2020/12/29.
//

#import "WLBasePermission.h"




@interface WLPhotoLibraryConfig : WLAuthBaseConfig

/**
 *  访问级别
 *
 *  @enum WLAuthorizationAccessLevel_ReadWrite - 读写
 *  @enum WLAuthorizationAccessLevel_WriteOnly - 只能写入
 */
@property (nonatomic,assign) WLAuthorizationAccessLevel accessLevel;

@end





@interface WLPhotoLibraryPermission : WLBasePermission

/**
 *  发起权限请求
 *
 *  @param completion   - 结果回调
 *  @param config       - 配置信息
 */
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLPhotoLibraryConfig *config))config;

@end
