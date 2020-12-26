//
//  WLBasePermission.m
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"

#import "WLAuthorizationResult.h"

@implementation WLBasePermission

#pragma mark - WLAuthorizationProtocol

+ (instancetype)sharedPermission {
    printf("%s", [NSString stringWithFormat:@"\n\n\n❌❌❌ 请在子类中实现单例\n\n\n"].UTF8String);
    return nil;
}

+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Unknown;
}

+ (NSString *)infoPlistKey {
    
    WLAuthorizationType type = [self authorizationType];
    NSString *key = @"";
    
    if (type == WLAuthorizationType_Unknown) {
        key = @"";
    } else if (type == WLAuthorizationType_Location) {
        key = @"NSLocationAlwaysAndWhenInUseUsageDescription";
    }
    
    return key;
}

+ (BOOL)hasSpecificPermissionKeyFromInfoPlist {
    NSString *key = [self infoPlistKey];
    id obj = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    return (obj != nil);
}





#pragma mark -

- (BOOL)requestAuthorization:(void (^)(WLAuthorizationResult *))completion {
    return [[self class] hasSpecificPermissionKeyFromInfoPlist];
}

@end
