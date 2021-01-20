//
//  WLBasePermission.m
//  WLAuthorization_Example
//
//  Created by jzjy on 2020/12/26.
//  Copyright © 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLBasePermission.h"

#import "WLAuthorizationResult.h"





#pragma mark -

@implementation WLAuthConfig

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _authName               = name;
        _openSettings_ifNeeded  = NO;
    }
    return self;
}

@end




#pragma mark -

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
    } else if (type == WLAuthorizationType_Camera) {
        key = @"NSCameraUsageDescription";
    } else if (type == WLAuthorizationType_Microphone) {
        key = @"NSMicrophoneUsageDescription";
    } else if (type == WLAuthorizationType_PhotoLibrary) {
        key = @"NSPhotoLibraryUsageDescription";    //NSPhotoLibraryAddUsageDescription
    } else if (type == WLAuthorizationType_Contact) {
        key = @"NSContactsUsageDescription";
    } else if (type == WLAuthorizationType_Calendar) {
        key = @"NSCalendarsUsageDescription";
    } else if (type == WLAuthorizationType_Location) {
        key = @"NSLocationAlwaysAndWhenInUseUsageDescription";
    } else if (type == WLAuthorizationType_Bluetooth) {
        key = @"NSBluetoothAlwaysUsageDescription";
    }
    
    return key;
}
+ (BOOL)hasSetPermissionKeyInInfoPlist {
    NSString *key = [self infoPlistKey];
    id obj = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    return (obj != nil);
}
- (BOOL)hasSetPermissionKey:(NSString *)key {
    id obj = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    return (obj != nil);
}
- (void)alertWithMessage:(NSString *)message cancel:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [WLBasePermission openSettings];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}




#pragma mark -

- (void)requestAuthorization:(WLAuthResultBlock)completion {
    _resultBlock = completion;
}




#pragma mark -

+ (void)openSettings {
    NSURL *url = nil;
//        url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//        url = [NSURL URLWithString:@"prefs:root=com.pdy.WLAuthorization"];
//        url = [NSURL URLWithString:@"App-Prefs:root=LOCATION_SERVICES"];
//        url = [NSURL URLWithString:@"App-Prefs:root=com.pdy.WLAuthorization"];
    url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
