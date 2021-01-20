//
//  WLViewController.m
//  WLAuthorization
//
//  Created by 0624pdy@sina.com on 12/26/2020.
//  Copyright (c) 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLViewController.h"

#import <WLAuthorization/WLAuthorization.h>

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import <CoreTelephony/CTCellularData.h>

//#import <WLAuthorization/WLLocationPermission.h>
//#import <WLAuthorization/WLCameraPermission.h>
//#import <WLAuthorization/WLMicrophonePermission.h>

@interface WLViewController () < PHPickerViewControllerDelegate >

@end

@implementation WLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"请求" style:UIBarButtonItemStylePlain target:self action:@selector(action_request:)];
    UIBarButtonItem *test = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(action_test:)];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(action_settings:)];
    self.navigationItem.rightBarButtonItems = @[ settings, test ];
    
    NSLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -

- (void)action_request:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选要请求的权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLLocationPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result.granted) {
                [[WLLocationPermission sharedPermission] requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"bbb" completion:^(NSError *error) {
                    
                }];
            }
        } withConfig:^(WLLocationConfig *config) {
            config.openSettings_ifNeeded = YES;
            config.requestType = WLAuthRequestType_Once;
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLCameraPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result.granted) {

            }
        } withConfig:^(WLCameraConfig *config) {
            config.openSettings_ifNeeded = YES;
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"麦克风" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLMicrophonePermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result.granted) {

            }
        } withConfig:^(WLMicrophoneConfig *config) {
            config.openSettings_ifNeeded = YES;
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLPhotoLibraryPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result) {

            }
        } withConfig:^(WLPhotoLibraryConfig *config) {
            config.openSettings_ifNeeded = YES;
            if (@available(iOS 14, *)) {
                config.accessLevel = WLAuthorizationAccessLevel_ReadWrite;
            }
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"通讯录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLContactPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result) {

            }
        } withConfig:^(WLContactConfig *config) {
            config.openSettings_ifNeeded = YES;
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"日历" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLCalendarPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result) {

            }
        } withConfig:^(WLCalendarConfig *config) {
            config.openSettings_ifNeeded = YES;
            config.type = (arc4random() % 2 ? EKEntityTypeEvent : EKEntityTypeReminder);
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"蓝牙" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WLBluetoothPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
            if (result) {
                
            }
        } withConfig:^(WLBluetoothConfig *config) {
            config.openSettings_ifNeeded = YES;
            config.managerType = WLBluetoothManagerType_Peripheral;
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
        
    
        
    
        
        
    
//    CTCellularData *data = [[CTCellularData alloc] init];
//    data.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
//        BOOL granted = (state == kCTCellularDataNotRestricted);
//        NSLog(@"相机授权%@", (granted ? @"成功" : @"失败"));
//    };
}
- (void)action_test:(id)sender {
//    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
//    if (@available(iOS 14, *)) {
//        [library presentLimitedLibraryPickerFromViewController:self];
//    } else {
//        // Fallback on earlier versions
//    }
    
    
    if (@available(iOS 14, *)) {
        
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeAutomatic;
        config.selectionLimit = 1;
        
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        // Fallback on earlier versions
    }
    
    
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];
}
- (void)action_settings:(id)sender {
    [WLBasePermission openSettings];
}





#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    if (results) {
        PHPickerResult *item = results.firstObject;
        NSItemProvider *itemProvider = item.itemProvider;
        if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
            [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                if ([object isKindOfClass:UIImage.class]) {
                    UIImage *image = (UIImage *)object;
                    if(image) {
                        
                    }
                }
            }];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
