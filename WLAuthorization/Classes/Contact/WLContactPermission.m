//
//  WLContactPermission.m
//  WLAuthorization
//
//  Created by jzjy on 2021/1/19.
//

#import "WLContactPermission.h"

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>





@implementation WLContactConfig

@end





@interface WLContactPermission ()

@property (nonatomic,copy) void(^block_config) (WLContactConfig *config);
@property (nonatomic,strong) WLContactConfig *config;

@end

@implementation WLContactPermission

WLSharedPermission(WLContactPermission)

+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Contact;
}
- (void)requestAuthorization:(WLAuthResultBlock)completion {
    return [self requestAuthorization:completion withConfig:nil];
}
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLContactConfig *))config {
    [super requestAuthorization:completion];
    
    self.block_config = config;
    
    BOOL isKeySet = WLContactPermission.hasSetPermissionKeyInInfoPlist;
    
    //info.plist文件中已设置key
    if (isKeySet) {
        if (@available(iOS 9.0, *)) {
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            [self handleStatus_iOS_9_:status isCallback:NO];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
            [self handleStatus_iOS_8_:status isCallback:NO];
#pragma clang diagnostic pop
        }
        
    }
    //info.plist文件中未设置key
    else {
        self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NoKey message:[NSString stringWithFormat:@"未在info.plist中添加字段：%@", [[self class] infoPlistKey]]];
    }
    
    //回调
    if (completion && self.result.shouldCallback) {
        completion(self.result);
    }
}





#pragma mark -

/**
 *  @param isCallback - 是否是代理的回调
 */
- (void)handleStatus_iOS_9_:(CNAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
            
        case CNAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];

            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                [self handleStatus_iOS_9_:status isCallback:YES];
            }];
        }
            break;
            
        case CNAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        case CNAuthorizationStatusDenied: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];

                if (self.config.openSettings_ifNeeded) {
                    NSString *message = [NSString stringWithFormat:@"您已拒绝APP访问%@，请到\n[设置 - 隐私 - %@]\n中允许访问%@", self.config.authName, self.config.authName, self.config.authName];
                    [self alertWithMessage:message cancel:@"取消" confirmTitle:@"去设置"];
                }
            }
        }
            break;

        case CNAuthorizationStatusAuthorized: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }

        default:
            break;
    }

    if (isCallback && self.result.previousStatus != self.result.currentStatus) {
        //回调
        if (self.resultBlock) {
            self.resultBlock(self.result);
        }
    }
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)handleStatus_iOS_8_:(ABAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
            
        case kABAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];

            ABAddressBookRef addressBook = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
                [self handleStatus_iOS_8_:status isCallback:YES];
            });
        }
            break;
            
        case kABAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        case kABAuthorizationStatusDenied: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Denied message:@"已拒绝"];

                if (self.config.openSettings_ifNeeded) {
                    NSString *message = [NSString stringWithFormat:@"您已拒绝APP访问%@，请到\n[设置 - 隐私 - %@]\n中允许访问%@", self.config.authName, self.config.authName, self.config.authName];
                    [self alertWithMessage:message cancel:@"取消" confirmTitle:@"去设置"];
                }
            }
        }
            break;

        case kABAuthorizationStatusAuthorized: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Authorized message:@"已授权"];
            }
        }

        default:
            break;
    }

    if (isCallback && self.result.previousStatus != self.result.currentStatus) {
        //回调
        if (self.resultBlock) {
            self.resultBlock(self.result);
        }
    }
}
#pragma clang diagnostic pop





#pragma mark - Getter & Setter

- (void)setBlock_config:(void (^)(WLContactConfig *))block_config {
    _block_config = block_config;
    
    if (_block_config) {
        _config = [[WLContactConfig alloc] initWithName:@"通讯录"];
        _block_config(_config);
    }
}

@end
