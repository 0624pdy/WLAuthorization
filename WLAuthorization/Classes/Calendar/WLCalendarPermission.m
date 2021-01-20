//
//  WLCalendarPermission.m
//  WLAuthorization
//
//  Created by jzjy on 2021/1/20.
//

#import "WLCalendarPermission.h"

#import <EventKit/EventKit.h>





@implementation WLCalendarConfig

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (self) {
        _type = EKEntityTypeEvent;
    }
    return self;
}

@end





@interface WLCalendarPermission ()

@property (nonatomic,copy) void(^block_config) (WLCalendarConfig *config);
@property (nonatomic,strong) WLCalendarConfig *config;

@end

@implementation WLCalendarPermission

WLSharedPermission(WLCalendarPermission)

+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Calendar;
}
- (void)requestAuthorization:(WLAuthResultBlock)completion {
    return [self requestAuthorization:completion withConfig:nil];
}
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLCalendarConfig *))config {
    [super requestAuthorization:completion];
    
    self.block_config = config;
    
    BOOL isKeySet = WLCalendarPermission.hasSetPermissionKeyInInfoPlist;
    
    //info.plist文件中已设置key
    if (isKeySet) {
        EKEntityType entityType = self.config.type;
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:entityType];
        [self handleStatus:status isCallback:NO];
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
- (void)handleStatus:(EKAuthorizationStatus)status isCallback:(BOOL)isCallback {
    switch (status) {
            
        case EKAuthorizationStatusNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];

            EKEntityType type = self.config.type;
            
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
                [self handleStatus:status isCallback:YES];
            }];
        }
            break;
            
        case EKAuthorizationStatusRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        case EKAuthorizationStatusDenied: {
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

        case EKAuthorizationStatusAuthorized: {
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





#pragma mark - Getter & Setter

- (void)setBlock_config:(void (^)(WLCalendarConfig *))block_config {
    _block_config = block_config;
    
    if (_block_config) {
        _config = [[WLCalendarConfig alloc] initWithName:@"日历"];
        _block_config(_config);
    }
}

@end
