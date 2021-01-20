//
//  WLCalendarPermission.h
//  WLAuthorization
//
//  Created by jzjy on 2021/1/20.
//

#import "WLBasePermission.h"

#import <EventKit/EKTypes.h>

        



@interface WLCalendarConfig : WLAuthConfig

@property (nonatomic,assign) EKEntityType type;

@end





@interface WLCalendarPermission : WLBasePermission

/**
 *  发起权限请求
 *
 *  @param completion   - 结果回调
 *  @param config       - 配置信息
 */
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void(^)(WLCalendarConfig *config))config;

@end
