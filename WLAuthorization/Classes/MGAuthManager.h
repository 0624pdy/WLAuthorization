//
//  MGAuthManager.h
//  CashLoan
//
//  Created by MG_PDY on 2019/3/14.
//  Copyright © 2019 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Contacts/Contacts.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <CoreTelephony/CTCellularData.h>

typedef NS_ENUM(NSInteger, MGAuthType) {
    
    MGAuthType_None         = 0,    // ✅ 无
    
    MGAuthType_Contact      = 1,    // ✅ 通讯录
    MGAuthType_Location     = 2,    // ✅ 定位（位置）
    MGAuthType_Camera       = 3,    // ✅ 相机
    MGAuthType_Microphone   = 4,    // ✅ 麦克风
    MGAuthType_PhotoLibrary = 5,    // ✅ 相册
    
    MGAuthType_Bluetooth    = 6,    // ❌ 蓝牙
    MGAuthType_Calendar     = 7,    // ❌ 日历
    
    MGAuthType_Cellular     = 8,    // ✅ 网络
};
typedef void(^MGAuthTypeBlock)(MGAuthType authType, BOOL granted, NSInteger status);

@interface MGAuthManager : NSObject

+ (instancetype)sharedManager;

/**
 *  批量请求权限
 *  @param types - 权限类型，详见枚举：MGAuthType
 */
+ (void)requestAuthForTypes:(NSArray<NSNumber *> *)types;

/**
 *  指定权限是否可用
 *  @param type - 权限类型，详见枚举：MGAuthType
 */
+ (BOOL)authAvailableForType:(MGAuthType)type;

/**
 *  跳转app设置
 */
+ (void)appSettings;

@property (nonatomic,copy) MGAuthTypeBlock authStatusChanged;


#pragma mark - 通讯录
+ (CNAuthorizationStatus)contactAuthStatus;
+ (void)requestContactAuth_ifNeeded:(MGAuthTypeBlock)callback;

#pragma mark - 定位
+ (CLAuthorizationStatus)locationAuthStatus;
+ (void)requestLocationAuth_ifNeeded:(MGAuthTypeBlock)callback;

#pragma mark - 相机、麦克风
+ (AVAuthorizationStatus)cameraAuthStatus;
+ (void)requestCameraAuthStatus_ifNeeded:(MGAuthTypeBlock)callback;
+ (AVAuthorizationStatus)microphoneAuthStatus;
+ (void)requestMicrophoneAuthStatus_ifNeeded:(MGAuthTypeBlock)callback;

#pragma mark - 相册
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
+ (ALAuthorizationStatus)photoLibraryAuthStatus;
#else
+ (PHAuthorizationStatus)photoLibraryAuthStatus;
#endif
+ (void)requestPhotoLibraryAuthStatus_ifNeeded:(MGAuthTypeBlock)callback;

#pragma mark - 网络
+ (CTCellularDataRestrictedState)cellularAuthStatus;
+ (void)requestCellularAuthStatus_ifNeeded:(MGAuthTypeBlock)callback;

@end
