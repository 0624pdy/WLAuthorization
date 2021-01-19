//
//  WLLocationPermission.m
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLLocationPermission.h"

#import <CoreLocation/CoreLocation.h>





@implementation WLLocationConfig

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (self) {
        _requestType = WLAuthRequestType_Always;
    }
    return self;
}

@end





@interface WLLocationPermission () < CLLocationManagerDelegate >

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,copy) void(^block_config) (WLLocationConfig *config);
@property (nonatomic,strong) WLLocationConfig *config;

@end

@implementation WLLocationPermission

WLSharedPermission(WLLocationPermission)

+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Location;
}
- (void)requestAuthorization:(WLAuthResultBlock)completion {
    return [self requestAuthorization:completion withConfig:nil];
}
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLLocationConfig *))config {
    [super requestAuthorization:completion];
    
    self.block_config = config;
    
    BOOL isKeySet = WLLocationPermission.hasSetPermissionKeyInInfoPlist;
    
    //info.plist文件中已设置key
    if (isKeySet) {
        
        BOOL enabled = [CLLocationManager locationServicesEnabled];
        
        //可用
        if (enabled) {
            
            CLAuthorizationStatus status;
            
            if (@available(iOS 14.0, *)) {
                status = self.locationManager.authorizationStatus;
            } else {
                status = [CLLocationManager authorizationStatus];
            }

            [self handleStatus:status isCallback:NO];
        }
        //不可用
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
}
- (void)requestTemporaryFullAccuracyAuthorizationWithPurposeKey:(NSString *)purposeKey completion:(void (^)(NSError *))completion {
    if (@available(iOS 14.0, *)) {
        [self.locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:purposeKey completion:completion];
    }
}

/**
 *  @param isCallback - 是否是代理的回调
 */
- (void)handleStatus:(CLAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];
            
            //总是允许（默认）/使用时允许
            if (self.config.requestType == WLAuthRequestType_WhenInUse) {
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
                    NSString *message = [NSString stringWithFormat:@"您已拒绝APP访问%@，请到\n[设置 - 隐私 - %@]\n中允许访问%@", self.config.authName, self.config.authName, self.config.authName];
                    [self alertWithMessage:message cancel:@"取消" confirmTitle:@"去设置"];
                }
            }
        }
            break;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
#else
        case kCLAuthorizationStatusAuthorized:
#endif
        {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }
            
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





#pragma mark - Getter & Setter

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)setBlock_config:(void (^)(WLLocationConfig *))block_config {
    _block_config = block_config;
    
    if (_block_config) {
        _config = [[WLLocationConfig alloc] initWithName:@"定位"];
        _block_config(_config);
    }
}

@end
