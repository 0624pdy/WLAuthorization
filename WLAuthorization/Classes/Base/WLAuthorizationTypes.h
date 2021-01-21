//
//  WLAuthorizationTypes.h
//  WLAuthorization
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#ifndef WLAuthorizationTypes_h
#define WLAuthorizationTypes_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class WLAuthorizationResult;

#define WLSharedPermission(clsName) \
\
+ (instancetype)sharedPermission { \
    static clsName *permission = nil; \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{ \
        permission = [[clsName alloc] init]; \
    }); \
    return permission; \
}

/**
 *  权限类型
 */
typedef NS_ENUM(NSInteger, WLAuthorizationType) {
    
    /** 未知，子类未设置 */
    WLAuthorizationType_Unknown         = 0,
    
    /** 相机 */
    WLAuthorizationType_Camera          = 1,
    /** 麦克风 */
    WLAuthorizationType_Microphone      = 2,
    /** 相册 */
    WLAuthorizationType_PhotoLibrary    = 3,
    /** 通讯录 */
    WLAuthorizationType_Contact         = 4,
    /** 日历 */
    WLAuthorizationType_Calendar        = 5,
    /** 蓝牙 */
    WLAuthorizationType_Bluetooth       = 6,
    
    /** 定位 */
    WLAuthorizationType_Location        = 10,
};

typedef NS_ENUM(NSInteger, WLAuthRequestType) {
    WLAuthRequestType_Always            = 0,    //总是允许
    WLAuthRequestType_WhenInUse         = 1,    //使用时允许
    WLAuthRequestType_Once              = 2,    //允许一次
};

typedef NS_ENUM(NSInteger, WLAuthorizationStatus) {
    WLAuthorizationStatus_Unknown       = -2,   //未知状态，初始化时暂不知道权限状态
    WLAuthorizationStatus_NoKey         = -1,   //未在info.plist中添加对应的key
    WLAuthorizationStatus_NotDetermined = 0,    //未设置权限，未访问过权限，下次询问
    WLAuthorizationStatus_Disabled      = 1,    //不支持、不可用 ... 反正就是不能用，用户没法改变改状态
    WLAuthorizationStatus_Denied        = 2,    //已拒绝，或者设置中为NO
    WLAuthorizationStatus_Authorized    = 3,    //已同意
    WLAuthorizationStatus_Limited       = 4,    //受限制的（只能使用部分功能）
};

typedef NS_ENUM(NSInteger, WLAuthorizationAccessLevel) {
    WLAuthorizationAccessLevel_ReadWrite    = 0,    //读写
    WLAuthorizationAccessLevel_WriteOnly    = 1,    //只能写入
    WLAuthorizationAccessLevel_ReadOnly     = 2,    //只读读取
};

typedef NS_ENUM(NSInteger, WLBluetoothRole) {
    WLBluetoothRole_Central     = 0,    //中心
    WLBluetoothRole_Peripheral  = 1,    //外设
};

typedef void(^WLAuthResultBlock)(WLAuthorizationResult *result);

#endif /* WLAuthorizationTypes_h */
