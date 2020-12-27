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

typedef void(^WLAuthResultBlock)(WLAuthorizationResult *result);

@interface WLBasePermission : NSObject < WLAuthorizationProtocol >

- (BOOL)requestAuthorization:(WLAuthResultBlock)completion NS_REQUIRES_SUPER;

@property (nonatomic,copy) WLAuthResultBlock resultBlock;
@property (nonatomic,strong) WLAuthorizationResult *result;

@end
