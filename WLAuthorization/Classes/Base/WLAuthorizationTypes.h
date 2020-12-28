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

/**
 *  权限类型
 */
typedef NS_ENUM(NSInteger, WLAuthorizationType) {
    
    /** 未知，子类未设置 */
    WLAuthorizationType_Unknown     = 0,
    
    /** 相机 */
    WLAuthorizationType_Camera      = 1,
    /** 麦克风 */
    WLAuthorizationType_Microphone  = 2,
    
    /** 定位 */
    WLAuthorizationType_Location    = 10,
};

typedef NS_ENUM(NSInteger, WLAuthRequestType) {
    WLAuthRequestType_Always        = 0,    //总是允许
    WLAuthRequestType_WhenInUse     = 1,    //使用时允许
    WLAuthRequestType_Once          = 2,    //允许一次
};

typedef NS_ENUM(NSInteger, WLAuthorizationStatus) {
    WLAuthorizationStatus_Unknown       = -2,   //未知状态，初始化时的默认值
    WLAuthorizationStatus_NoKey         = -1,   //未在info.plist中添加对应的key
    WLAuthorizationStatus_NotDetermined = 0,    //未请求过权限，权限未定，下次询问
    WLAuthorizationStatus_Disabled      = 1,    //不可用、不支持、受限制 ... 反正就是不能用，用户没法改变改状态
    WLAuthorizationStatus_Denied        = 2,    //用户明确点了拒绝，或者设置中为NO
    WLAuthorizationStatus_Authorized    = 3,    //已同意，已授权
};

typedef void(^WLAuthResultBlock)(WLAuthorizationResult *result);

#endif /* WLAuthorizationTypes_h */
