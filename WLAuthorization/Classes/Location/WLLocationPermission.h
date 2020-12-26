//
//  WLLocationPermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"

@class WLLocationConfig;

@interface WLLocationPermission : WLBasePermission

@property (nonatomic,strong) WLLocationConfig *config;

@end





@interface WLLocationConfig : NSObject

@property (nonatomic,assign) NSInteger requestType;
@property (nonatomic,assign) BOOL openSettingsIfNeeded;

@property (nonatomic,readonly,class) WLLocationConfig *defaultConfig;

@end
