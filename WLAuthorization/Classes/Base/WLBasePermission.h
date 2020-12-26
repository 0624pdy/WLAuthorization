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

@class WLAuthorizationResult;

@interface WLBasePermission : NSObject < WLAuthorizationProtocol >

- (BOOL)requestAuthorization:(void(^)(WLAuthorizationResult *result))completion NS_REQUIRES_SUPER;

@property (nonatomic,strong) WLAuthorizationResult *result;

@end
