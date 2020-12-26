//
//  MGAuthManager.m
//  CashLoan
//
//  Created by MG_PDY on 2019/3/14.
//  Copyright © 2019 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "MGAuthManager.h"

@interface MGAuthManager () < CLLocationManagerDelegate >

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,copy) MGAuthTypeBlock locationAuthStatusDidChange;

@end

@implementation MGAuthManager

static MGAuthManager *manager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MGAuthManager alloc] init];
    });
    return manager;
}

+ (BOOL)authAvailableForType:(MGAuthType)type {
    switch (type) {
            
        //通讯录
        case MGAuthType_Contact: {
            CNAuthorizationStatus status = [self contactAuthStatus];
            return (status == CNAuthorizationStatusAuthorized);
        }
            
        //定位
        case MGAuthType_Location:  {
            CLAuthorizationStatus status = [self locationAuthStatus];
            return (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
        }
            
        //相机
        case MGAuthType_Camera: {
            AVAuthorizationStatus status = [self cameraAuthStatus];
            return (status == AVAuthorizationStatusAuthorized);
        }
            
        //相册
        case MGAuthType_PhotoLibrary: {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
            ALAuthorizationStatus status = [self photoLibraryAuthStatus];
            return (status == ALAuthorizationStatusAuthorized);
#else
            PHAuthorizationStatus status = [self photoLibraryAuthStatus];
            return (status == PHAuthorizationStatusAuthorized);
#endif
        }
            
        default: {
            return NO;
        }
    }
}
+ (void)requestAuthForTypes:(NSArray<NSNumber *> *)types {
    
    MGAuthType type = MGAuthType_None;
    
    for (NSNumber *num in types) {
        
        type = (MGAuthType)num.integerValue;
        
        if ([self authAvailableForType:type]) {
            continue;
        }
        
        switch (type) {
            case MGAuthType_Contact: {
                [self requestContactAuth_ifNeeded:^(MGAuthType type, BOOL granted, NSInteger status) {
                    [self callbackWithType:type granted:granted status:status];
                }];
            }
                break;
                
            case MGAuthType_Location: {
                [self requestLocationAuth_ifNeeded:^(MGAuthType authType, BOOL granted, NSInteger status) {
                    [self callbackWithType:type granted:granted status:status];
                }];
            }
                break;
                
            case MGAuthType_Camera: {
                [self requestCameraAuthStatus_ifNeeded:^(MGAuthType authType, BOOL granted, NSInteger status) {
                    [self callbackWithType:type granted:granted status:status];
                }];
            }
                break;
                
            case MGAuthType_Microphone: {
                [self requestMicrophoneAuthStatus_ifNeeded:^(MGAuthType authType, BOOL granted, NSInteger status) {
                    [self callbackWithType:type granted:granted status:status];
                }];
            }
                break;
                
            case MGAuthType_PhotoLibrary: {
                [self requestPhotoLibraryAuthStatus_ifNeeded:^(MGAuthType authType, BOOL granted, NSInteger status) {
                    [self callbackWithType:type granted:granted status:status];
                }];
            }
                break;
                
            case MGAuthType_Cellular: {
                [self requestCellularAuthStatus_ifNeeded:^(MGAuthType authType, BOOL granted, NSInteger status) {
                    [self callbackWithType:type granted:granted status:status];
                }];
            }
                break;
    
            default:
                break;
        }
    }
}
+ (void)appSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    [[UIApplication sharedApplication] openURL:url];
#else
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{  } completionHandler:nil];
    } else {
        // Fallback on earlier versions
    }
#endif
}
+ (void)callbackWithType:(MGAuthType)type granted:(BOOL)granted status:(NSInteger)status {
    if ([MGAuthManager sharedManager].authStatusChanged) {
        [MGAuthManager sharedManager].authStatusChanged(type, granted, status);
    }
}




#pragma mark - 通讯录

+ (CNAuthorizationStatus)contactAuthStatus {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    return status;
}
+ (void)requestContactAuth_ifNeeded:(MGAuthTypeBlock)callback {
    CNAuthorizationStatus status = [self contactAuthStatus];
    switch (status) {
        //未授权
        case CNAuthorizationStatusNotDetermined: {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts
                            completionHandler:^(BOOL granted, NSError*  _Nullable error)
            {
                if (callback) {
                    callback(MGAuthType_Contact, granted, status);
                }
                NSLog(@"通讯录授权%@", granted ? @"成功" : [NSString stringWithFormat:@"失败 - %@", error.localizedDescription]);
            }];
        }
            break;
        //已授权
        case CNAuthorizationStatusAuthorized: {
            if (callback) {
                callback(MGAuthType_Contact, YES, status);
            }
        }
            break;
        
        case CNAuthorizationStatusDenied: {
            //TODO: 跳转设置
            [self appSettings];
        }
            break;
            
        default: {
            
        }
            break;
    }
}





#pragma mark - 定位

+ (CLAuthorizationStatus)locationAuthStatus {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return status;
}
+ (void)requestLocationAuth_ifNeeded:(MGAuthTypeBlock)callback {
    CLAuthorizationStatus status = [self locationAuthStatus];
    switch (status) {
            
        //未授权
        case kCLAuthorizationStatusNotDetermined: {
            [MGAuthManager sharedManager].locationAuthStatusDidChange = callback;
            [[MGAuthManager sharedManager].locationManager requestWhenInUseAuthorization];
//            [[MGAuthManager sharedManager].locationManager requestAlwaysAuthorization];
        }
            break;
            
        //已授权
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        case kCLAuthorizationStatusAuthorized:
#else
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
#endif
        {
            if (callback) {
                callback(MGAuthType_Location, YES, status);
            }
        }
            break;
            
        case kCLAuthorizationStatusDenied: {
            //TODO: 跳转设置
            [self appSettings];
        }
            break;
            
        default: {
            
        }
            break;
    }
}
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    BOOL granted = (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
    if (_locationAuthStatusDidChange) {
        _locationAuthStatusDidChange(MGAuthType_Location, granted, status);
        
        //_locationAuthStatusDidChange = nil;
        //_locationManager = nil;
    }
    NSLog(@"定位授权%@", (granted ? @"成功" : @"失败"));
}




#pragma mark - 相机、麦克风

+ (AVAuthorizationStatus)pri_avAuthStatusForMediaType:(AVMediaType)mediaType {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    return status;
}
+ (void)pri_requestAVAuthStatusForAuthType:(MGAuthType)type mediaType:(AVMediaType)mediaType name:(NSString *)name callback:(MGAuthTypeBlock)callback {
    AVAuthorizationStatus status = [self pri_avAuthStatusForMediaType:mediaType];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (callback) {
                    callback(type, granted, status);
                }
                NSLog(@"%@授权%@", name, (granted ? @"成功" : @"失败"));
            }];
        }
            break;
            
        case AVAuthorizationStatusAuthorized: {
            if (callback) {
                callback(type, YES, status);
            }
        }
            break;
            
        case AVAuthorizationStatusDenied: {
            //TODO: 跳转设置
            [self appSettings];
        }
            break;
            
        default: {
            
        }
            break;
    }
}

+ (AVAuthorizationStatus)cameraAuthStatus {
    return [self pri_avAuthStatusForMediaType:AVMediaTypeVideo];
}
+ (void)requestCameraAuthStatus_ifNeeded:(MGAuthTypeBlock)callback {
    [self pri_requestAVAuthStatusForAuthType:MGAuthType_Camera mediaType:AVMediaTypeVideo name:@"相机" callback:callback];
}
+ (AVAuthorizationStatus)microphoneAuthStatus {
    return [self pri_avAuthStatusForMediaType:AVMediaTypeAudio];
}
+ (void)requestMicrophoneAuthStatus_ifNeeded:(MGAuthTypeBlock)callback {
    [self pri_requestAVAuthStatusForAuthType:MGAuthType_Microphone mediaType:AVMediaTypeAudio name:@"麦克风" callback:callback];
}





#pragma mark - 相册

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
+ (ALAuthorizationStatus)photoLibraryAuthStatus {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    return status;
}
#else
+ (PHAuthorizationStatus)photoLibraryAuthStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status;
}
#endif
+ (void)requestPhotoLibraryAuthStatus_ifNeeded:(MGAuthTypeBlock)callback {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    ALAuthorizationStatus status = [self photoLibraryAuthStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined: {
            //TODO: 请求授权
        }
            break;
            
        case ALAuthorizationStatusAuthorized: {
            if (callback) {
                callback(MGAuthType_PhotoLibrary, YES, status);
            }
        }
            break;
            
        case ALAuthorizationStatusDenied: {
            //TODO: 跳转设置
            [self appSettings];
        }
            break;
            
        default: {
            
        }
            break;
    }
#else
    PHAuthorizationStatus status = [self photoLibraryAuthStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus theStatus) {
                BOOL granted = (theStatus == PHAuthorizationStatusAuthorized);
                if (callback) {
                    callback(MGAuthType_PhotoLibrary, granted, status);
                }
                NSLog(@"相册授权%@", (granted ? @"成功" : @"失败"));
            }];
        }
            break;
            
        case PHAuthorizationStatusAuthorized: {
            if (callback) {
                callback(MGAuthType_PhotoLibrary, YES, status);
            }
        }
            break;
            
        case PHAuthorizationStatusDenied: {
            //TODO: 跳转设置
            [self appSettings];
        }
            break;
            
        default: {
            
        }
            break;
    }
#endif
}




+ (CTCellularDataRestrictedState)cellularAuthStatus {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    cellularData = nil;
    return state;
}
+ (void)requestCellularAuthStatus_ifNeeded:(MGAuthTypeBlock)callback {
    CTCellularDataRestrictedState status = [self cellularAuthStatus];
    switch (status) {
        case kCTCellularDataRestrictedStateUnknown: {
            CTCellularData *cellularData = [[CTCellularData alloc]init];
            cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
                BOOL granted = (state == kCTCellularDataNotRestricted);
                if (callback) {
                    callback(MGAuthType_Camera, granted, status);
                }
                NSLog(@"相机授权%@", (granted ? @"成功" : @"失败"));
            };
        }
            break;
            
        case kCTCellularDataNotRestricted: {
            if (callback) {
                callback(MGAuthType_Camera, YES, status);
            }
        }
            break;
            
        case kCTCellularDataRestricted: {
            //TODO: 跳转设置
            [self appSettings];
        }
            break;
            
        default: {
            
        }
            break;
    }
}

@end
