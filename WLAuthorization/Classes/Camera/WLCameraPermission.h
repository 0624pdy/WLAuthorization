//
//  WLCameraPermission.h
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/28.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import <WLAuthorization/WLAuthorization.h>

@interface WLCameraConfig : WLAuthBaseConfig

@end

@interface WLCameraPermission : WLBasePermission

- (BOOL)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLCameraConfig *config))config;

@end
