//
//  WLBasePermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WLAuthorizationProtocol.h"
#import "WLAuthorizationTypes.h"

@class WLAuthBaseConfig;
@class WLAuthorizationResult;

typedef void(^WLAuthResultBlock)(WLAuthorizationResult *result);
typedef void(^WLAuthConfigBlock)(WLAuthBaseConfig *config);


@interface WLAuthBaseConfig : NSObject

/** 权限名称，如：相机、定位、相册 ...... */
@property (nonatomic,copy) NSString *authName;
@property (nonatomic,assign) BOOL openSettings_ifNeeded;

+ (instancetype)configWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

@end

@interface WLBasePermission : NSObject < WLAuthorizationProtocol >

- (BOOL)requestAuthorization:(WLAuthResultBlock)completion;

@property (nonatomic,copy) WLAuthResultBlock resultBlock;
@property (nonatomic,copy) WLAuthConfigBlock configBlock;

@property (nonatomic,strong) WLAuthorizationResult *result;

@end
