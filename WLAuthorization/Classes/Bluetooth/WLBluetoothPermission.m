//
//  WLBluetoothPermission.m
//  WLAuthorization_Example
//
//  Created by jzjy on 2021/1/20.
//  Copyright © 2021 0624pdy@sina.com. All rights reserved.
//

#import "WLBluetoothPermission.h"

#import <CoreBluetooth/CoreBluetooth.h>





@implementation WLBluetoothConfig

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (self) {
        _managerType = WLBluetoothManagerType_Central;
    }
    return self;
}

@end





@interface WLBluetoothPermission () < CBCentralManagerDelegate, CBPeripheralManagerDelegate >

@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;

@property (nonatomic,copy) void(^block_config) (WLBluetoothConfig *config);
@property (nonatomic,strong) WLBluetoothConfig *config;

@end

@implementation WLBluetoothPermission

WLSharedPermission(WLBluetoothPermission)

+ (WLAuthorizationType)authorizationType {
    return WLAuthorizationType_Bluetooth;
}
- (void)requestAuthorization:(WLAuthResultBlock)completion {
    return [self requestAuthorization:completion withConfig:nil];
}
- (void)requestAuthorization:(WLAuthResultBlock)completion withConfig:(void (^)(WLBluetoothConfig *))config {
    [super requestAuthorization:completion];
    
    self.block_config = config;
    
    WLBluetoothManagerType managerType = self.config.managerType;
    
    BOOL isKeySet = NO;
    if (managerType == WLBluetoothManagerType_Central) {
        isKeySet = [self hasSetPermissionKey:@"NSBluetoothAlwaysUsageDescription"];
    } else if (managerType == WLBluetoothManagerType_Peripheral) {
        isKeySet = [self hasSetPermissionKey:@"NSBluetoothPeripheralUsageDescription"];
    }
    
    //info.plist文件中已设置key
    if (isKeySet) {

        if (managerType == WLBluetoothManagerType_Central) {
            if (@available(iOS 13.0, *)) {
                
                CBManagerAuthorization status;
                if (@available(iOS 13.1, *)) {
                    status = CBCentralManager.authorization;
                } else {
                    _centralManager = [[CBCentralManager alloc] init];
                    status = _centralManager.authorization;
                    _centralManager = nil;
                }
                [self handleStatus_iOS_13_:status isCallback:NO];
                
            } else if (@available(iOS 10.0, *)) {
                
                _centralManager = [[CBCentralManager alloc] init];
                CBManagerState status = self.centralManager.state;
                _centralManager = nil;
                [self handleStatus_iOS_10_:status isCallback:NO];
                
            }
        }
        else if (managerType == WLBluetoothManagerType_Peripheral) {
            if (@available(iOS 13.0, *)) {
                
                CBManagerAuthorization status;
                if (@available(iOS 13.1, *)) {
                    status = CBCentralManager.authorization;
                } else {
                    _peripheralManager = [[CBPeripheralManager alloc] init];
                    status = _peripheralManager.authorization;
                    _peripheralManager = nil;
                }
                [self handleStatus_iOS_13_:status isCallback:NO];
                
            } else if (@available(iOS 10.0, *)) {
                
                _peripheralManager = [[CBPeripheralManager alloc] init];
                CBManagerState status = _peripheralManager.state;
                _peripheralManager = nil;
                [self handleStatus_iOS_10_:status isCallback:NO];
                
            } else {
                
                
                
            }
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

- (void)handleStatus_iOS_13_:(CBManagerAuthorization)status isCallback:(BOOL)isCallback {
    
    switch (status) {
            
        case CBManagerAuthorizationNotDetermined: {
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];

            if (self.config.managerType == WLBluetoothManagerType_Central) {
                _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
            } else {
                _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
            }
        }
            break;
            
        case CBManagerAuthorizationRestricted: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        case CBManagerAuthorizationDenied: {
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

        case CBManagerAuthorizationAllowedAlways: {
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
- (void)handleStatus_iOS_10_:(CBManagerState)status isCallback:(BOOL)isCallback {
    switch (status) {
            
        case CBManagerStateUnknown:
        case CBManagerStateResetting: { 
            self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_NotDetermined message:@"未请求过权限"];

            _centralManager.delegate = nil;
            _centralManager = nil;
            [self.centralManager class];
        }
            break;
            
        case CBManagerStateUnsupported: {
            if (isCallback) {
                [self.result updateStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            } else {
                self.result = [WLAuthorizationResult withStatus:WLAuthorizationStatus_Disabled message:@"不可用"];
            }
        }
            break;
            
        case CBManagerStateUnauthorized:
        case CBManagerStatePoweredOff: {
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

        case CBManagerStatePoweredOn: {
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





#pragma mark - CBCentralManagerDelegate、CBPeripheralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (@available(iOS 13.0, *)) {
        if (@available(iOS 13.1, *)) {
            [self handleStatus_iOS_13_:CBCentralManager.authorization isCallback:YES];
        } else {
            [self handleStatus_iOS_13_:central.authorization isCallback:YES];
        }
    } else if (@available(iOS 10.0, *)) {
        [self handleStatus_iOS_10_:central.state isCallback:YES];
    } else {
        
    }
}
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (@available(iOS 13.0, *)) {
        if (@available(iOS 13.1, *)) {
            [self handleStatus_iOS_13_:CBPeripheralManager.authorization isCallback:YES];
        } else {
            [self handleStatus_iOS_13_:peripheral.authorization isCallback:YES];
        }
    } else if (@available(iOS 10.0, *)) {
        [self handleStatus_iOS_10_:peripheral.state isCallback:YES];
    } else {
        
    }
}





#pragma mark - Getter & Setter

- (void)setBlock_config:(void (^)(WLBluetoothConfig *))block_config {
    _block_config = block_config;
    
    if (_block_config) {
        _config = [[WLBluetoothConfig alloc] initWithName:@"蓝牙"];
        _block_config(_config);
    }
}

@end
