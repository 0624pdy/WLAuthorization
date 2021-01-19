//
//  WLPhotoLibraryPermission.m
//  WLAuthorization
//
//  Created by jzjy on 2020/12/29.
//

#import "WLPhotoLibraryPermission.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>





@implementation WLPhotoLibraryConfig

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (self) {
        _accessLevel = WLAuthorizationAccessLevel_ReadWrite;
    }
    return self;
}

@end





@interface WLPhotoLibraryPermission ()

@property (nonatomic,copy) void(^block_config) (WLPhotoLibraryConfig *config);
@property (nonatomic,strong) WLPhotoLibraryConfig *config;

@end

@implementation WLPhotoLibraryPermission

WLSharedPermission(WLPhotoLibraryPermission)

+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_PhotoLibrary;
}
- (void)requestAuthorization:(WLAuthResultBlock)completion {
    [self requestAuthorization:completion withConfig:nil];
}
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLPhotoLibraryConfig *))config {
    [super requestAuthorization:completion];
    
    self.block_config = config;
    
    BOOL isKeySet = WLPhotoLibraryPermission.hasSetPermissionKeyInInfoPlist;
    
    //info.plist文件中已设置key
    if (isKeySet) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0 // >= iOS 8 && <= iOS 14

            PHAuthorizationStatus status;
            
            if (@available(iOS 14, *)) {
                //iOS 14 要设置读写权限
                PHAccessLevel accessLevel = PHAccessLevelReadWrite;
                if (self.config.accessLevel == WLAuthorizationAccessLevel_WriteOnly) {
                    accessLevel = PHAccessLevelAddOnly;
                }
                status = [PHPhotoLibrary authorizationStatusForAccessLevel:accessLevel];
            } else {
                status = [PHPhotoLibrary authorizationStatus];
            }
            
            [self handleStatus_for_iOS_8_now:status isCallback:NO];
            
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0   // > iOS 7 && < iOS 8
            
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            
            [self handleStatus_for_iOS_7:status isCallback:NO];
            
#else
        
            [self handleStatus_for_iOS_6_earlier];
        
#endif
    }
    //info.plist文件中未设置key
    else {
        self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NoKey message:[NSString stringWithFormat:@"未在info.plist中添加字段：%@", [[self class] infoPlistKey]]];
    }

    //回调
    if (completion && self.result.shouldCallback) {
        completion(self.result);
    }
}





#pragma mark -

- (void)handleStatus_for_iOS_8_now:(PHAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
            
        //未设置权限：请求权限
        case PHAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];
            if (@available(iOS 14, *)) {
                
                //读写权限：读写（默认）/只能写入
                PHAccessLevel accessLevel = PHAccessLevelReadWrite;
                if (self.config.accessLevel == WLAuthorizationAccessLevel_WriteOnly) {
                    accessLevel = PHAccessLevelAddOnly;
                }
                
                [PHPhotoLibrary requestAuthorizationForAccessLevel:accessLevel handler:^(PHAuthorizationStatus newStatus) {
                    [self handleStatus_for_iOS_8_now:newStatus isCallback:YES];
                }];
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus newStatus) {
                    [self handleStatus_for_iOS_8_now:newStatus isCallback:YES];
                }];
            }
        }
            break;
            
        //不可用：回调
        case PHAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        //已拒绝：弹窗询问跳转【系统设置】
        case PHAuthorizationStatusDenied: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];

                if (self.config.openSettings_ifNeeded) {
                    NSString *message = [NSString stringWithFormat:@"您已拒绝APP访问%@，请到\n[设置 - 隐私 - %@]\n中允许访问%@", self.config.authName, self.config.authName, self.config.authName];
                    [self alertWithMessage:message cancel:@"取消" confirmTitle:@"去设置"];
                }
            }
        }
            break;
            
        //已授权：回调
        case PHAuthorizationStatusAuthorized: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }
            break;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        //受限制：回调
        case PHAuthorizationStatusLimited: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Limited message:@"受限制，只能访问部分图片"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Limited message:@"受限制，只能访问部分图片"];
            }
        }
            break;
#endif
            
        default:
            break;
    }

    if (isCallback && self.result.previousStatus != self.result.currentStatus) {
        if (self.resultBlock) {
            self.resultBlock(self.result);
        }
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0 && __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
- (void)handleStatus_for_iOS_7:(ALAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
        
        //权限未设置：请求权限
        case ALAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];
        }
            break;
            
        //不可用：回调
        case ALAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        //已拒绝：弹窗询问跳转【系统设置】
        case ALAuthorizationStatusDenied: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];

                if (self.config.openSettings_ifNeeded) {
                    NSString *message = [NSString stringWithFormat:@"您已拒绝APP访问%@，请到\n[设置 - 隐私 - %@]\n中允许访问%@", self.config.authName, self.config.authName, self.config.authName];
                    [self alertWithMessage:message cancel:@"取消" confirmTitle:@"去设置"];
                }
            }
        }
            break;
        
        //已授权：回调
        case ALAuthorizationStatusAuthorized: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }
            break;
            
        default:
            break;
    }
}
#endif

- (void)handleStatus_for_iOS_6_earlier {
    //iOS7 以前没有权限这个概念，默认就是允许的
    
    self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
    
    if (self.resultBlock) {
        self.resultBlock(self.result);
    }
}






#pragma mark - Getter & Setter

- (void)setBlock_config:(void (^)(WLPhotoLibraryConfig *))block_config {
    _block_config = block_config;
    
    if (_block_config) {
        _config = [[WLPhotoLibraryConfig alloc] initWithName:@"照片（相册）"];
        _block_config(_config);
    }
}

@end
