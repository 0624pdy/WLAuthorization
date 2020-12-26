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

@interface WLLocationPermission () < CLLocationManagerDelegate >

@property (nonatomic,strong) CLLocationManager *locationManager;

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
- (BOOL)requestAuthorization:(void (^)(WLAuthorizationResult *))completion {
    
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
    if (completion) {
        completion(self.result);
    }
    
    return self.result.granted;
}
- (void)handleStatus:(CLAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];
            if (_config.requestType == 0) {
                [self.locationManager requestAlwaysAuthorization];
            } else {
                [self.locationManager requestWhenInUseAuthorization];
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
}



 
#pragma mark - CLLocationManagerDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (@available(iOS 14.0, *)) {
        [self handleStatus:manager.authorizationStatus isCallback:YES];
    } else {
        // Fallback on earlier versions
    }
}
#else
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self handleStatus:status isCallback:YES];
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

@end






@implementation WLLocationConfig

+ (WLLocationConfig *)defaultConfig {
    WLLocationConfig *config = [[WLLocationConfig alloc] init];
    
    config.requestType = 1;
    config.openSettingsIfNeeded = YES;
    
    return config;
}

@end
