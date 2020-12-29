//
//  WLCameraPermission.m
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/28.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLCameraPermission.h"

#import <AVFoundation/AVFoundation.h>





@implementation WLCameraConfig

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (self) {
        
    }
    return self;
}

@end





@interface WLCameraPermission ()

@property (nonatomic,copy) void(^block_config) (WLCameraConfig *config);
@property (nonatomic,strong) WLCameraConfig *config;

@end

@implementation WLCameraPermission

+ (instancetype)sharedPermission {
    static WLCameraPermission *permission = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        permission = [[WLCameraPermission alloc] init];
    });
    return permission;
}
+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Camera;
}
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion {
    return [self requestAuthorization:completion withConfig:nil];
}
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLCameraConfig *))config {
    
    BOOL isKeySet = [super requestAuthorization:completion];
    self.block_config = config;
    
    //info.plist文件中已设置key
    if (isKeySet) {

        BOOL enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

        //可用
        if (enabled) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            [self handleStatus:status isCallback:NO];
        }
        //不可用（模拟器不支持摄像头）
        else {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
        }
    }
    //info.plist文件中未设置key
    else {
        self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NoKey message:[NSString stringWithFormat:@"未在info.plist中添加字段：%@", [[self class] infoPlistKey]]];
    }
    
    //回调
    if (completion && self.result.shouldCallback) {
        completion(self.result);
    }
    
    return self.result.granted;
}

- (void)handleStatus:(AVAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                AVAuthorizationStatus newStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                [self handleStatus:newStatus isCallback:YES];
            }];
        }
            break;
        case AVAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
        case AVAuthorizationStatusDenied: {
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
        case AVAuthorizationStatusAuthorized: {
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
    
    if (isCallback && self.result.previousStatus != self.result.currentStatus) {
        //回调
        if (self.resultBlock) {
            self.resultBlock(self.result);
        }
    }
}






#pragma mark - Getter & Setter

- (void)setBlock_config:(void (^)(WLCameraConfig *))block_config {
    _block_config = block_config;
    
    if (_block_config) {
        _config = [[WLCameraConfig alloc] initWithName:@"相机"];
        _block_config(_config);
    }
}

@end
