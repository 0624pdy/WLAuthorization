//
//  WLLocationPermission.m
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLLocationPermission.h"

#import <CoreLocation/CoreLocation.h>

#import "WLAuthorizationResult.h"





@implementation WLLocationConfig

+ (instancetype)configWithName:(NSString *)name {
    WLLocationConfig *config = [super configWithName:name];
    if (config) {
        config.requestType = WLAuthRequestType_Always;
    }
    return config;
}

@end





@interface WLLocationPermission () < CLLocationManagerDelegate >

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) WLLocationConfig *config;

@end

@implementation WLLocationPermission

+ (instancetype)sharedPermission {
    static WLLocationPermission *permission = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        permission = [[WLLocationPermission alloc] init];
    });
    return permission;
}
+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Location;
}
+ (NSString *)name {
    return @"定位";
}
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLLocationConfig *))config {
    self.configBlock = config;
    
    BOOL isKeySet = [super requestAuthorization:completion];
    
    //info.plist文件中已设置key
    if (isKeySet) {
        
        BOOL enabled = [CLLocationManager locationServicesEnabled];
        
        //定位可用
        if (enabled) {
            
            CLAuthorizationStatus status;
            
            if (@available(iOS 14.0, *)) {
                status = self.locationManager.authorizationStatus;
            } else {
                status = [CLLocationManager authorizationStatus];
            }

            [self handleStatus:status isCallback:NO];
        }
        //定位不可用
        else {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
        }
    }
    //info.plist文件中未设置key
    else {
        self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NoKey message:[NSString stringWithFormat:@"未在info.plist中添加字段：%@", [[self class] infoPlistKey]]];
    }
    
    //回调
    if (completion && self.result.currentStatus == WLAuthorizationStatus_Authorized) {
        completion(self.result);
    }
    
    return self.result.granted;
}
- (BOOL)requestAuthorization:(WLAuthResultBlock)completion {
    return [self requestAuthorization:completion withConfig:nil];
}

/**
 *  @param isCallback - 是否是代理的回调
 */
- (void)handleStatus:(CLAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];
            if (self.config.requestType == WLAuthRequestType_Always) {
                [self.locationManager requestAlwaysAuthorization];
            } else if (self.config.requestType == WLAuthRequestType_WhenInUse) {
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                [self.locationManager requestAlwaysAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
        case kCLAuthorizationStatusDenied: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];
                
                if (self.config.openSettings_ifNeeded) {
                    NSString *message = [NSString stringWithFormat:@"您已拒绝APP访问您的%@，请到\n[设置 - 隐私 - 定位]\n中开启权限", [WLLocationPermission name]];
                    [self alertWithMessage:message cancel:@"取消" confirmTitle:@"去设置"];
                }
            }
        }
            break;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        case kCLAuthorizationStatusAuthorizedAlways: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }
            break;
#else
        case kCLAuthorizationStatusAuthorized: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }
            break;
#endif
            
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




 
#pragma mark - CLLocationManagerDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (@available(iOS 14.0, *)) {
        if (manager.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
            [self handleStatus:manager.authorizationStatus isCallback:YES];
        }
    }
}
#else
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self handleStatus:status isCallback:YES];
    }
}
#endif





#pragma mark -

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)setConfigBlock:(WLAuthConfigBlock)configBlock {
    [super setConfigBlock:configBlock];
    
    if (configBlock) {
        _config = [WLLocationConfig configWithName:@"定位"];
        configBlock(_config);
    }
}

@end
